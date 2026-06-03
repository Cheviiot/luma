#!/usr/bin/env python3
"""Проверка структурной целостности репозитория Luma."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def scalar(text: str, name: str, file: Path) -> str:
    match = re.search(rf"^{re.escape(name)}='([^']*)'", text, re.MULTILINE)
    if not match:
        raise ValueError(f"{file}: поле {name!r} не найдено")
    return match.group(1)


def number(text: str, name: str, file: Path) -> int:
    match = re.search(rf"^{re.escape(name)}=([0-9]+)", text, re.MULTILINE)
    if not match:
        raise ValueError(f"{file}: поле {name!r} не найдено")
    return int(match.group(1))


def array(text: str, name: str, file: Path) -> list[str]:
    match = re.search(rf"^{re.escape(name)}=\((.*?)\)", text, re.MULTILINE | re.DOTALL)
    if not match:
        raise ValueError(f"{file}: массив {name!r} не найден")

    values = re.findall(r"'([^']*)'", match.group(1))
    if not values:
        raise ValueError(f"{file}: массив {name!r} пустой")
    return values


def update_script_packages() -> list[str]:
    text = read_text(ROOT / ".github/scripts/package-update.sh")
    match = re.search(r"^PACKAGES=\((.*?)\)", text, re.MULTILINE | re.DOTALL)
    if not match:
        raise ValueError(".github/scripts/package-update.sh: массив PACKAGES не найден")
    return re.findall(r"^\s*([a-z0-9][a-z0-9+_.-]*)\s*$", match.group(1), re.MULTILINE)


def readme_expected_count() -> int:
    text = read_text(ROOT / "README.md")
    match = re.search(r"<code>([0-9]+) пакетов</code>", text)
    if not match:
        raise ValueError("README.md: счетчик пакетов не найден")
    return int(match.group(1))


def release_ids() -> set[str]:
    text = read_text(ROOT / ".github/scripts/package-update.sh")
    match = re.search(r"latest_version\(\).*?case \"\$package\" in(.*?)\n\s*\*\) die", text, re.DOTALL)
    if not match:
        raise ValueError(".github/scripts/package-update.sh: case latest_version не найден")
    return set(re.findall(r"^\s*([a-z0-9][a-z0-9+_.-]*)\)", match.group(1), re.MULTILINE))


def optional_array(text: str, name: str) -> list[str]:
    match = re.search(rf"^{re.escape(name)}=\((.*?)\)", text, re.MULTILINE | re.DOTALL)
    if not match:
        return []
    return re.findall(r"'([^']*)'", match.group(1))


def main() -> int:
    errors: list[str] = []
    package_files = sorted(ROOT.glob("*/Staplerfile"))
    package_dirs = [path.parent.name for path in package_files]

    try:
        packages = update_script_packages()
        if packages != package_dirs:
            errors.append(
                ".github/scripts/package-update.sh: PACKAGES должен совпадать с каталогами пакетов "
                f"({packages!r} != {package_dirs!r})"
            )
    except ValueError as exc:
        errors.append(str(exc))
        packages = []

    try:
        ids = release_ids()
        missing = sorted(set(package_dirs) - ids)
        extra = sorted(ids - set(package_dirs))
        if missing:
            errors.append(f".github/scripts/package-update.sh: нет latest_version для {', '.join(missing)}")
        if extra:
            errors.append(f".github/scripts/package-update.sh: лишние latest_version case: {', '.join(extra)}")
    except ValueError as exc:
        errors.append(str(exc))

    try:
        expected_count = readme_expected_count()
        if expected_count != len(package_dirs):
            errors.append(f"README.md: счетчик пакетов {expected_count}, фактически {len(package_dirs)}")
    except ValueError as exc:
        errors.append(str(exc))

    readme = read_text(ROOT / "README.md")

    for file in package_files:
        text = read_text(file)
        rel = file.relative_to(ROOT)

        try:
            name = scalar(text, "name", rel)
            version = scalar(text, "version", rel)
            release = number(text, "release", rel)
            provides = array(text, "provides", rel)
            replaces = array(text, "replaces", rel)
            architectures = array(text, "architectures", rel)
        except ValueError as exc:
            errors.append(str(exc))
            continue

        if name != file.parent.name:
            errors.append(f"{rel}: name={name!r} не совпадает с каталогом {file.parent.name!r}")
        if release < 1:
            errors.append(f"{rel}: release должен быть >= 1")
        if name not in provides:
            errors.append(f"{rel}: provides не содержит короткое имя {name!r}")
        if name not in replaces:
            errors.append(f"{rel}: replaces не содержит короткое имя {name!r}")
        if len(provides) != len(set(provides)):
            errors.append(f"{rel}: provides содержит дубли")
        if len(replaces) != len(set(replaces)):
            errors.append(f"{rel}: replaces содержит дубли")
        if provides != replaces:
            errors.append(f"{rel}: provides и replaces должны совпадать")
        if not set(architectures).issubset({"all", "amd64", "arm64"}):
            errors.append(f"{rel}: неизвестные архитектуры {architectures!r}")
        if name in readme and version not in readme:
            errors.append(f"README.md: для {name} не указана версия {version}")

        sources = optional_array(text, "sources")
        sources_arm64 = optional_array(text, "sources_arm64")
        checksums = optional_array(text, "checksums")
        checksums_arm64 = optional_array(text, "checksums_arm64")
        if sources and len(sources) != len(checksums):
            errors.append(f"{rel}: sources/checksums разной длины")
        if sources_arm64 and len(sources_arm64) != len(checksums_arm64):
            errors.append(f"{rel}: sources_arm64/checksums_arm64 разной длины")

        if re.search(r"/opt/[a-z0-9+_.-]+/\*\*\*", text) and "portable.txt" in text:
            if "rm -f" not in text:
                errors.append(f"{rel}: пакет в /opt не должен оставлять portable.txt без удаления")

    if errors:
        print("Ошибки валидации репозитория:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print(f"OK: проверено пакетов: {len(package_dirs)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

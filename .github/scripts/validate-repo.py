#!/usr/bin/env python3
"""Проверка структурной целостности репозитория Luma."""

from __future__ import annotations

import re
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def scalar(text: str, name: str, file: Path) -> str:
    match = re.search(rf"^{re.escape(name)}=(['\"])(.*?)\1", text, re.MULTILINE | re.DOTALL)
    if not match:
        raise ValueError(f"{file}: поле {name!r} не найдено")
    return match.group(2)


def number(text: str, name: str, file: Path) -> int:
    match = re.search(rf"^{re.escape(name)}=([0-9]+)", text, re.MULTILINE)
    if not match:
        raise ValueError(f"{file}: поле {name!r} не найдено")
    return int(match.group(1))


def array(text: str, name: str, file: Path) -> list[str]:
    match = re.search(rf"^{re.escape(name)}=\((.*?)\)", text, re.MULTILINE | re.DOTALL)
    if not match:
        raise ValueError(f"{file}: массив {name!r} не найден")

    values = quoted_values(match.group(1))
    if not values:
        raise ValueError(f"{file}: массив {name!r} пустой")
    return values


def quoted_values(text: str) -> list[str]:
    return [match.group(2) for match in re.finditer(r"(['\"])(.*?)\1", text, re.DOTALL)]


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
    return quoted_values(match.group(1))


def script_paths(text: str) -> list[str]:
    match = re.search(r"^scripts=\((.*?)\)", text, re.MULTILINE | re.DOTALL)
    if not match:
        return []
    return [
        script.group(2)
        for script in re.finditer(r"\[['\"][^'\"]+['\"]\]=(['\"])(.*?)\1", match.group(1))
    ]


def local_source_path(source: str) -> str | None:
    real_source = source.split("?~", 1)[0].split("&~", 1)[0]
    if not real_source.startswith("local:///"):
        return None
    return real_source.removeprefix("local:///")


def executable(path: Path) -> bool:
    return path.is_file() and path.stat().st_mode & 0o111 != 0


def validate_repo_toml(errors: list[str]) -> None:
    repo_file = ROOT / "stapler-repo.toml"
    try:
        data = tomllib.loads(read_text(repo_file))
    except tomllib.TOMLDecodeError as exc:
        errors.append(f"stapler-repo.toml: TOML не разбирается: {exc}")
        return

    repo = data.get("repo")
    if not isinstance(repo, dict):
        errors.append("stapler-repo.toml: секция [repo] не найдена")
        return

    required = ("minVersion", "title", "summary", "description", "homepage", "icon", "url", "ref", "report_url")
    for field in required:
        value = repo.get(field)
        if not isinstance(value, str) or not value.strip():
            errors.append(f"stapler-repo.toml: поле repo.{field} должно быть непустой строкой")

    min_version = repo.get("minVersion", "")
    if isinstance(min_version, str) and not re.fullmatch(r"v[0-9]+(?:\.[0-9]+){2}", min_version):
        errors.append("stapler-repo.toml: repo.minVersion должен иметь формат vX.Y.Z")

    report_url = repo.get("report_url", "")
    if isinstance(report_url, str) and "{{ .BasePackageName }}" not in report_url:
        errors.append("stapler-repo.toml: repo.report_url должен содержать {{ .BasePackageName }}")


def validate_package_repo_toml(package_dir: Path, errors: list[str]) -> None:
    rel = package_dir.relative_to(ROOT) / "stapler-repo.toml"
    file = package_dir / "stapler-repo.toml"
    if not file.is_file():
        errors.append(f"{rel}: файл не найден")
        return
    try:
        data = tomllib.loads(read_text(file))
    except tomllib.TOMLDecodeError as exc:
        errors.append(f"{rel}: TOML не разбирается: {exc}")
        return
    if data.get("include") == "../stapler-repo.toml":
        return
    if isinstance(data.get("inherit"), dict):
        return
    errors.append(f"{rel}: должен использовать include = \"../stapler-repo.toml\" или секцию [inherit]")


def validate_codex_app_patches(errors: list[str]) -> None:
    file = ROOT / "codex-app" / "Staplerfile"
    if not file.is_file():
        return

    text = read_text(file)
    required_fragments = (
        (
            '"codexBuildFlavor": "prod"',
            "codex-app/Staplerfile: bootstrap app.asar должен передавать codexBuildFlavor=prod",
        ),
        (
            '"CodexBuildNumber": app_version.rsplit(".", 1)[-1]',
            "codex-app/Staplerfile: bootstrap app.asar должен передавать CodexBuildNumber из версии",
        ),
        (
            "electron_common_owl_features",
            "codex-app/Staplerfile: нужен runtime-патч для отсутствующего Electron Owl feature binding",
        ),
        (
            "isOwlFeatureEnabled:()=>!1",
            "codex-app/Staplerfile: Owl feature fallback должен безопасно отключать feature flags",
        ),
    )
    for fragment, error in required_fragments:
        if fragment not in text:
            errors.append(error)


def main() -> int:
    errors: list[str] = []
    package_files = sorted(ROOT.glob("*/Staplerfile"))
    package_dirs = [path.parent.name for path in package_files]
    validate_repo_toml(errors)

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
    validate_codex_app_patches(errors)

    for file in package_files:
        text = read_text(file)
        rel = file.relative_to(ROOT)

        try:
            name = scalar(text, "name", rel)
            version = scalar(text, "version", rel)
            summary = scalar(text, "summary", rel)
            summary_ru = scalar(text, "summary_ru", rel)
            group = scalar(text, "group", rel)
            desc = scalar(text, "desc", rel)
            desc_ru = scalar(text, "desc_ru", rel)
            homepage = scalar(text, "homepage", rel)
            maintainer = scalar(text, "maintainer", rel)
            release = number(text, "release", rel)
            license = array(text, "license", rel)
            provides = array(text, "provides", rel)
            replaces = array(text, "replaces", rel)
            architectures = array(text, "architectures", rel)
        except ValueError as exc:
            errors.append(str(exc))
            continue

        if name != file.parent.name:
            errors.append(f"{rel}: name={name!r} не совпадает с каталогом {file.parent.name!r}")
        for field_name, value in (
            ("summary", summary),
            ("summary_ru", summary_ru),
            ("group", group),
            ("desc", desc),
            ("desc_ru", desc_ru),
            ("homepage", homepage),
            ("maintainer", maintainer),
        ):
            if not value.strip():
                errors.append(f"{rel}: поле {field_name} не должно быть пустым")
        if release < 1:
            errors.append(f"{rel}: release должен быть >= 1")
        if "custom" in license:
            errors.append(f"{rel}: для нестандартной лицензии используйте `Custom`, а не `custom`")
        if "Custom" in license and "nonfree=1" not in text:
            errors.append(f"{rel}: license содержит `Custom`, но пакет не помечен как nonfree=1")
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
        for array_name, values in (("sources", sources), ("sources_arm64", sources_arm64)):
            for source in values:
                local_path = local_source_path(source)
                if local_path is not None and not (file.parent / local_path).is_file():
                    errors.append(f"{rel}: {array_name} ссылается на отсутствующий local:///{local_path}")

        validate_package_repo_toml(file.parent, errors)

        license_file = file.parent / "LICENSE"
        if not license_file.is_file():
            errors.append(f"{license_file.relative_to(ROOT)}: файл не найден")
        else:
            license_text = read_text(license_file)
            if "Сведения о лицензии пакета" not in license_text:
                errors.append(f"{license_file.relative_to(ROOT)}: должен содержать русское описание лицензии пакета")
            if "Нюансы пакета:" not in license_text:
                errors.append(f"{license_file.relative_to(ROOT)}: должен содержать раздел `Нюансы пакета:`")

        update_check = file.parent / ".stapler/update-check"
        if not executable(update_check):
            errors.append(f"{update_check.relative_to(ROOT)}: файл должен существовать и быть исполняемым")

        for script in script_paths(text):
            script_file = file.parent / script
            if not executable(script_file):
                errors.append(f"{script_file.relative_to(ROOT)}: script из массива scripts должен быть исполняемым")

        if f"[{name}](./{name})" not in readme and f"`{name}`" not in readme:
            errors.append(f"README.md: пакет {name} не найден в витрине или полной сводке")

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

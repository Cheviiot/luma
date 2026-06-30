#!/usr/bin/env python3
"""Apply the warment/hermes-desktop-ru locale to the Hermes Desktop source tree."""

from __future__ import annotations

import shutil
import sys
from pathlib import Path


SKILL_DESC_RU = """// Russian translations for known skill descriptions
const SKILL_DESC_RU: Record<string, string> = {
  'apple-notes': 'Управление Apple Notes через memo CLI: создание, поиск, редактирование.',
  'apple-reminders': 'Apple Reminders через remindctl: добавление, просмотр, выполнение.',
  'findmy': 'Отслеживание устройств Apple/AirTags через FindMy.app на macOS.',
  'imessage': 'Отправка и получение iMessages/SMS через imsg CLI на macOS.',
  'macos-operations': 'Полная поддержка macOS: автоматизация рабочего стола, диагностика, интеграции Apple и общие CLI-паттерны.',
  'claude-code': 'Делегирование задач Claude Code CLI.',
  'hermes-agent': 'Настройка, расширение или вклад в Hermes Agent.',
  'opencode': 'Делегирование задач OpenCode CLI.'
}

function localizedDescription(skill: { description?: string | Record<string, string> }, locale: string): string {
  if (locale !== 'ru') return asText(skill.description)
  const name = asText((skill as { name?: string }).name ?? '')
  return SKILL_DESC_RU[name] || asText(skill.description)
}
"""


def replace_once(path: Path, old: str, new: str) -> bool:
    text = path.read_text()
    if old not in text:
        return False
    path.write_text(text.replace(old, new, 1))
    return True


def add_locale_to_types(path: Path) -> None:
    text = path.read_text()
    if any("'ru'" in line for line in text.split("\n", 10)[:10]):
        return
    old = "export type Locale = 'en' | 'zh' | 'zh-hant' | 'ja'"
    new = "export type Locale = 'en' | 'zh' | 'zh-hant' | 'ja' | 'ru'"
    if old not in text:
        raise SystemExit(f"Unsupported Locale declaration in {path}")
    path.write_text(text.replace(old, new, 1))


def add_locale_to_languages(path: Path) -> None:
    text = path.read_text()

    if "id: 'ru'" not in text:
        marker = "\n] as const satisfies"
        option = """,
  {
    id: 'ru',
    name: 'Русский',
    englishName: 'Russian',
    configValue: 'ru'
  }
] as const satisfies"""
        if marker not in text:
            raise SystemExit(f"Cannot find LOCALE_OPTIONS end in {path}")
        text = text.replace(marker, option, 1)

    if "'ru-ru': 'ru'" not in text:
        old = "  ja: 'ja',\n  'ja-jp': 'ja',\n  ja_jp: 'ja'\n}"
        new = """  ja: 'ja',
  'ja-jp': 'ja',
  ja_jp: 'ja',
  ru: 'ru',
  'ru-ru': 'ru',
  ru_ru: 'ru',
  'русский': 'ru'
}"""
        if old not in text:
            raise SystemExit(f"Cannot find LOCALE_ALIASES tail in {path}")
        text = text.replace(old, new, 1)

    path.write_text(text)


def add_locale_to_catalog(path: Path) -> None:
    text = path.read_text()

    if "import { ru } from './ru'" not in text:
        text = text.replace("import type { Locale, Translations } from './types'\n", "import { ru } from './ru'\nimport type { Locale, Translations } from './types'\n", 1)

    if "\n  ru\n}" not in text:
        old = "  'zh-hant': zhHant,\n  ja\n}"
        new = "  'zh-hant': zhHant,\n  ja,\n  ru\n}"
        if old not in text:
            raise SystemExit(f"Cannot find TRANSLATIONS tail in {path}")
        text = text.replace(old, new, 1)

    path.write_text(text)


def convert_ru_to_partial_locale(path: Path) -> None:
    text = path.read_text()
    text = text.replace(
        "import type { Translations } from './types'\n",
        """import { defineLocale } from './define-locale'
import type { TranslationOverrides } from './define-locale'

type LooseTranslationValue =
  | string
  | number
  | boolean
  | null
  | undefined
  | readonly unknown[]
  | ((...args: any[]) => string)
  | { [key: string]: LooseTranslationValue }

type LooseTranslationOverride<T> = T extends (...args: infer Args) => string
  ? (...args: Args) => string
  : T extends readonly unknown[]
    ? T
    : T extends string
      ? string
      : T extends object
        ? { [K in keyof T]?: LooseTranslationOverride<T[K]> } & Record<string, LooseTranslationValue>
        : T

type LooseTranslationOverrides = LooseTranslationOverride<TranslationOverrides>
""",
    )
    text = text.replace("export const ru: Translations = {", "const ruOverrides: LooseTranslationOverrides = {", 1)
    stripped = text.rstrip()
    if not stripped.endswith("}"):
        raise SystemExit(f"Unexpected ru.ts ending in {path}")
    text = stripped + "\n\nexport const ru = defineLocale(ruOverrides)\n"
    path.write_text(text)


def patch_skills(path: Path) -> None:
    text = path.read_text()
    if "SKILL_DESC_RU" in text:
        return

    if "const { t } = useI18n()" not in text:
        raise SystemExit(f"Cannot find useI18n destructuring in {path}")
    text = text.replace("const { t } = useI18n()", "const { t, locale } = useI18n()", 1)

    if "const SKILLS_MODES" not in text:
        raise SystemExit(f"Cannot find SKILLS_MODES marker in {path}")
    text = text.replace("const SKILLS_MODES", SKILL_DESC_RU + "\nconst SKILLS_MODES", 1)

    old = "{asText(skill.description) || t.skills.noDescription}"
    new = "{localizedDescription(skill, locale) || t.skills.noDescription}"
    if old not in text:
        raise SystemExit(f"Cannot find skill description render in {path}")
    text = text.replace(old, new, 1)

    path.write_text(text)


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("Usage: apply-hermes-ru.py <hermes-source-dir> <hermes-desktop-ru-dir>")

    hermes_dir = Path(sys.argv[1]).resolve()
    locale_dir = Path(sys.argv[2]).resolve()

    desktop = hermes_dir / "apps" / "desktop"
    i18n = desktop / "src" / "i18n"
    settings = desktop / "src" / "app" / "settings"

    if not i18n.is_dir():
        raise SystemExit(f"Hermes Desktop i18n directory not found: {i18n}")
    ru_source = locale_dir / "patches" / "ru.ts"
    constants_source = locale_dir / "patches" / "ru-constants.ts"
    if not ru_source.is_file():
        ru_source = locale_dir / "ru.ts"
        constants_source = locale_dir / "ru-constants.ts"

    if not ru_source.is_file() or not constants_source.is_file():
        raise SystemExit(f"Russian locale source not found: {locale_dir}")

    shutil.copy2(ru_source, i18n / "ru.ts")
    shutil.copy2(constants_source, settings / "ru-constants.ts")

    convert_ru_to_partial_locale(i18n / "ru.ts")
    add_locale_to_types(i18n / "types.ts")
    add_locale_to_languages(i18n / "languages.ts")
    add_locale_to_catalog(i18n / "catalog.ts")
    patch_skills(desktop / "src" / "app" / "skills" / "index.tsx")


if __name__ == "__main__":
    main()

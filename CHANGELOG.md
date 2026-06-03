## 2026-06-03 19:22 VLAT

### Изменено
- Увеличен `release` до `4` у `pineconemc` и `prismlauncher`, так как исправлены метаданные поиска/сопоставления установленного пакета.
- Для `pineconemc` добавлены явные `provides/replaces`: `pineconemc`, `pinecone-mc`, `elyprismlauncher`, `ely-prism-launcher`.
- Для `prismlauncher` добавлены явные `provides/replaces`: `prismlauncher`, `prism-launcher`.

### Добавлено
- Нет.

### Исправлено
- Исправлено поведение, при котором Stapler видел установленный RPM как `pineconemc+stplr-luma` или `prismlauncher+stplr-luma`, но не мог надежно сопоставить его с коротким именем/алиасом пакета.

### Проверено
- `stplr build --clean` для `pineconemc`: пакет `pineconemc+stplr-default-11.0.2-alt4.x86_64.rpm` собран успешно.
- `stplr build --clean` для `prismlauncher`: пакет `prismlauncher+stplr-default-11.0.2-alt4.x86_64.rpm` собран успешно.
- `rpm -qp --provides` подтвердил aliases `pineconemc`, `pinecone-mc`, `elyprismlauncher`, `ely-prism-launcher`, `prismlauncher`, `prism-launcher`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 19:10 VLAT

### Изменено
- Увеличен `release` до `3` у `pineconemc` и `prismlauncher`, так как исправлено runtime-поведение системной установки без изменения upstream-версии `11.0.2`.

### Добавлено
- Нет.

### Исправлено
- Из пакетов `pineconemc` и `prismlauncher` удаляется upstream-маркер `portable.txt`, из-за которого лаунчеры запускались в portable-режиме и пытались писать логи/данные в `/opt/pineconemc` и `/opt/prismlauncher`.
- Системная установка теперь должна использовать пользовательскую директорию данных вместо read-only каталога приложения в `/opt`.

### Проверено
- `stplr build --clean` для `pineconemc`: пакет `pineconemc+stplr-default-11.0.2-alt3.x86_64.rpm` собран успешно.
- `stplr build --clean` для `prismlauncher`: пакет `prismlauncher+stplr-default-11.0.2-alt3.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил, что `/opt/pineconemc` и `/opt/prismlauncher` остались в RPM, а `portable.txt` больше не входит в оба пакета.
- `rpm -qpl` подтвердил наличие CLI-оберток, desktop-файлов, MIME XML и AppStream metainfo в обоих пакетах.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 19:05 VLAT

### Изменено
- Увеличен `release` до `2` у `pineconemc` и `prismlauncher`, так как исправлена упаковка без изменения upstream-версии `11.0.2`.
- В `files()` для `pineconemc` и `prismlauncher` явно добавлены `/opt` и базовые директории приложений: `/opt/pineconemc`, `/opt/prismlauncher`.

### Добавлено
- Нет.

### Исправлено
- Исправлена установка PineconeMC и Prism Launcher на системах, где менеджер пакетов не создавал базовую директорию приложения в `/opt` из-за отсутствия явного ownership в RPM.

### Проверено
- `stplr build --clean` для `pineconemc`: пакет `pineconemc+stplr-default-11.0.2-alt2.x86_64.rpm` собран успешно.
- `stplr build --clean` для `prismlauncher`: пакет `prismlauncher+stplr-default-11.0.2-alt2.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил, что оба RPM теперь явно содержат `/opt`, `/opt/pineconemc` и `/opt/prismlauncher`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 18:53 VLAT

### Изменено
- Обновлен `README.md`: количество пакетов увеличено до 14, PineconeMC добавлен в игровой раздел каталога и полную сводку.
- Подключен `pineconemc` к `.github/scripts/package-update.sh` и общей команде `check-all`.

### Добавлено
- Добавлен пакет `pineconemc` версии `11.0.2` для архитектур `amd64` и `arm64`.
- Добавлены `pineconemc/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и SVG-иконка.
- Сборка использует официальные portable Qt6 tar.gz из релиза `ElyPrismLauncher/Launcher` и устанавливает `/opt/pineconemc`, `/usr/bin/pineconemc`, `/usr/bin/elyprismlauncher`, desktop-файл, AppStream metainfo, MIME-описание, manpage и hicolor-иконки.

### Исправлено
- Для PineconeMC добавлена системная регистрация MIME, desktop database, hicolor icon cache и KDE sycoca после установки и удаления.
- Распаковка PineconeMC выполняется с `tar --no-same-owner --no-same-permissions`, чтобы upstream `uid/gid` из portable-архива не ломали сборку в fakeroot-среде.

### Проверено
- `stplr build --clean` для `pineconemc`: пакет `pineconemc+stplr-default-11.0.2-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` для PineconeMC: подтверждены `/usr/bin/pineconemc`, `/usr/bin/elyprismlauncher`, desktop-файл, MIME XML, AppStream metainfo, manpage и hicolor-иконки.
- `.github/scripts/package-update.sh check pineconemc`: `11.0.2 11.0.2`.
- `.github/scripts/package-update.sh check-all`: все 14 пакетов в статусе `current`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4`, `git diff --check` и Python-сверка README/TOML.

### Осталось
- Нет.

## 2026-06-03 18:41 VLAT

### Изменено
- Обновлен `README.md`: количество пакетов увеличено до 13, Prism Launcher добавлен в игровой раздел каталога и полную сводку.
- Подключен `prismlauncher` к `.github/scripts/package-update.sh` и общей команде `check-all`.
- Обновлен `github-plus` с `3.5.11.0` до `3.5.12.0` с пересчетом checksums для `amd64` и `arm64`.
- Уточнена проверка Windsurf: transitional-пакет `windsurf -> devin-desktop` больше не считается обновлением текущего пакета `windsurf`.

### Добавлено
- Добавлен пакет `prismlauncher` версии `11.0.2` для архитектур `amd64` и `arm64`.
- Добавлены `prismlauncher/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и SVG-иконка.
- Сборка использует официальные portable Qt6 tar.gz из релиза `PrismLauncher/PrismLauncher` и устанавливает `/opt/prismlauncher`, `/usr/bin/prismlauncher`, desktop-файл, AppStream metainfo, MIME-описание, manpage и hicolor-иконки.

### Исправлено
- Для Prism Launcher добавлена системная регистрация MIME, desktop database, hicolor icon cache и KDE sycoca после установки и удаления.
- Распаковка Prism Launcher выполняется с `tar --no-same-owner --no-same-permissions`, чтобы upstream `uid/gid` из portable-архива не ломали сборку в fakeroot-среде.

### Проверено
- `stplr build --clean` для `prismlauncher`: пакет `prismlauncher+stplr-default-11.0.2-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` для Prism Launcher: подтверждены `/usr/bin/prismlauncher`, desktop-файл, MIME XML, AppStream metainfo, manpage и hicolor-иконки.
- `stplr build --clean` для `github-plus`: пакет `github-plus+stplr-default-3.5.12.0-alt1.x86_64.rpm` собран успешно.
- `.github/scripts/package-update.sh check-all`: все 13 пакетов в статусе `current`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4`, `git diff --check` и Python-сверка README/TOML.

### Осталось
- Нет.

## 2026-05-31 22:08 VLAT

### Изменено
- README полностью переписан: добавлены компактный быстрый старт, табличная витрина с иконками, блок ключевых особенностей, полная сводка пакетов и отдельная секция сопровождения.
- Разделы установки, проверки, сборки и обновления версий приведены к единому читаемому формату.

### Добавлено
- Не применялось.

### Исправлено
- Убрана громоздкая HTML-витрина с повторяющимися карточками в пользу более плотной и удобной структуры.

### Проверено
- `git diff --check` прошел успешно.
- README сверён с текущими `Staplerfile`: все 12 пакетов и версии отражены в документе.

### Осталось
- Не применялось.

## 2026-05-31 22:06 VLAT

### Изменено
- Обновлены версии и checksums пакетов `clash-verge`, `github-plus`, `happ`, `hydralauncher`, `tailscale`, `terax`, `warp` и `windsurf`.
- README синхронизирован с актуальными версиями всех 12 пакетов.
- Усилен `.github/scripts/package-update.sh`: добавлены сетевые таймауты и корректная обработка отсутствующих optional-массивов `sources_arm64`/`checksums_arm64`.

### Добавлено
- Не применялось.

### Исправлено
- Исправлено зависание автообновлятора на сетевых запросах без верхнего лимита времени.
- Исправлено падение автообновлятора при обработке одноархитектурных пакетов без arm64-массивов.

### Проверено
- `.github/scripts/package-update.sh check-all` вернул `current` для всех 12 пакетов.
- `bash -n`, `shellcheck`, `shfmt -d -i 4`, `git diff --check` прошли успешно.
- TOML-файлы репозитория успешно разобраны через `tomllib`.
- `stplr build --clean` успешно выполнен для `clash-verge`, `github-plus`, `happ`, `hydralauncher`, `tailscale`, `terax`, `warp`, `windsurf` и `codex-app`.

### Осталось
- Не применялось.

## 2026-05-31 19:46 VLAT

### Изменено
- Расширен список пакетов автообновлятора: добавлен `codex-app`.
- README обновлен под каталог из 12 пакетов.
- Пакет `codex-app` теперь пересобирает bootstrap `app.asar`, чтобы отключить стандартное меню Electron.

### Добавлено
- Добавлен пакет `codex-app` для установки Linux-артефактов из `Boria138/codex-app-linux`.
- Добавлены postinstall/postremove-скрипты для прав исполняемых файлов, Electron sandbox, desktop-базы и кэша иконок.
- Добавлены локальная иконка пакета, `.stapler/update-check`, `stapler-repo.toml` и описание лицензирования upstream-артефактов.

### Исправлено
- Исправлено появление верхнего меню Electron `File`/`Edit` и связанных пунктов в Linux-окне `codex-app`.

### Проверено
- `bash -n` для `Staplerfile`, shell-скриптов и `.stapler/*` прошел успешно.
- `shellcheck` прошел успешно.
- `shfmt -d -i 4` не выявил изменений форматирования.
- `git diff --check` прошел успешно.
- TOML-файлы репозитория успешно разобраны через `tomllib`.
- `codex-app/.stapler/update-check` вернул `26.506.31421 26.506.31421`.
- `cd codex-app && stplr build --clean` успешно скачал реальные upstream sources, проверил checksum и собрал пакет.
- Из собранного RPM извлечен `/opt/codex-app/resources/app.asar`; bootstrap содержит отключение `Menu.setApplicationMenu`, `setMenu(null)` и `setMenuBarVisibility(false)`.

### Осталось
- Обновить ранее найденные устаревшие пакеты отдельной итерацией.

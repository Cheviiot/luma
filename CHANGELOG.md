## 2026-06-03 21:15 VLAT

### Изменено
- Увеличен `release` у `codex-app` до `3`, так как исправлено runtime-поведение без изменения upstream-версии `26.506.31421`.
- `/usr/bin/codex-app` теперь устанавливается как wrapper-скрипт вместо прямой ссылки на `/opt/codex-app/codex-app`.
- Bootstrap Electron в `app.asar` теперь выставляет локализованный путь документов через `app.setPath("documents", ...)` до загрузки основного `codex.asar`.

### Добавлено
- Wrapper определяет существующую пользовательскую директорию документов через `xdg-user-dir DOCUMENTS` и предпочитает `~/Документы`, если XDG возвращает английский дефолт `~/Documents`.
- Для дочерних процессов выставляются `CODEX_APP_DOCUMENTS_DIR` и `XDG_DOCUMENTS_DIR`.

### Исправлено
- Исправлено создание английской папки `~/Documents` при запуске `codex-app` на системах, где уже используется локализованная папка `~/Документы`.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 16 пакетов.
- `stplr build --clean` для `codex-app`: пакет `codex-app+stplr-default-26.506.31421-alt3.x86_64.rpm` собран успешно.
- `rpm -qpi` подтвердил версию `26.506.31421` и релиз `alt3`.
- `rpm -qpl` подтвердил наличие `/usr/bin/codex-app`, `/opt/codex-app/resources/app.asar` и desktop-файла.
- `rpm -qp --provides` подтвердил короткие имена `codex-app` и `codex`.
- Из собранного RPM извлечен `/usr/bin/codex-app`: wrapper выбирает XDG Documents, предпочитает `~/Документы` и запускает `/opt/codex-app/codex-app`.
- Из собранного RPM извлечен `/opt/codex-app/resources/app.asar`: bootstrap содержит `configureLocalizedDocumentsPath`, `app.setPath("documents", ...)`, `path.join(home, "Документы")` и прежнее отключение меню Electron.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 21:01 VLAT

### Изменено
- Обновлен `README.md`: количество пакетов увеличено до 16, NetBird UI добавлен в раздел `Сеть и VPN` и полную сводку.
- Подключен `netbird-ui` к `.github/scripts/package-update.sh` и общей команде `check-all`.

### Добавлено
- Добавлен пакет `netbird-ui` версии `0.71.4` для архитектуры `amd64`.
- Добавлены `netbird-ui/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и PNG-иконка.
- Сборка использует официальный `.deb` `netbird-ui_0.71.4_linux_amd64.deb` из релиза `netbirdio/netbird`, устанавливает `/usr/bin/netbird-ui`, desktop-файл и иконки.
- В `postinstall.sh` добавлена проверка наличия CLI/daemon `netbird` с понятным предупреждением, если пользователь поставил только UI.

### Исправлено
- Нет.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 16 пакетов.
- `.github/scripts/package-update.sh check netbird-ui`: локальная и upstream-версии совпадают, `0.71.4 0.71.4`.
- `.github/scripts/package-update.sh check-all`: все 16 пакетов в статусе `current`.
- `stplr build --clean` для `netbird-ui`: пакет `netbird-ui+stplr-default-0.71.4-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил наличие `/usr/bin/netbird-ui`, desktop-файла, hicolor-иконки и pixmap-иконки.
- `rpm -qp --provides` подтвердил короткое имя `netbird-ui`.
- `rpm -qp --requires` подтвердил системные зависимости `glibc`, `libGL`, `libX11` и `libxcb`.
- `rpm -qp --scripts` подтвердил postinstall/postremove-скрипты с обновлением desktop/icon cache и предупреждением при отсутствии `netbird`.

### Осталось
- Linux arm64 для NetBird UI не добавлен, так как upstream-релиз `v0.71.4` публикует UI-артефакт для Linux только под `amd64`.

## 2026-06-03 20:07 VLAT

### Изменено
- Обновлен `README.md`: количество пакетов увеличено до 15, NetBird добавлен в раздел `Сеть и VPN` и полную сводку.
- Подключен `netbird` к `.github/scripts/package-update.sh` и общей команде `check-all`.

### Добавлено
- Добавлен пакет `netbird` версии `0.71.4` для архитектур `amd64` и `arm64`.
- Добавлены `netbird/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и PNG-иконка.
- Сборка использует официальные `.deb` из релиза `netbirdio/netbird` и устанавливает `/usr/bin/netbird`; сервис создается upstream-командой `netbird service install` на этапе postinstall.

### Исправлено
- Нет.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 15 пакетов.
- `.github/scripts/package-update.sh check netbird`: локальная и upstream-версии совпадают, `0.71.4 0.71.4`.
- `.github/scripts/package-update.sh check-all`: все 15 пакетов в статусе `current`.
- `stplr build --clean` для `netbird`: пакет `netbird+stplr-default-0.71.4-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил наличие `/usr/bin/netbird` и PNG-иконки в hicolor.
- `rpm -qp --provides` подтвердил короткое имя `netbird`.
- `rpm -qp --scripts` подтвердил POSIX-совместимые postinstall/postremove-скрипты с установкой и удалением сервиса через `netbird service ...`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 19:33 VLAT

### Изменено
- В `.github/workflows/ci.yml` добавлен отдельный шаг проверки метаданных пакетов.
- В `.github/workflows/update-packages.yml` добавлен запуск проверки метаданных после автоматического обновления версий.

### Добавлено
- Добавлен `.github/scripts/validate-repo.py` — структурный валидатор репозитория.
- Валидатор проверяет синхронизацию списка пакетов с `.github/scripts/package-update.sh`, наличие `latest_version` для каждого пакета, счетчик пакетов в `README.md`, обязательные `provides/replaces`, совпадение `provides` и `replaces`, длину `sources/checksums`, архитектуры и отсутствие неочищенного `portable.txt` в системных `/opt`-пакетах.

### Исправлено
- Нет.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 14 пакетов.
- `python3 -m py_compile .github/scripts/validate-repo.py`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-03 19:26 VLAT

### Изменено
- Для всех пакетов каталога стандартизированы явные `provides/replaces`, чтобы Stapler и системный пакетный менеджер могли сопоставлять установленный пакет по короткому имени и распространенным upstream-алиасам.
- Увеличен `release` до `2` у пакетов, где aliases добавлены или расширены: `adwyra`, `clash-verge`, `codex-app`, `github-plus`, `happ`, `hydralauncher`, `tailscale`, `terax`, `vanyavpn`, `vual`, `warp`, `windsurf`.

### Добавлено
- Добавлены aliases: `codex`, `happ-desktop`, `hydra-launcher`, `tailscaled`, `terax-ai`, `warp-terminal`, `visual-studio-windsurf`, `github-desktop-plus`, `clash-verge-rev` и короткие имена соответствующих пакетов.

### Исправлено
- Исправлена общая проблема, при которой Stapler мог видеть установленный RPM только по имени с суффиксом репозитория, но не мог надежно сопоставить его с коротким именем пакета.

### Проверено
- Python-сверка подтвердила, что все 14 `Staplerfile` содержат явные `provides/replaces`, а `provides` у каждого пакета включает короткое имя пакета.
- `stplr build --clean` и `rpm -qp --provides` выполнены для `adwyra`, `clash-verge`, `codex-app`, `github-plus`, `happ`, `hydralauncher`, `tailscale`, `terax`, `vanyavpn`, `vual`, `warp`, `windsurf`.
- `rpm -qp --provides` подтвердил короткие имена и aliases: `adwyra`, `clash-verge`, `codex-app`, `github-plus`, `happ`, `hydralauncher`, `tailscale`, `terax`, `vanyavpn`, `vual`, `warp`, `windsurf`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

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

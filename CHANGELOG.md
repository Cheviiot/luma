## 2026-06-18 19:59 VLAT

### Изменено
- У `codex-app` увеличен `release` до `6`, так как исправлена доступность Linux target для меню открытия файлов без изменения upstream-версии `26.611.62324`.

### Добавлено
- Для `codex-app` добавлен Linux-вариант `fileManager` target с подписью `File Manager`, нейтральной Linux-иконкой папки и открытием через системный обработчик Electron.

### Исправлено
- Исправлен пустой выпадающий список у кнопки `Open in default app` в открытом проекте: на Linux теперь есть доступный пункт `File Manager`, даже если сторонние IDE не обнаружены.

### Проверено
- `bash -n codex-app/Staplerfile` прошел успешно.
- `stplr build --clean --script /home/cheviiot/Документы/GitHub/Luma/codex-app/Staplerfile` успешно собрал `codex-app+stplr-default-26.611.62324-alt6.x86_64.rpm`.
- Из собранного RPM потоково проверен `/opt/codex-app/resources/codex.asar`: в `.vite/build/main-DLo8G5hp.js` присутствует `linux:{label:\`File Manager\`,icon:\`apps/file-explorer.png\`,detect:()=>\`system-default\`,args:e=>To(e),open:async({path:e})=>HA(e)}`, а старая запись `fileManager` без Linux-ветки отсутствует.
- Повторно проверена встроенная иконка `webview/apps/file-explorer.png`: SHA256 `6e738a6ba5a8f0ca4a4922ccc6e933125ba3f22cd21296b2adfe9b7ec7896c97`, integrity в ASAR совпадает.
- `.github/scripts/package-update.sh check codex-app` вернул `26.611.62324 26.611.62324`.
- `python3 -m py_compile .github/scripts/validate-repo.py` и `.github/scripts/validate-repo.py` прошли успешно; валидатор проверил 12 пакетов.
- `git diff --check` прошел успешно.

### Осталось
- Нет.

## 2026-06-18 19:56 VLAT

### Изменено
- У `codex-app` увеличен `release` до `5`, так как исправлен встроенный asset интерфейса без изменения upstream-версии `26.611.62324`.

### Добавлено
- Нет.

### Исправлено
- В `codex-app` заменен `webview/apps/file-explorer.png`: вместо Windows Explorer-style иконки теперь используется нейтральная Linux/GTK-папка для `Default app` и связанных fallback-сценариев открытия файлов.
- В сборочный патч добавлена обязательная проверка замены иконки, чтобы при изменении структуры upstream ASAR сборка падала явно.

### Проверено
- `bash -n codex-app/Staplerfile` прошел успешно.
- `stplr build --clean --script /home/cheviiot/Документы/GitHub/Luma/codex-app/Staplerfile` успешно собрал `codex-app+stplr-default-26.611.62324-alt5.x86_64.rpm`.
- Из собранного RPM потоково проверен `/opt/codex-app/resources/codex.asar`: файл `webview/apps/file-explorer.png` имеет формат PNG 48x48, размер 1564 байта, SHA256 `6e738a6ba5a8f0ca4a4922ccc6e933125ba3f22cd21296b2adfe9b7ec7896c97`; integrity в ASAR совпадает.
- `.github/scripts/package-update.sh check codex-app` вернул `26.611.62324 26.611.62324`.
- `python3 -m py_compile .github/scripts/validate-repo.py` и `.github/scripts/validate-repo.py` прошли успешно; валидатор проверил 12 пакетов.
- `git diff --check` прошел успешно.

### Осталось
- Нет.

## 2026-06-18 19:23 VLAT

### Изменено
- У `codex-app` увеличен `release` до `4`, так как исправлены Linux-формулировки интерфейса без изменения upstream-версии `26.611.62324`.

### Добавлено
- Нет.

### Исправлено
- В `codex-app` заменены видимые macOS/Mac-формулировки в базовых строках интерфейса: настройка Dock icon, настройка menu bar, подсказка `Cmd/Ctrl+Shift+Enter`, описание Computer Use и подпись инструмента списка приложений.
- В webview-локалях `codex-app` активные Linux/desktop-ключи мобильного подключения и удаленного доступа теперь используют PC/Windows fallback-строки, если они есть.
- В русской локали `codex-app` активные ключи мобильного подключения, удаленного доступа и Computer Use теперь используют `ПК`/`компьютер` вместо `Mac`.

### Проверено
- `bash -n codex-app/Staplerfile` прошел успешно.
- `stplr build --clean --script /home/cheviiot/Документы/GitHub/Luma/codex-app/Staplerfile` успешно собрал `codex-app+stplr-default-26.611.62324-alt4.x86_64.rpm`.
- Из собранного RPM потоково проверен `/opt/codex-app/resources/codex.asar`: присутствуют маркеры `Preferred Linux app icon`, `Whether the app menu bar is shown`, `Press Ctrl+Shift+Enter`, `Control Linux desktop apps through Computer Use`, `List PC apps`.
- В `webview/assets/ru-RU-*.js` из собранного ASAR проверены активные ключи `codexMobile`, `settings.remoteConnections.localHost.keepLive.label` и `codex.mcpTool.computerUse.listMacApps`: значения больше не содержат `Mac` или `macOS`.
- `.github/scripts/package-update.sh check codex-app` вернул `26.611.62324 26.611.62324`.
- `python3 -m py_compile .github/scripts/validate-repo.py` и `.github/scripts/validate-repo.py` прошли успешно; валидатор проверил 12 пакетов.
- `git diff --check` прошел успешно.

### Осталось
- Нет.

## 2026-06-18 19:13 VLAT

### Изменено
- У `codex-app` увеличен `release` до `3`, так как исправлено runtime-поведение без изменения upstream-версии `26.611.62324`.

### Добавлено
- Нет.

### Исправлено
- Исправлено открытие файлов из чата `codex-app`: вложения, markdown-ссылки на файлы и `@file`-упоминания теперь запрашивают внутреннюю боковую панель приложения, а не системный обработчик файлов.
- В сборочный патч добавлена обязательная проверка трех замен для открытия файлов внутри окна, чтобы при изменении upstream-бандла сборка падала явно.

### Проверено
- `bash -n codex-app/Staplerfile` прошел успешно.
- `stplr build --clean --script /home/cheviiot/Документы/GitHub/Luma/codex-app/Staplerfile` успешно собрал `codex-app+stplr-default-26.611.62324-alt3.x86_64.rpm`.
- Из собранного RPM потоково проверен `/opt/codex-app/resources/codex.asar`: маркеры `openInSidePanel:!0`, `openFileLinksInSidePanel:!0` и `openInSidePanel:!0},\`${t}-file-${d}\`` присутствуют; старые условия `openInSidePanel:I(d)===\`pptx\`` и `openFileLinksInSidePanel:g.trim().startsWith(\`$\`)` отсутствуют.
- `.github/scripts/package-update.sh check codex-app` вернул `26.611.62324 26.611.62324`.
- `.github/scripts/validate-repo.py` проверил 12 пакетов.
- `git diff --check` прошел успешно.

### Осталось
- Нет.

## 2026-06-18 18:43 VLAT

### Изменено
- Репозиторий сокращен до 12 поддерживаемых пакетов.
- `README.md` обновлен: удалены строки каталога, полной сводки и примеров установки для снятых пакетов.
- `.github/scripts/package-update.sh` больше не проверяет и не обновляет снятые пакеты.

### Добавлено
- Нет.

### Исправлено
- Нет.

### Удалено
- Сняты с поддержки и удалены пакеты `windsurf`, `warp`, `terax`, `prismlauncher`, `netbird-ui`, `modrinth-app`, `hydralauncher`.
- Удалены витринные иконки снятых пакетов из `.github/assets/apps`.

### Проверено
- `python3 -m py_compile .github/scripts/validate-repo.py` прошел успешно.
- `.github/scripts/validate-repo.py` проверил 12 оставшихся пакетов.
- `.github/scripts/package-update.sh check-all` завершился успешно: все 12 оставшихся пакетов имеют статус `current`.
- `.github/scripts/package-update.sh check vual` дополнительно вернул `0.3.1 0.3.1` после единичного сетевого retry в общем `check-all`.
- `bash -n` для оставшихся `Staplerfile`, shell-скриптов и `.stapler/update-check` прошел успешно.
- `git diff --check` прошел успешно.

### Осталось
- Нет.

## 2026-06-18 18:33 VLAT

### Изменено
- `README.md` обновлен под 19 пакетов: Mindustry добавлен в каталог игр и полную сводку.
- `.github/scripts/package-update.sh` подключен к странице загрузки itch.io и проверяет версию Linux-архива `[Linux-64bit]Mindustry.zip`.

### Добавлено
- Добавлен пакет `mindustry` версии `158.1` для архитектуры `amd64`.
- Добавлены `mindustry/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и PNG-иконка.
- Пакет скачивает официальный Linux-архив itch.io через публичный download-flow, проверяет SHA256, устанавливает `/opt/mindustry`, wrapper `/usr/bin/mindustry`, desktop-файл, hicolor-иконку и лицензионные заметки.

### Исправлено
- Нет.

### Проверено
- Официальная страница itch.io проверена: Linux upload `1615336` содержит `[Linux-64bit]Mindustry.zip` версии `158.1`.
- SHA256 для Linux zip itch.io и иконки `icon_64.png` рассчитаны по фактически скачанным источникам.
- `stplr build --clean --script /home/cheviiot/Документы/GitHub/Luma/mindustry/Staplerfile` успешно собрал RPM; в пакете 70 файлов, включая `/opt/mindustry/Mindustry`, встроенную JRE, desktop-файл, иконку и лицензионные заметки.
- `.github/scripts/package-update.sh check mindustry` вернул `158.1 158.1`; `.github/scripts/validate-repo.py` проверил 19 пакетов.

### Осталось
- Нет.

## 2026-06-18 17:54 VLAT

### Изменено
- У `codex-app` увеличен `release` до `2`, так как исправлено runtime-поведение без изменения upstream-версии `26.611.62324`.
- Bootstrap-патч `codex-app` больше не обнуляет Electron application menu; теперь он только скрывает нативную строку меню окна.

### Добавлено
- Нет.

### Исправлено
- Исправлена работа встроенного меню нового интерфейса `codex-app` (`File`/`Edit`/`View`/`Help`): пункты снова могут открывать Electron-подменю через IPC `showApplicationMenu`.

### Проверено
- Разобран `codex.asar` версии `26.611.62324`: встроенное меню вызывает `Menu.getApplicationMenu()?.getMenuItemById(menuId)?.submenu.popup(...)`, поэтому прежний патч `Menu.setApplicationMenu(null)` ломал обработку кликов.

### Осталось
- Нет.

## 2026-06-18 17:05 VLAT

### Изменено
- Обновлен `codex-app` с `26.608.12217` до `26.611.62324`; контрольная сумма основного upstream-артефакта пересчитана по актуальному источнику.
- Обновлен `hydralauncher` с `4.0.0` до `4.0.1`; контрольная сумма AppImage пересчитана по актуальному релизу.
- В `README.md` синхронизированы версии `codex-app` и `hydralauncher` в каталоге и полной сводке пакетов.
- Патч `codex-app` для русской папки `Документы` обновлен под новую структуру `codex.asar` в версии `26.611.62324`.

### Добавлено
- Нет.

### Исправлено
- Нет.

### Проверено
- `.github/scripts/package-update.sh check-all` с `GITHUB_TOKEN` нашел обновления только для `codex-app` и `hydralauncher`; остальные 16 пакетов совпали с актуальными источниками.
- `.github/scripts/package-update.sh apply-all` применил доступные обновления и пересчитал SHA256 по реальным источникам.
- Актуальный архив `codex-app-26.611.62324-x86_64.tar.gz` скачан напрямую, SHA256 совпал с `Staplerfile`; asar-патч успешно применился к свежему `codex.asar` и добавил две ссылки на `CODEX_APP_DOCUMENTS_DIR`.
- `hydralauncher_4.0.1_amd64.deb` проверен по содержимому: внутри есть `/opt/Hydra/hydralauncher`, desktop-файл и hicolor-иконка.

### Осталось
- Нет.

## 2026-06-15 11:28 VLAT

### Изменено
- Полностью переработан `README.md`: обновлена центральная шапка, добавлены статусные бейджи, улучшены вводный блок, быстрый старт, каталог, сводка и раздел сопровождения.
- В каталог пакетов добавлена отдельная колонка `Первоисточник` со ссылками на официальные сайты или upstream-репозитории.
- Таблицы выровнены по назначению колонок: версии и архитектуры центрированы, ссылки и команды оставлены читаемыми.
- Разделы качества, структуры пакета, проверок, сборки и обновления версий сведены в более строгий формат.

### Добавлено
- Сводный блок `Обзор` с назначением репозитория, источниками, контролем, обновлениями и ссылкой на GitHub Issues.

### Исправлено
- Нет.

### Проверено
- `python3 -m py_compile .github/scripts/validate-repo.py` и `.github/scripts/validate-repo.py` прошли успешно.
- `git diff --check` прошел успешно.
- Дополнительная проверка подтвердила, что строки каталога и полной сводки README совместимы с шаблонами `.github/scripts/package-update.sh`.

### Осталось
- Нет.

## 2026-06-14 22:50 VLAT

### Изменено
- Обновлены версии и контрольные суммы пакетов `codex-app` `26.608.12217`, `github-plus` `3.5.13.0`, `happ` `2.17.1`, `hydralauncher` `4.0.0`, `modrinth-app` `0.14.6`, `netbird` `0.72.4`, `netbird-ui` `0.72.4`, `terax` `0.8.0`, `warp` `0.2026.06.10.09.27.stable.01`.
- Для обновленных пакетов сброшен `release` до `1`.
- В `README.md` синхронизированы версии в каталоге и сводной таблице.
- Патч `codex-app` для каталога документов сделан устойчивым к новому имени Vite-бандла и новой функции `documentsDir fallback`.

### Добавлено
- Нет.

### Исправлено
- Исправлена сборка `codex-app` `26.608.12217`, где старый патч искал удаленный upstream-файл `.vite/build/main-DnQgBHvi.js`.

### Проверено
- `.github/scripts/package-update.sh apply-all` применил доступные обновления и пересчитал SHA256 по реальным источникам.
- `.github/scripts/package-update.sh check-all` с `GITHUB_TOKEN` подтвердил статус `current` для всех 18 пакетов.
- `stplr build` успешно собрал RPM для `codex-app`, `github-plus`, `happ`, `hydralauncher`, `modrinth-app`, `netbird`, `netbird-ui`, `terax`, `warp`.
- `python3 -m py_compile .github/scripts/validate-repo.py` и `.github/scripts/validate-repo.py` прошли успешно.
- `bash -n`, `shellcheck`, `shfmt -d` и `git diff --check` прошли успешно.

### Осталось
- Нет.

## 2026-06-06 19:10 VLAT

### Изменено
- У `modrinth-app` увеличен `release` до `3`, так как исправлены устанавливаемые desktop/icon-файлы без изменения upstream-версии.
- Desktop-файл переименован в `/usr/share/applications/modrinth-app.desktop`.
- В desktop-файле `Icon=ModrinthApp` заменен на стабильное имя `Icon=modrinth-app`.

### Добавлено
- Добавлены hicolor-иконки `modrinth-app.png` в размерах `128x128`, `256x256` и `256x256@2`.
- Оставлены совместимые иконки `ModrinthApp.png`, чтобы старые кэши меню и сторонние окружения не теряли значок.

### Исправлено
- Исправлена ситуация, когда Modrinth App устанавливался и запускался, но меню приложений не показывало его иконку.

### Проверено
- `stplr build` собрал пакет `modrinth-app+stplr-default-0.14.4-alt3.x86_64.rpm`.
- `rpm -qpl` подтвердил наличие `/usr/share/applications/modrinth-app.desktop` и hicolor-иконок `modrinth-app.png`.
- Извлеченный desktop-файл содержит `Icon=modrinth-app`.
- `file` подтвердил корректные PNG-иконки `128x128` и `256x256`.
- `desktop-file-validate` не нашел ошибок в desktop-файле.
- `bash -n`, `.github/scripts/validate-repo.py`, `.github/scripts/package-update.sh check modrinth-app`, `modrinth-app/.stapler/update-check`, `shellcheck` и `shfmt -d` прошли успешно.

### Осталось
- Нет.

## 2026-06-06 18:03 VLAT

### Изменено
- `modrinth-app` переведен с перепаковки официального `.deb` на сборку актуального исходного кода `v0.14.4`.
- В `modrinth-app/Staplerfile` добавлены сборочные источники: архив `modrinth/code`, Node.js `24.15.0` только для этапа сборки и локально проверяемый Gradle `9.1.0`.
- В recipe добавлены `prepare()`, `build()` и ручная установка бинарника, desktop-файла, иконок и upstream-лицензий.
- Для Gradle-сборки Java-части Modrinth App отключен configuration cache, удален build-time-only toolchain resolver и отключен Spotless, так как форматирование не нужно для production-сборки Java-агента.
- Gradle wrapper переведен на локальный `gradle.zip` из `sources`, чтобы сборка не падала на 10-секундном таймауте загрузки Gradle во время `cargo build`.
- `modrinth-app/LICENSE` обновлен: описана причина сборки из исходников вместо официального Linux-бинарника.

### Добавлено
- Добавлены build-зависимости для Rust/Cargo, Java 17 JDK, WebKitGTK/GTK devel, OpenSSL, librsvg и базовых инструментов сборки.

### Исправлено
- Исправлен отказ запуска `ModrinthApp` на ALT p11: официальный бинарник `0.14.4` требовал `GLIBC_2.39`, а локальная система предоставляет `glibc 2.38`.
- Исправлена чистая сборка `modrinth-app` на ALT: `tar` больше не пытается восстанавливать владельцев из внешних архивов, Java 17 берется из `java-17-openjdk-devel`, а Gradle не скачивается внутри build step.

### Проверено
- `/usr/bin/ModrinthApp` из установленного прежнего пакета воспроизвел ошибку `GLIBC_2.39 not found`.
- AppImage `0.14.4` проверен и подтвердил ту же проблему `GLIBC_2.39`.
- Тестовая сборка из исходников `0.14.4` на ALT p11 с Node.js `24.15.0` и Rust `1.95.0` успешно собрала `target/release/theseus_gui`.
- Собранный на ALT бинарник требует максимум `GLIBC_2.34`, что совместимо с локальной `glibc 2.38`.
- `stplr build --clean` для `modrinth-app`: собран RPM `modrinth-app+stplr-default-0.14.4-alt2.x86_64.rpm`.
- `rpm -qpl` подтвердил наличие `/usr/bin/ModrinthApp`, desktop-файла, hicolor-иконок и upstream-лицензий.
- `rpm -qp --provides` подтвердил короткие имена `modrinth-app` и `modrinth`.
- `rpm -qp --requires` подтвердил явные ALT-зависимости `libgtk+3` и `libwebkit2gtk4.1`.
- Распакованный из RPM `/usr/bin/ModrinthApp` проверен через `strings`, `readelf` и `ldd`: максимум `GLIBC_2.34`, отсутствуют `not found` и требования `GLIBC_2.39`.

### Осталось
- Нет.

## 2026-06-06 17:11 VLAT

### Изменено
- README обновлен под 18 пакетов: Modrinth App добавлен в каталог игр и полную сводку.
- `.github/scripts/package-update.sh` подключен к GitHub Releases `modrinth/code` для проверки актуальной версии `modrinth-app`.

### Добавлено
- Добавлен пакет `modrinth-app` версии `0.14.4` для архитектуры `amd64`.
- Добавлены `modrinth-app/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и PNG-иконка витрины.
- Пакет использует официальный Linux `.deb` из GitHub Releases, устанавливает `/usr/bin/ModrinthApp`, desktop-файл и hicolor-иконки.
- Добавлены короткие имена `modrinth-app` и `modrinth` через `provides`/`replaces`.

### Исправлено
- Нет.

### Проверено
- Официальная страница Modrinth App и GitHub Releases сверены для выбора актуального Linux-артефакта.
- Официальные файлы `apps/app/LICENSE` и `apps/app/COPYING.md` сверены для лицензии GPL-3.0-only и ограничений бренда Modrinth.
- `.github/scripts/validate-repo.py`: проверено 18 пакетов.
- `.github/scripts/package-update.sh check modrinth-app` и `modrinth-app/.stapler/update-check`: локальная и upstream-версии совпадают, `0.14.4 0.14.4`.
- `stplr build --clean` для `modrinth-app`: пакет `modrinth-app+stplr-default-0.14.4-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил наличие `/usr/bin/ModrinthApp`, desktop-файла и hicolor-иконок.
- `rpm -qp --provides` подтвердил короткие имена `modrinth-app` и `modrinth`.
- `rpm -qp --requires` подтвердил ALT-зависимости `libgtk+3` и `libwebkit2gtk4.1`.
- `apt-cache policy` подтвердил наличие `libgtk+3` и `libwebkit2gtk4.1` в текущих репозиториях ALT.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-06 14:24 VLAT

### Изменено
- Все 17 файлов `*/LICENSE` переписаны на русском языке в формате сведений о лицензии пакета.
- В каждом `LICENSE` добавлены нюансы конкретного пакета: источник артефакта, тип перепаковки, несвободный статус, сервисные ограничения, внешние учетные записи/подписки и особенности распространения.
- Русифицированы `nonfree_msg` у `codex-app`, `happ`, `parsec`, `vanyavpn` и `windsurf`.
- Увеличен `release` у `codex-app`, `happ`, `parsec`, `vanyavpn` и `windsurf`, так как изменены публичные metadata-сообщения без изменения upstream-версий.
- В `README.md` формулировки про источники, несвободные пакеты и `LICENSE` приведены к русскому виду.
- Уточнены русские комментарии в `codex-app`, `github-plus` и `vanyavpn`, где оставался термин `upstream`.
- `.github/scripts/validate-repo.py` теперь проверяет, что каждый `LICENSE` содержит русское описание лицензии и раздел `Нюансы пакета:`.

### Добавлено
- Нет.

### Исправлено
- Убраны англоязычные юридические блоки из пакетных `LICENSE`; вместо них оставлены русские описания и ссылки на официальные тексты лицензий или условия сервиса.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 17 пакетов.
- `python3 -m py_compile .github/scripts/validate-repo.py`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.
- `rg`-аудит подтвердил отсутствие старых англоязычных юридических блоков и термина `upstream` в `*/LICENSE`, `README.md` и пакетных `Staplerfile`.

### Осталось
- Нет.

## 2026-06-06 14:08 VLAT

### Изменено
- Увеличен `release` у `parsec` до `3`, так как уточнена совместимая JPEG-зависимость для ALT без изменения upstream-версии `150-97c`.
- В `parsec/Staplerfile` зависимость ALT `libjpeg` заменена на `libjpeg8`, соответствующую upstream-требованию `libjpeg8` из официального `.deb`.

### Добавлено
- Нет.

### Исправлено
- Исправлена потенциальная runtime-ошибка Parsec из-за установки обычного `libjpeg`, который в ALT предоставляет `libjpeg.so.62`, а не совместимый `libjpeg8`.

### Проверено
- `apt-cache search '^libjpeg'` подтвердил наличие `libjpeg8` в ALT.
- `apt-cache policy libjpeg8` подтвердил кандидата `3.0.3-alt1`.
- `rpm -q --provides libjpeg` показал, что обычный `libjpeg` предоставляет `libjpeg.so.62`, поэтому он не подходит под upstream-требование `libjpeg8`.
- `stplr build --clean` для `parsec`: пакет `parsec+stplr-default-150-97c-alt3.x86_64.rpm` собран успешно.
- `rpm -qp --requires` подтвердил, что RPM теперь требует `libjpeg8`.
- `apt-cache policy` подтвердил кандидатов в репозиториях ALT для всех ALT-зависимостей Parsec.
- `.github/scripts/validate-repo.py`: проверено 17 пакетов.
- `.github/scripts/package-update.sh check parsec`: локальная и upstream-версии совпадают, `150-97c 150-97c`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

## 2026-06-06 13:21 VLAT

### Изменено
- Увеличен `release` у `parsec` до `2`, так как исправлены зависимости для установки на ALT без изменения upstream-версии `150-97c`.
- В `parsec/Staplerfile` зависимость ALT `libavcodec` заменена на реальный пакет `libavcodec61`.

### Добавлено
- Нет.

### Исправлено
- Исправлена ошибка установки `parsec+stplr-luma`: `Depends: libavcodec но пакет не может быть установлен`.

### Проверено
- `apt-cache search '^libavcodec'` подтвердил наличие `libavcodec61` в ALT.
- `rpm -q --whatprovides 'libavcodec.so.61()(64bit)'` подтвердил пакет `libavcodec61`.
- `stplr build --clean` для `parsec`: пакет `parsec+stplr-default-150-97c-alt2.x86_64.rpm` собран успешно.
- `rpm -qp --requires` подтвердил, что RPM теперь требует `libavcodec61`, а не `libavcodec`.
- `rpm -q --whatprovides` подтвердил локальных провайдеров для всех ALT-зависимостей Parsec.
- `apt-cache policy` подтвердил кандидатов в репозиториях ALT для всех ALT-зависимостей Parsec.
- `.github/scripts/validate-repo.py`: проверено 17 пакетов.
- `.github/scripts/package-update.sh check parsec`: локальная и upstream-версии совпадают, `150-97c 150-97c`.

### Осталось
- Нет.

## 2026-06-06 13:10 VLAT

### Изменено
- Обновлен `README.md`: количество пакетов увеличено до 17, Parsec добавлен в раздел `Рабочий стол и игры` и полную сводку.
- `parsec` подключен к `.github/scripts/package-update.sh` и общей команде `check-all`; актуальная версия определяется из control metadata официального `.deb`.

### Добавлено
- Добавлен пакет `parsec` версии `150-97c` для архитектуры `amd64`.
- Добавлены `parsec/Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `postinstall.sh`, `postremove.sh`, `LICENSE` и PNG-иконка.
- Сборка использует официальный Linux `.deb` `https://builds.parsec.app/package/parsec-linux.deb`, устанавливает `/usr/bin/parsecd`, desktop-файл, hicolor-иконку и runtime-данные `/usr/share/parsec`.

### Исправлено
- Нет.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 17 пакетов.
- `.github/scripts/package-update.sh check parsec` и `parsec/.stapler/update-check`: локальная и upstream-версии совпадают, `150-97c 150-97c`.
- `stplr build --clean` для `parsec`: пакет `parsec+stplr-default-150-97c-alt1.x86_64.rpm` собран успешно.
- `rpm -qpl` подтвердил наличие `/usr/bin/parsecd`, desktop-файла, hicolor-иконки и `/usr/share/parsec`.
- `rpm -qp --provides` подтвердил короткие имена `parsec` и `parsecd`.
- `rpm -qp --requires` подтвердил системные зависимости `glibc`, `libGL`, `libX11`, `libcurl`, `libavcodec`, `libalsa`, `libssl3`, `libvulkan1` и другие runtime-библиотеки.
- `rpm -qp --scripts` подтвердил postinstall/postremove-скрипты с обновлением desktop/icon cache.
- В временной копии репозитория: `package-update.sh apply parsec` после искусственного отката версии `150-97c -> 150-old`, README и `Staplerfile` вернулись к `150-97c`, валидатор прошел 17 пакетов.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Отдельно обновить пакеты, которые уже имеют новые upstream-версии по `check-all`: `codex-app`, `netbird`, `netbird-ui`, `warp`.

## 2026-06-03 21:46 VLAT

### Изменено
- `.github/scripts/package-update.sh` теперь после `apply` и `apply-all` синхронизирует строки обновленного пакета в README: версию, лицензии и архитектуры в витрине и полной сводке.
- `.github/workflows/update-packages.yml` обновлен для более надежной работы на GitHub runner: добавлены `ca-certificates`, `file` и FUSE-библиотека для AppImage-проверок, а `peter-evans/create-pull-request` обновлен до `v8`.
- Workflow автообновлений теперь может использовать секрет `LUMA_UPDATE_TOKEN`, если нужно создавать PR токеном сопровождения; при отсутствии секрета остается fallback на стандартный `github.token`.
- README уточняет, что обновлятор сам пересчитывает checksums и синхронизирует README, а вручную остается проверить сборку измененных пакетов и добавить changelog.

### Добавлено
- Добавлена проверенная синхронизация README для одноархитектурных и двухархитектурных пакетов при автоматическом обновлении.

### Исправлено
- Исправлена ошибка `array not found` в обновляторе для пакетов без `sources_arm64`: теперь `checksums_arm64` заменяется только при наличии реальных arm64-источников.
- Исправлена причина падения update PR после успешного изменения `Staplerfile`: README больше не остается со старой версией пакета.

### Проверено
- `bash -n .github/scripts/package-update.sh`.
- `shellcheck .github/scripts/package-update.sh`.
- `.github/scripts/package-update.sh check-all`: все 16 пакетов в статусе `current`.
- В временной копии репозитория: `package-update.sh apply adwyra` после искусственного отката версии `0.5.0 -> 0.4.9`, README и `Staplerfile` вернулись к `0.5.0`, валидатор прошел 16 пакетов.
- В временной копии репозитория: `package-update.sh apply tailscale` после искусственного отката версии `1.98.4 -> 1.98.3`, README, `checksums` и `checksums_arm64` обновились, валидатор прошел 16 пакетов.

### Осталось
- При необходимости добавить секрет `LUMA_UPDATE_TOKEN` в настройках репозитория, если нужно, чтобы PR автообновлений запускал последующие GitHub Actions проверки от имени отдельного токена.

## 2026-06-03 21:38 VLAT

### Изменено
- Расширен `.github/scripts/validate-repo.py` по результатам сверки с официальной документацией Stapler: добавлена проверка корневого `stapler-repo.toml`, пакетных `stapler-repo.toml`, `LICENSE`, `.stapler/update-check`, lifecycle-скриптов, локальных `local:///` источников и обязательных русскоязычных metadata-полей.
- В `.github/workflows/ci.yml` и `.github/workflows/update-packages.yml` добавлена компиляционная проверка валидатора перед запуском.
- В `README.md` добавлена ссылка на аудит соответствия документации Stapler.
- Нестандартные лицензии `codex-app`, `happ`, `vanyavpn` и `windsurf` приведены к документированному значению `Custom`; `release` этих пакетов увеличен для корректной переустановки metadata.

### Добавлено
- Добавлен `docs/STAPLER_AUDIT.md` с анализом Luma относительно разделов документации Stapler: `Введение`, `Stapler-репозиторий`, `Staplerfile` и `stplr-spec`.

### Исправлено
- Валидатор теперь корректно разбирает строки в двойных кавычках, многострочные scalar-поля и реально проверяет `sources`, а не только `checksums`.
- Устранены устаревшие значения `license=('custom')` в пакетах с нестандартной лицензией.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 16 пакетов.
- `.github/scripts/package-update.sh check-all`: все 16 пакетов в статусе `current`.
- `python3 -m py_compile .github/scripts/validate-repo.py`.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Добавить выборочную CI-сборку измененных пакетов и приоритетно проверить `stplr-spec clean-build` для критичных пакетов.

## 2026-06-03 21:28 VLAT

### Изменено
- Увеличен `release` у `codex-app` до `4`, так как предыдущий фикс `release=3` не затрагивал hardcoded путь projectless workspace.
- В сборке `codex-app` добавлен патч основного `/opt/codex-app/resources/codex.asar`.

### Добавлено
- Патч `codex.asar` заменяет создание projectless workspace из `~/Documents/Codex` на `CODEX_APP_DOCUMENTS_DIR/Codex` с fallback на прежний `~/Documents/Codex`.

### Исправлено
- Исправлена реальная причина создания английской папки: основной код приложения содержал прямой вызов `join(homeDirectory, "Documents", "Codex")`, который игнорировал Electron `app.setPath("documents", ...)`, XDG user dirs и переменные окружения.

### Проверено
- `.github/scripts/validate-repo.py`: проверено 16 пакетов.
- `stplr build --clean` для `codex-app`: пакет `codex-app+stplr-default-26.506.31421-alt4.x86_64.rpm` собран успешно.
- `rpm -qpi` подтвердил версию `26.506.31421` и релиз `alt4`.
- `rpm -qpl` подтвердил наличие `/usr/bin/codex-app`, `/opt/codex-app/resources/app.asar`, `/opt/codex-app/resources/codex.asar` и desktop-файла.
- `rpm -qp --provides` подтвердил короткие имена `codex-app` и `codex`.
- Из собранного RPM извлечен `/opt/codex-app/resources/app.asar`: bootstrap содержит `CODEX_APP_DOCUMENTS_DIR` и `app.setPath("documents", ...)`.
- Из собранного RPM извлечен `/opt/codex-app/resources/codex.asar`: основной JS содержит `CODEX_APP_DOCUMENTS_DIR||i.join(n,\`Documents\`)`, а старый точный вызов `join(n,\`Documents\`,\`Codex\`)` отсутствует.
- `bash -n`, `shellcheck`, `shfmt -d -i 4` и `git diff --check`.

### Осталось
- Нет.

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

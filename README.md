<div align="center">
  <img src=".github/assets/icon.svg" width="104" height="104" alt="Luma">
  <h1>Luma</h1>
  <p><strong>Аккуратный Stapler-репозиторий для Linux-приложений</strong></p>
  <p>Готовые спецификации, реальные upstream-артефакты, postinstall-интеграция и автоматическая проверка новых версий.</p>
  <p>
    <code>stplr &gt;= v0.1.1</code>
    <code>15 пакетов</code>
    <code>amd64</code>
    <code>arm64</code>
    <code>all</code>
  </p>
</div>

---

## Быстрый старт

```bash
stplr repo add luma https://github.com/Cheviiot/luma.git
stplr refresh
stplr install luma/warp
```

Если репозиторий уже лежит локально:

```bash
stplr repo import luma stapler-repo.toml
stplr refresh
```

Полезные команды:

```bash
stplr search --query "name.contains('vpn')"
stplr info luma/codex-app
stplr install luma/codex-app
stplr install luma/pineconemc
stplr install luma/prismlauncher
stplr upgrade
```

## Каталог

### Сеть и VPN

| Приложение | Версия | Архитектуры | Установка |
|:--|:--|:--|:--|
| <img src=".github/assets/apps/clash-verge.png" width="28" height="28" alt=""> [Clash Verge Rev](./clash-verge)<br><sub>GUI-клиент на Tauri для профилей Mihomo/Clash.</sub> | `2.5.1` | `amd64`, `arm64` | `stplr install luma/clash-verge` |
| <img src=".github/assets/apps/happ.png" width="28" height="28" alt=""> [Happ](./happ)<br><sub>Удобный GUI-прокси-клиент для xray-core.</sub> | `2.16.2` | `amd64`, `arm64` | `stplr install luma/happ` |
| <img src=".github/assets/apps/netbird.png" width="28" height="28" alt=""> [NetBird](./netbird)<br><sub>Mesh VPN-клиент на базе WireGuard с SSO и политиками доступа.</sub> | `0.71.4` | `amd64`, `arm64` | `stplr install luma/netbird` |
| <img src=".github/assets/apps/tailscale.svg" width="28" height="28" alt=""> [Tailscale](./tailscale)<br><sub>Mesh VPN на базе WireGuard для приватных сетей.</sub> | `1.98.4` | `amd64`, `arm64` | `stplr install luma/tailscale` |
| <img src=".github/assets/apps/vanyavpn.png" width="28" height="28" alt=""> [VanyaVPN](./vanyavpn)<br><sub>Десктопный клиент сервиса VanyaVPN, перепакованный из AppImage.</sub> | `1.12.1+472165` | `amd64` | `stplr install luma/vanyavpn` |

### Разработка

| Приложение | Версия | Архитектуры | Установка |
|:--|:--|:--|:--|
| <img src=".github/assets/apps/codex-app.png" width="28" height="28" alt=""> [Codex App](./codex-app)<br><sub>Неофициальная Linux-перепаковка десктопного приложения Codex.</sub> | `26.506.31421` | `amd64` | `stplr install luma/codex-app` |
| <img src=".github/assets/apps/github-plus.png" width="28" height="28" alt=""> [GitHub Desktop Plus](./github-plus)<br><sub>Форк GitHub Desktop с интеграцией Bitbucket и GitLab.</sub> | `3.5.12.0` | `amd64`, `arm64` | `stplr install luma/github-plus` |
| <img src=".github/assets/apps/terax.png" width="28" height="28" alt=""> [Terax](./terax)<br><sub>AI-native эмулятор терминала на Tauri, Rust и React.</sub> | `0.7.3` | `amd64` | `stplr install luma/terax` |
| <img src=".github/assets/apps/warp.png" width="28" height="28" alt=""> [Warp](./warp)<br><sub>Терминал на Rust для разработчиков и команд.</sub> | `0.2026.05.27.15.44.stable.01` | `amd64`, `arm64` | `stplr install luma/warp` |
| <img src=".github/assets/apps/windsurf.png" width="28" height="28" alt=""> [Windsurf](./windsurf)<br><sub>AI-редактор кода для сохранения flow state.</sub> | `2.3.15` | `amd64` | `stplr install luma/windsurf` |

### Рабочий стол и игры

| Приложение | Версия | Архитектуры | Установка |
|:--|:--|:--|:--|
| <img src=".github/assets/apps/adwyra.png" width="28" height="28" alt=""> [Adwyra](./adwyra)<br><sub>Минималистичный лаунчер приложений для GNOME.</sub> | `0.5.0` | `all` | `stplr install luma/adwyra` |
| <img src=".github/assets/apps/hydralauncher.png" width="28" height="28" alt=""> [Hydra Launcher](./hydralauncher)<br><sub>Открытый игровой лаунчер со встроенной поддержкой BitTorrent.</sub> | `3.9.9` | `amd64` | `stplr install luma/hydralauncher` |
| <img src=".github/assets/apps/pineconemc.svg" width="28" height="28" alt=""> [PineconeMC](./pineconemc)<br><sub>Форк Prism Launcher с поддержкой Ely.by и offline-аккаунтов.</sub> | `11.0.2` | `amd64`, `arm64` | `stplr install luma/pineconemc` |
| <img src=".github/assets/apps/prismlauncher.svg" width="28" height="28" alt=""> [Prism Launcher](./prismlauncher)<br><sub>Лаунчер Minecraft для ванильных и модифицированных сборок.</sub> | `11.0.2` | `amd64`, `arm64` | `stplr install luma/prismlauncher` |
| <img src=".github/assets/apps/vual.png" width="28" height="28" alt=""> [Vual](./vual)<br><sub>Запуск Cheat Engine для Steam-игр через Proton.</sub> | `0.3.1` | `all` | `stplr install luma/vual` |

## Что важно знать

| Тема | Детали |
|:--|:--|
| Источники | Пакеты используют реальные upstream-артефакты: `.deb`, `.tgz`, AppImage или исходные архивы. |
| Архитектуры | Витрина покрывает `amd64`, `arm64` и `all`; конкретная поддержка указана в каждом `Staplerfile`. |
| Несвободные пакеты | Proprietary-приложения помечены `nonfree=1` и содержат ссылку на условия upstream. |
| Postinstall | Скрипты обновляют desktop-базу, кэш иконок, systemd-сервисы и права исполняемых файлов там, где это нужно. |
| Обновления | `.stapler/update-check` у каждого пакета совместим с `stplr-spec`, а общий скрипт проверяет весь каталог. |

## Полная сводка

| Пакет | Категория | Upstream | Версия | Лицензия | Архитектуры |
|:--|:--|:--|:--|:--|:--|
| `adwyra` | Рабочий стол | [Adwyra](https://github.com/Cheviiot/Adwyra) | `0.5.0` | `GPL-3.0-or-later` | `all` |
| `clash-verge` | Сеть и VPN | [Clash Verge Rev](https://www.clashverge.dev) | `2.5.1` | `GPL-3.0-only` | `amd64`, `arm64` |
| `codex-app` | Разработка | [Codex App Linux](https://github.com/Boria138/codex-app-linux) | `26.506.31421` | `custom` | `amd64` |
| `github-plus` | Разработка | [GitHub Desktop Plus](https://github.com/pol-rivero/github-desktop-plus) | `3.5.12.0` | `MIT` | `amd64`, `arm64` |
| `happ` | Сеть и VPN | [Happ](https://happ.su/) | `2.16.2` | `custom` | `amd64`, `arm64` |
| `hydralauncher` | Игры | [Hydra Launcher](https://hydralauncher.app/dl/) | `3.9.9` | `MIT` | `amd64` |
| `netbird` | Сеть и VPN | [NetBird](https://netbird.io/) | `0.71.4` | `BSD-3-Clause`, `AGPL-3.0-only` | `amd64`, `arm64` |
| `pineconemc` | Игры | [PineconeMC](https://pineconemc.com/) | `11.0.2` | `GPL-3.0-only` | `amd64`, `arm64` |
| `prismlauncher` | Игры | [Prism Launcher](https://prismlauncher.org/) | `11.0.2` | `GPL-3.0-only` | `amd64`, `arm64` |
| `tailscale` | Сеть и VPN | [Tailscale](https://tailscale.com) | `1.98.4` | `BSD-3-Clause` | `amd64`, `arm64` |
| `terax` | Разработка | [Terax](https://terax.app) | `0.7.3` | `Apache-2.0` | `amd64` |
| `vanyavpn` | Сеть и VPN | [VanyaVPN](https://vanyavpn.es) | `1.12.1+472165` | `custom` | `amd64` |
| `vual` | Игры | [Vual](https://github.com/Cheviiot/Vual) | `0.3.1` | `GPL-3.0-or-later` | `all` |
| `warp` | Разработка | [Warp](https://warp.dev/) | `0.2026.05.27.15.44.stable.01` | `AGPL-3.0-only`, `MIT` | `amd64`, `arm64` |
| `windsurf` | Разработка | [Windsurf](https://windsurf.com/) | `2.3.15` | `custom` | `amd64` |

## Сопровождение

### Структура пакета

Каждый каталог пакета содержит:

- `Staplerfile` — сборочная спецификация;
- `stapler-repo.toml` — наследование настроек репозитория;
- `.stapler/update-check` — проверка актуальной upstream-версии;
- `postinstall.sh` и `postremove.sh` — системная интеграция после установки и удаления;
- `LICENSE` — upstream-лицензия или описание условий распространения.

### Проверки

```bash
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r bash -n
find . -path './.git' -prune -o \( -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shellcheck
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shfmt -d -i 4
git diff --check
```

### Сборка

```bash
cd codex-app
stplr build --clean
```

Для чистой сборки через `stplr-spec`, если он установлен:

```bash
cd codex-app
stplr-spec clean-build --preset aides
```

### Обновление версий

```bash
.github/scripts/package-update.sh check-all
.github/scripts/package-update.sh apply-all
```

После обновления версий нужно проверить сборку измененных пакетов и синхронизировать README/CHANGELOG, если изменилась публичная информация.

## Иконки

Иконки витрины взяты из upstream-артефактов пакетов: `.deb`, AppImage, `.tgz` или исходных архивов. Для `tailscale`, чей Linux CLI-архив не содержит desktop-иконку, используется официальный `favicon.svg` с сайта Tailscale.

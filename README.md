<div align="center">
  <img src=".github/assets/icon.svg" width="112" height="112" alt="Luma">

  <h1>Luma</h1>

  <p><strong>Поддерживаемый Stapler-репозиторий для установки Linux-приложений из проверяемых upstream-источников.</strong></p>

  <p>
    <a href="https://github.com/Cheviiot/luma"><img alt="Repository" src="https://img.shields.io/badge/repository-Cheviiot%2Fluma-111827?style=for-the-badge&logo=github"></a>
    <img alt="Stapler" src="https://img.shields.io/badge/stplr-%3E%3D%20v0.1.1-2563eb?style=for-the-badge">
    <img alt="Packages" src="https://img.shields.io/badge/packages-15-16a34a?style=for-the-badge">
  </p>

  <p>
    <code>stplr &gt;= v0.1.1</code>
    <code>15 пакетов</code>
    <code>amd64</code>
    <code>arm64</code>
    <code>all</code>
  </p>
</div>

---

## Обзор

| Направление | Состояние |
|:--|:--|
| Назначение | Единая витрина пакетов для Stapler: desktop-приложения, VPN-клиенты, инструменты разработки и игровые лаунчеры. |
| Источники | Используются реальные upstream-артефакты: `.deb`, `.tgz`, AppImage, исходные архивы и локальные иконки пакетов. |
| Контроль | У каждого пакета есть `Staplerfile`, `stapler-repo.toml`, `.stapler/update-check`, `LICENSE`, install/remove-скрипты при необходимости. |
| Обновления | Общий скрипт сверяет версии, пересчитывает SHA256 и синхронизирует README. |
| Поддержка | Ошибки по пакетам принимаются через [GitHub Issues](https://github.com/Cheviiot/luma/issues). |

## Быстрый старт

```bash
stplr repo add luma https://github.com/Cheviiot/luma.git
stplr refresh
stplr install luma/mindustry
```

Если репозиторий уже находится на машине:

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
stplr install luma/mindustry
stplr install luma/remote-desktop-manager
stplr upgrade
```

## Каталог

### Сеть и VPN

| Приложение | Версия | Архитектуры | Первоисточник | Установка |
|:--|:--:|:--:|:--|:--|
| <img src=".github/assets/apps/clash-verge.png" width="28" height="28" alt=""> [Clash Verge Rev](./clash-verge)<br><sub>GUI-клиент на Tauri для профилей Mihomo/Clash.</sub> | `2.5.1` | `amd64`, `arm64` | [clashverge.dev](https://www.clashverge.dev) | `stplr install luma/clash-verge` |
| <img src=".github/assets/apps/happ.png" width="28" height="28" alt=""> [Happ](./happ)<br><sub>Удобный GUI-прокси-клиент для xray-core.</sub> | `2.18.1` | `amd64`, `arm64` | [happ.su](https://happ.su/) | `stplr install luma/happ` |
| <img src=".github/assets/apps/netbird.png" width="28" height="28" alt=""> [NetBird](./netbird)<br><sub>Mesh VPN-клиент на базе WireGuard с SSO и политиками доступа.</sub> | `0.73.2` | `amd64`, `arm64` | [netbird.io](https://netbird.io/) | `stplr install luma/netbird` |
| <img src=".github/assets/apps/tailscale.svg" width="28" height="28" alt=""> [Tailscale](./tailscale)<br><sub>Mesh VPN на базе WireGuard для приватных сетей.</sub> | `1.98.4` | `amd64`, `arm64` | [tailscale.com](https://tailscale.com) | `stplr install luma/tailscale` |
| <img src=".github/assets/apps/vanyavpn.png" width="28" height="28" alt=""> [VanyaVPN](./vanyavpn)<br><sub>Десктопный клиент сервиса VanyaVPN, перепакованный из AppImage.</sub> | `1.12.1+472165` | `amd64` | [vanyavpn.es](https://vanyavpn.es) | `stplr install luma/vanyavpn` |

### Разработка

| Приложение | Версия | Архитектуры | Первоисточник | Установка |
|:--|:--:|:--:|:--|:--|
| <img src=".github/assets/apps/codex-app.png" width="28" height="28" alt=""> [Codex App](./codex-app)<br><sub>Неофициальная Linux-перепаковка десктопного приложения Codex.</sub> | `26.616.81150` | `amd64` | [Boria138/codex-app-linux](https://github.com/Boria138/codex-app-linux) | `stplr install luma/codex-app` |
| <img src=".github/assets/apps/github-plus.png" width="28" height="28" alt=""> [GitHub Desktop Plus](./github-plus)<br><sub>Форк GitHub Desktop с интеграцией Bitbucket и GitLab.</sub> | `3.5.13.2` | `amd64`, `arm64` | [pol-rivero/github-desktop-plus](https://github.com/pol-rivero/github-desktop-plus) | `stplr install luma/github-plus` |
| <img src=".github/assets/apps/hermes-agent.png" width="28" height="28" alt=""> [Hermes Agent](./hermes-agent)<br><sub>Самоулучшающийся AI-агент с CLI/backend, Linux desktop-оболочкой и русской локализацией.</sub> | `2026.6.19` | `amd64` | [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com)<br><sub>RU: [warment/hermes-desktop-ru](https://github.com/warment/hermes-desktop-ru)</sub> | `stplr install luma/hermes-agent` |
| <img src=".github/assets/apps/opencode.png" width="28" height="28" alt=""> [OpenCode](./opencode)<br><sub>Открытый AI-агент для разработки в десктопном интерфейсе.</sub> | `1.17.11` | `amd64`, `arm64` | [opencode.ai](https://opencode.ai) | `stplr install luma/opencode` |

### Рабочий стол и игры

| Приложение | Версия | Архитектуры | Первоисточник | Установка |
|:--|:--:|:--:|:--|:--|
| <img src=".github/assets/apps/adwyra.png" width="28" height="28" alt=""> [Adwyra](./adwyra)<br><sub>Минималистичный лаунчер приложений для GNOME.</sub> | `0.6.1` | `all` | [Cheviiot/Adwyra](https://github.com/Cheviiot/Adwyra) | `stplr install luma/adwyra` |
| <img src=".github/assets/apps/mindustry.png" width="28" height="28" alt=""> [Mindustry](./mindustry)<br><sub>Песочница, tower defense и фабричная стратегия.</sub> | `158.1` | `amd64` | [anuke.itch.io/mindustry](https://anuke.itch.io/mindustry) | `stplr install luma/mindustry` |
| <img src=".github/assets/apps/parsec.png" width="28" height="28" alt=""> [Parsec](./parsec)<br><sub>Удаленный рабочий стол и игровой стриминг с низкой задержкой.</sub> | `150-97c` | `amd64` | [parsec.app/downloads](https://parsec.app/downloads) | `stplr install luma/parsec` |
| <img src=".github/assets/apps/pineconemc.svg" width="28" height="28" alt=""> [PineconeMC](./pineconemc)<br><sub>Форк Prism Launcher с поддержкой Ely.by и offline-аккаунтов.</sub> | `11.0.2` | `amd64`, `arm64` | [pineconemc.com](https://pineconemc.com/) | `stplr install luma/pineconemc` |
| <img src=".github/assets/apps/remote-desktop-manager.svg" width="28" height="28" alt=""> [Remote Desktop Manager](./remote-desktop-manager)<br><sub>Менеджер RDP, SSH, VNC, VPN и других удаленных подключений.</sub> | `2026.2.0.7` | `amd64` | [Devolutions RDM](https://devolutions.net/remote-desktop-manager/) | `stplr install luma/remote-desktop-manager` |
| <img src=".github/assets/apps/vual.png" width="28" height="28" alt=""> [Vual](./vual)<br><sub>Запуск Cheat Engine для Steam-игр через Proton.</sub> | `0.3.1` | `all` | [Cheviiot/Vual](https://github.com/Cheviiot/Vual) | `stplr install luma/vual` |

## Принципы качества

| Контур | Что проверяется |
|:--|:--|
| Версии | `.stapler/update-check` сверяет локальную версию с upstream-релизом или официальным каналом поставки. |
| Целостность | `checksums` пересчитываются по фактически скачанным источникам, включая `sources_arm64`. |
| Интеграция | Postinstall-скрипты обновляют desktop-базу, icon-cache, systemd-сервисы и права файлов там, где это нужно. |
| Лицензии | В каждом пакете есть `LICENSE` с русским описанием лицензии, источника и нюансов распространения. |
| Аудит | [docs/STAPLER_AUDIT.md](./docs/STAPLER_AUDIT.md) фиксирует сверку Luma с документацией Stapler и дальнейшие шаги. |

## Полная сводка

| Пакет | Категория | Upstream | Версия | Лицензия | Архитектуры |
|:--|:--|:--|:--:|:--|:--:|
| `adwyra` | Рабочий стол | [Adwyra](https://github.com/Cheviiot/Adwyra) | `0.6.1` | `GPL-3.0-or-later` | `all` |
| `clash-verge` | Сеть и VPN | [Clash Verge Rev](https://www.clashverge.dev) | `2.5.1` | `GPL-3.0-only` | `amd64`, `arm64` |
| `codex-app` | Разработка | [Codex App Linux](https://github.com/Boria138/codex-app-linux) | `26.616.81150` | `Custom` | `amd64` |
| `github-plus` | Разработка | [GitHub Desktop Plus](https://github.com/pol-rivero/github-desktop-plus) | `3.5.13.2` | `MIT` | `amd64`, `arm64` |
| `happ` | Сеть и VPN | [Happ](https://happ.su/) | `2.18.1` | `Custom` | `amd64`, `arm64` |
| `hermes-agent` | Разработка | [Hermes Agent](https://hermes-agent.nousresearch.com)<br><sub>RU locale: [warment/hermes-desktop-ru](https://github.com/warment/hermes-desktop-ru)</sub> | `2026.6.19` | `MIT` | `amd64` |
| `mindustry` | Игры | [Mindustry](https://anuke.itch.io/mindustry) | `158.1` | `GPL-3.0-only` | `amd64` |
| `netbird` | Сеть и VPN | [NetBird](https://netbird.io/) | `0.73.2` | `BSD-3-Clause`, `AGPL-3.0-only` | `amd64`, `arm64` |
| `opencode` | Разработка | [OpenCode](https://opencode.ai) | `1.17.11` | `MIT` | `amd64`, `arm64` |
| `parsec` | Рабочий стол и игры | [Parsec](https://parsec.app/downloads) | `150-97c` | `Custom` | `amd64` |
| `pineconemc` | Игры | [PineconeMC](https://pineconemc.com/) | `11.0.2` | `GPL-3.0-only` | `amd64`, `arm64` |
| `remote-desktop-manager` | Рабочий стол и игры | [Devolutions RDM](https://devolutions.net/remote-desktop-manager/) | `2026.2.0.7` | `Custom` | `amd64` |
| `tailscale` | Сеть и VPN | [Tailscale](https://tailscale.com) | `1.98.4` | `BSD-3-Clause` | `amd64`, `arm64` |
| `vanyavpn` | Сеть и VPN | [VanyaVPN](https://vanyavpn.es) | `1.12.1+472165` | `Custom` | `amd64` |
| `vual` | Игры | [Vual](https://github.com/Cheviiot/Vual) | `0.3.1` | `GPL-3.0-or-later` | `all` |

## Сопровождение

### Структура пакета

| Файл | Назначение |
|:--|:--|
| `Staplerfile` | Сборочная спецификация пакета. |
| `stapler-repo.toml` | Наследование настроек репозитория. |
| `.stapler/update-check` | Проверка актуальной версии исходного проекта. |
| `postinstall.sh` | Действия после установки: desktop-cache, icon-cache, systemd, права файлов. |
| `postremove.sh` | Очистка системной интеграции после удаления пакета. |
| `LICENSE` | Русское описание лицензии и ограничений поставки. |

### Проверки

```bash
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r bash -n
find . -path './.git' -prune -o \( -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shellcheck
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shfmt -d -i 4
python3 -m py_compile .github/scripts/validate-repo.py
.github/scripts/validate-repo.py
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

`apply` и `apply-all` обновляют версию, сбрасывают `release` на `1`, пересчитывают checksums и синхронизируют строки пакета в README. После обновления нужно проверить сборку измененных пакетов и добавить запись в CHANGELOG.

## Иконки

Иконки витрины взяты из артефактов исходных проектов: `.deb`, AppImage, `.tgz` или исходных архивов. Для `tailscale`, чей Linux CLI-архив не содержит desktop-иконку, используется официальный `favicon.svg` с сайта Tailscale.

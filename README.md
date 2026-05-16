# Luma

Luma — минимальный Stapler-репозиторий для установки прикладных Linux-пакетов.

Требуемая версия Stapler: `v0.1.1` или новее.

## Подключение

```bash
stplr repo add luma https://github.com/Cheviiot/luma.git
stplr refresh
```

Если репозиторий уже склонирован локально, можно импортировать метаданные:

```bash
stplr repo import luma stapler-repo.toml
stplr refresh
```

## Пакеты

Метаданные пакетов синхронизированы с upstream README, GitHub metadata и control metadata официальных `.deb`/AppImage артефактов. Актуальная версия каждого пакета хранится в его `Staplerfile`.

### Сеть и VPN

| Пакет | Upstream | Лицензия | Архитектуры | Описание |
|:--|:--|:--|:--|:--|
| `clash-verge` | [Clash Verge Rev](https://www.clashverge.dev) | GPL-3.0-only | `amd64`, `arm64` | GUI-клиент на Tauri для профилей Mihomo/Clash |
| `happ` | [Happ](https://happ.su/) | proprietary | `amd64`, `arm64` | GUI-клиент для xray-core с TUN/VPN, sing-box, byedpi и подписками |
| `tailscale` | [Tailscale](https://tailscale.com) | BSD-3-Clause | `amd64`, `arm64` | Mesh VPN на базе WireGuard и identity-based access |
| `vanyavpn` | [VanyaVPN](https://vanyavpn.es) | proprietary | `amd64` | десктопный клиент сервиса VanyaVPN, перепакованный из AppImage |

### Разработка

| Пакет | Upstream | Лицензия | Архитектуры | Описание |
|:--|:--|:--|:--|:--|
| `github-plus` | [GitHub Desktop Plus](https://github.com/pol-rivero/github-desktop-plus) | MIT | `amd64`, `arm64` | форк GitHub Desktop с интеграцией Bitbucket и GitLab |
| `terax` | [Terax](https://terax.app) | Apache-2.0 | `amd64` | AI-native эмулятор терминала на Tauri, Rust и React |
| `warp` | [Warp](https://warp.dev/) | AGPL-3.0-only, MIT | `amd64`, `arm64` | терминал на Rust для разработчиков и команд |
| `windsurf` | [Windsurf](https://windsurf.com/) | proprietary | `amd64` | AI-native редактор кода от Exafunction |

### Рабочий стол и игры

| Пакет | Upstream | Лицензия | Архитектуры | Описание |
|:--|:--|:--|:--|:--|
| `adwyra` | [Adwyra](https://github.com/Cheviiot/Adwyra) | GPL-3.0-or-later | `all` | минималистичный лаунчер приложений для GNOME |
| `vual` | [Vual](https://github.com/Cheviiot/Vual) | GPL-3.0-or-later | `all` | запуск Cheat Engine для Steam-игр через Proton |

## Использование

```bash
stplr search --query "name.contains('warp')"
stplr info luma/warp
stplr install luma/warp
stplr upgrade
```

## Разработка

Пакеты лежат в корне репозитория. Каждый пакет содержит:

- `Staplerfile` — описание сборки;
- `stapler-repo.toml` — наследование настроек репозитория;
- `postinstall.sh` и `postremove.sh`, если нужны действия после установки/удаления;
- `LICENSE`, если upstream-лицензия должна поставляться рядом со спецификацией.

Быстрые локальные проверки:

```bash
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r bash -n
find . -path './.git' -prune -o \( -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shellcheck
find . -path './.git' -prune -o \( -name 'Staplerfile' -o -name '*.sh' -o -path '*/.stapler/*' \) -type f -print0 | xargs -0 -r shfmt -d -i 4
git diff --check
```

Сборка конкретного пакета:

```bash
cd github-plus
stplr build --clean
```

Проверка upstream-версий:

```bash
.github/scripts/package-update.sh check-all
```

Каждый пакет также содержит `.stapler/update-check`, совместимый со `stplr-spec`:

```bash
cd github-plus
stplr-spec update-package --only-check
```

Применить доступные обновления локально:

```bash
.github/scripts/package-update.sh apply-all
```

GitHub Actions ежедневно запускает `Update Packages` и создаёт Pull Request, если upstream выпустил новые версии.

Для чистой сборки через `stplr-spec`, если он установлен:

```bash
cd github-plus
stplr-spec clean-build --preset aides
```

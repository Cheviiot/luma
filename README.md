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

| Пакет | Архитектуры | Назначение |
|:--|:--|:--|
| `adwyra` | `all` | лаунчер приложений |
| `clash-verge` | `amd64`, `arm64` | GUI-клиент Mihomo |
| `github-plus` | `amd64`, `arm64` | GitHub Desktop Plus |
| `happ` | `amd64`, `arm64` | Happ Proxy Client |
| `tailscale` | `amd64`, `arm64` | WireGuard mesh VPN |
| `terax` | `amd64` | AI-native терминал |
| `vanyavpn` | `amd64` | клиент VanyaVPN |
| `vual` | `all` | helper для Steam/Proton |
| `warp` | `amd64`, `arm64` | Warp Terminal |
| `windsurf` | `amd64` | AI-редактор кода |

Актуальная версия каждого пакета хранится только в его `Staplerfile`, чтобы README не расходился с автоматическими обновлениями.

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

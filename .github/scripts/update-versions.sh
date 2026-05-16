#!/bin/bash
# Скрипт автоматической проверки и обновления версий пакетов
# Проверяет GitHub releases и обновляет Staplerfile

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
REPO_ROOT="$LUMA_REPO_ROOT"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Конфигурация пакетов: имя_пакета -> owner/repo
declare -A PACKAGE_REPOS=(
    ["happ"]="Happ-proxy/happ-desktop"
    ["github-plus"]="pol-rivero/github-desktop-plus"
    ["adwyra"]="cheviiot/adwyra"
    ["vual"]="Cheviiot/Vual"
    ["clash-verge"]="clash-verge-rev/clash-verge-rev"
    ["terax"]="crynta/terax-ai"
)

# Release assets, для которых GitHub API отдаёт sha256 digest.
declare -A PACKAGE_ASSET_DEFAULT=(
    ["github-plus"]="GitHubDesktopPlus-v{version}-linux-x86_64.deb"
    ["happ"]="Happ.linux.x64.deb"
    ["clash-verge"]="Clash.Verge_{version}_amd64.deb"
    ["terax"]="Terax_{version}_amd64.deb"
)

declare -A PACKAGE_ASSET_ARM64=(
    ["github-plus"]="GitHubDesktopPlus-v{version}-linux-arm64.deb"
    ["happ"]="Happ.linux.arm64.deb"
    ["clash-verge"]="Clash.Verge_{version}_arm64.deb"
)

# GitHub-generated archives не имеют release asset digest, поэтому хэшируются скачиванием.
declare -A PACKAGE_SOURCE_DEFAULT=(
    ["adwyra"]="https://github.com/Cheviiot/adwyra/archive/refs/tags/{tag}.tar.gz"
    ["vual"]="https://github.com/Cheviiot/Vual/archive/refs/tags/{tag}.tar.gz"
)

# Прямые .deb-источники без GitHub Releases API. Версия берётся из control metadata.
declare -A PACKAGE_DEB_DEFAULT=(
    ["warp"]="https://app.warp.dev/download?package=deb"
)

declare -A PACKAGE_DEB_ARM64=(
    ["warp"]="https://app.warp.dev/download?package=deb_arm64"
)

declare -A PACKAGE_TGZ_DEFAULT=(
    ["tailscale"]="https://pkgs.tailscale.com/stable/tailscale_latest_amd64.tgz"
)

declare -A PACKAGE_TGZ_ARM64=(
    ["tailscale"]="https://pkgs.tailscale.com/stable/tailscale_latest_arm64.tgz"
)

# APT metadata для пакетов, где официальный .deb публикуется в репозитории.
declare -A PACKAGE_APT_INDEX=(
    ["windsurf"]="https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt/dists/stable/main/binary-amd64/Packages"
)

declare -A PACKAGE_APT_PACKAGE=(
    ["windsurf"]="windsurf"
)


# Специальные обработчики версий (для нестандартных форматов)
declare -A VERSION_TRANSFORMS=(
    # github-plus использует формат vX.Y.Z.N
    ["github-plus"]="strip_v"
)

# Трансформация версий для отображения в README (сокращённый формат)
declare -A README_VERSION_TRANSFORMS=(
    ["warp"]="shorten_date_version"
)

# Пакеты с определением версии через redirect URL загрузки
declare -A PACKAGE_REDIRECT_URL=(
    ["tailscale"]="https://pkgs.tailscale.com/stable/tailscale_latest_amd64.tgz"
)

# Опционально: Gitea вместо GitHub (URL инстанса)
declare -A PACKAGE_GITEA=()

# Статические upstream-файлы без API версии; версия фиксируется в Staplerfile,
# checksum можно пересчитать через -c.
declare -A PACKAGE_STATIC_URL=(
    ["vanyavpn"]="https://amazonvpn.s3.amazonaws.com/VanyaVPN.AppImage"
)

# Флаги
DRY_RUN=false
VERBOSE=false
UPDATE_ALL=false
UPDATE_CHECKSUMS=false
SPECIFIC_PACKAGE=""

usage() {
    cat << EOF
Использование: $(basename "$0") [опции] [пакет]

Проверяет и обновляет версии пакетов из GitHub releases, тегов, APT metadata и прямых .deb.

Опции:
    -n, --dry-run     Только показать изменения, не применять
    -v, --verbose     Подробный вывод
    -a, --all         Обновить все пакеты (по умолчанию)
    -c, --checksums   Пересчитать checksums даже без смены версии
    -h, --help        Показать эту справку

Примеры:
    $(basename "$0")                    # Проверить все пакеты
    $(basename "$0") -n                 # Проверить без изменений
    $(basename "$0") happ               # Проверить только happ
    $(basename "$0") -v --all           # Обновить все с подробным выводом
    $(basename "$0") -c github-plus     # Обновить checksum для конкретного пакета

EOF
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_verbose() {
    if $VERBOSE; then
        echo -e "${BLUE}[DEBUG]${NC} $*"
    fi
}

# GET к api.github.com (в GITHUB Actions переменная GITHUB_TOKEN уже есть — выше лимит API)
_curl_github_api() {
    local hdr=(-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28")
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        hdr+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    fi
    curl -fsSL "${hdr[@]}" "$@"
}

_curl_download() {
    curl --retry 3 --retry-delay 5 --retry-all-errors --connect-timeout 30 -fsSL "$@"
}

# Получить последнюю версию с GitHub или Gitea
get_latest_version() {
    local repo="$1"
    local package="$2"
    local version
    local api_response

    # Статические upstream-файлы: последнюю версию определить нельзя, используем Staplerfile.
    if [[ -n "${PACKAGE_STATIC_URL["$package"]:+x}" ]]; then
        version=$(get_current_version "$package" 2>/dev/null || true)
        echo "$version"
        return
    fi

    # Пакеты с прямым .deb-источником: скачиваем control metadata и читаем Version.
    if [[ -n "${PACKAGE_DEB_DEFAULT["$package"]:+x}" ]]; then
        version=$(get_deb_control_field "${PACKAGE_DEB_DEFAULT["$package"]}" "Version" 2>/dev/null || true)
        echo "$version"
        return
    fi

    # Пакеты из APT metadata: берём Version из Packages и убираем Debian revision.
    if [[ -n "${PACKAGE_APT_INDEX["$package"]:+x}" ]]; then
        version=$(get_apt_package_field "$package" "Version" 2>/dev/null || true)
        version="${version#*:}"
        version="${version%%-*}"
        echo "$version"
        return
    fi

    # Проверяем, использует ли пакет определение версии через redirect URL
    if [[ -n "${PACKAGE_REDIRECT_URL["$package"]:+x}" ]]; then
        local redirect_url
        redirect_url=$(curl -fsSI -o /dev/null -w '%{redirect_url}' \
            "${PACKAGE_REDIRECT_URL["$package"]}" 2>/dev/null)
        # Извлекаем версию из redirect URL (например .../linux/x64/11.10.0/... или tailscale_1.96.4_amd64.tgz)
        version=$(echo "$redirect_url" | grep -oP '(^|[/_-])\K\d+\.\d+\.\d+(?=([/_-]|\.))' | head -1)
        echo "$version"
        return
    fi

    # Проверяем, является ли пакет Gitea-хостингом
    if [[ -n "${PACKAGE_GITEA["$package"]:+x}" ]]; then
        local gitea_url="${PACKAGE_GITEA["$package"]}"

        # Gitea API: сначала пробуем tags (более надежно)
        api_response=$(curl -fsSL \
            "${gitea_url}/api/v1/repos/$repo/tags?limit=1" \
            2>/dev/null || true)
        version=$(echo "$api_response" | jq -r '.[0].name // empty' 2>/dev/null)

        echo "$version"
        return
    fi

    # Используем GitHub API для получения последнего релиза
    api_response=$(_curl_github_api "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null || true)

    version=$(echo "$api_response" | jq -r '.tag_name // empty' 2>/dev/null)

    # Если releases пусто, пробуем tags
    if [[ -z "$version" ]]; then
        api_response=$(_curl_github_api "https://api.github.com/repos/${repo}/tags" 2>/dev/null || true)
        version=$(echo "$api_response" | jq -r '.[0].name // empty' 2>/dev/null)
    fi

    echo "$version"
}

# Трансформации версий
strip_v() {
    local ver="$1"
    echo "${ver#v}"
}

# Сокращение датовых версий для README: 0.2026.05.06.15.42.stable.03 → 2026.05.06
shorten_date_version() {
    local ver="$1"
    # Извлекаем YYYY.MM.DD из формата 0.YYYY.MM.DD.HH.MM.channel.NN
    echo "$ver" | sed -E 's/^[0-9]+\.([0-9]{4})\.([0-9]{2})\.([0-9]{2})\..*/\1.\2.\3/'
}

# Применить трансформацию версии
transform_version() {
    local package="$1"
    local version="$2"
    local result

    if [[ -n "${VERSION_TRANSFORMS["$package"]:+x}" ]]; then
        local transform="${VERSION_TRANSFORMS["$package"]}"
        result=$("$transform" "$version")
    else
        # По умолчанию просто убираем 'v' в начале
        result="${version#v}"
    fi

    echo "$result"
}

# Получить текущую версию из Staplerfile
get_current_version() {
    local package="$1"
    local staplerfile="$REPO_ROOT/$package/Staplerfile"

    if [[ ! -f "$staplerfile" ]]; then
        log_error "Staplerfile не найден: $staplerfile"
        return 1
    fi

    grep -E "^version=" "$staplerfile" | head -1 | cut -d"'" -f2 | cut -d'"' -f2
}

# Обновить версию в Staplerfile
update_staplerfile_version() {
    local package="$1"
    local new_version="$2"
    local staplerfile="$REPO_ROOT/$package/Staplerfile"

    if $DRY_RUN; then
        log_info "[DRY-RUN] Обновил бы $package до версии $new_version"
        return 0
    fi

    # Обновляем version='...' или version="..."
    sed -i -E "s/^version=['\"][^'\"]+['\"]/version='$new_version'/" "$staplerfile"

    log_success "Обновлён $package: $new_version"
}

render_template() {
    local template="$1"
    local version="$2"
    local tag="$3"

    template="${template//\{version\}/$version}"
    template="${template//\{tag\}/$tag}"
    echo "$template"
}

sha256_for_url() {
    local url="$1"

    _curl_download "$url" | sha256sum | awk '{print $1}'
}

get_deb_control_field() {
    local url="$1"
    local field="$2"
    local tmp
    local value

    tmp="$(mktemp -d)"

    if ! _curl_download -o "$tmp/package.deb" "$url"; then
        rm -rf "$tmp"
        return 1
    fi

    value=$(
        cd "$tmp"
        ar x package.deb >/dev/null
        control_archive=$(find . -maxdepth 1 -name 'control.tar.*' -print | head -1)
        [[ -n "$control_archive" ]] || exit 1
        tar -xOf "$control_archive" ./control | awk -F': ' -v field="$field" '$1 == field { print $2; exit }'
    )
    local status=$?

    rm -rf "$tmp"

    if [[ $status -ne 0 ]]; then
        return "$status"
    fi

    echo "$value"
}

get_apt_package_field() {
    local package="$1"
    local field="$2"
    local index_url="${PACKAGE_APT_INDEX["$package"]}"
    local apt_package="${PACKAGE_APT_PACKAGE["$package"]:-$package}"

    _curl_download "$index_url" | awk -v package="$apt_package" -v field="$field" '
        BEGIN { RS = ""; FS = "\n" }
        {
            found = 0
            for (i = 1; i <= NF; i++) {
                if ($i == "Package: " package) {
                    found = 1
                }
            }

            if (!found) {
                next
            }

            for (i = 1; i <= NF; i++) {
                if (index($i, field ": ") == 1) {
                    sub(field ": ", "", $i)
                    print $i
                    exit
                }
            }
        }
    '
}

get_release_asset_checksum() {
    local repo="$1"
    local tag="$2"
    local asset="$3"
    local api_response="$4"
    local checksum

    checksum=$(echo "$api_response" | jq -r --arg asset "$asset" \
        '.assets[]? | select(.name == $asset) | .digest // empty' 2>/dev/null | sed 's/^sha256://')

    if [[ -z "$checksum" ]]; then
        local asset_url
        asset_url="${asset// /%20}"
        checksum=$(sha256_for_url "https://github.com/${repo}/releases/download/${tag}/${asset_url}")
    fi

    echo "$checksum"
}

replace_checksum_array() {
    local file="$1"
    local array="$2"
    local checksum="$3"
    local tmp

    tmp="$(mktemp)"

    if grep -q "^${array}=(" "$file"; then
        awk -v array="$array" -v checksum="$checksum" '
            BEGIN { quote = sprintf("%c", 39) }
            $0 ~ "^" array "=\\(" {
                print array "=("
                print "    " quote checksum quote
                print ")"
                if ($0 !~ /[)]/) {
                    in_array = 1
                }
                next
            }
            in_array && $0 ~ /^[)]/ {
                in_array = 0
                next
            }
            in_array {
                next
            }
            { print }
        ' "$file" > "$tmp"
    else
        awk -v array="$array" -v checksum="$checksum" '
            BEGIN { quote = sprintf("%c", 39) }
            function emit_array() {
                print ""
                print array "=("
                print "    " quote checksum quote
                print ")"
                inserted = 1
            }
            $0 ~ /^checksums=\(/ {
                print
                if ($0 ~ /[)]/) {
                    emit_array()
                } else {
                    in_checksums = 1
                }
                next
            }
            in_checksums && $0 ~ /^[)]/ {
                print
                emit_array()
                in_checksums = 0
                next
            }
            { print }
            END {
                if (!inserted) {
                    exit 1
                }
            }
        ' "$file" > "$tmp"
    fi

    mv "$tmp" "$file"
}

update_package_checksums() {
    local package="$1"
    local repo="$2"
    local version="$3"
    local tag="$4"
    local staplerfile="$REPO_ROOT/$package/Staplerfile"
    local checksum_default=""
    local checksum_arm64=""

    if $DRY_RUN; then
        log_verbose "[DRY-RUN] Обновил бы checksums для $package"
        return 0
    fi

    if [[ -n "${PACKAGE_STATIC_URL["$package"]:+x}" ]]; then
        checksum_default=$(sha256_for_url "${PACKAGE_STATIC_URL["$package"]}")
    elif [[ -n "${PACKAGE_APT_INDEX["$package"]:+x}" ]]; then
        checksum_default=$(get_apt_package_field "$package" "SHA256")
    elif [[ -n "${PACKAGE_DEB_DEFAULT["$package"]:+x}" ]]; then
        checksum_default=$(sha256_for_url "${PACKAGE_DEB_DEFAULT["$package"]}")

        if [[ -n "${PACKAGE_DEB_ARM64["$package"]:+x}" ]]; then
            checksum_arm64=$(sha256_for_url "${PACKAGE_DEB_ARM64["$package"]}")
        fi
    elif [[ -n "${PACKAGE_TGZ_DEFAULT["$package"]:+x}" ]]; then
        checksum_default=$(sha256_for_url "${PACKAGE_TGZ_DEFAULT["$package"]}")

        if [[ -n "${PACKAGE_TGZ_ARM64["$package"]:+x}" ]]; then
            checksum_arm64=$(sha256_for_url "${PACKAGE_TGZ_ARM64["$package"]}")
        fi
    elif [[ -n "${PACKAGE_ASSET_DEFAULT["$package"]:+x}" ]]; then
        local api_response asset_default
        api_response=$(_curl_github_api "https://api.github.com/repos/${repo}/releases/tags/${tag}" 2>/dev/null || true)

        if [[ -z "$api_response" ]]; then
            log_error "$package: не удалось получить release metadata для checksums"
            return 1
        fi

        asset_default=$(render_template "${PACKAGE_ASSET_DEFAULT["$package"]}" "$version" "$tag")
        checksum_default=$(get_release_asset_checksum "$repo" "$tag" "$asset_default" "$api_response")

        if [[ -n "${PACKAGE_ASSET_ARM64["$package"]:+x}" ]]; then
            local asset_arm64
            asset_arm64=$(render_template "${PACKAGE_ASSET_ARM64["$package"]}" "$version" "$tag")
            checksum_arm64=$(get_release_asset_checksum "$repo" "$tag" "$asset_arm64" "$api_response")
        fi
    elif [[ -n "${PACKAGE_SOURCE_DEFAULT["$package"]:+x}" ]]; then
        local source_default
        source_default=$(render_template "${PACKAGE_SOURCE_DEFAULT["$package"]}" "$version" "$tag")
        checksum_default=$(sha256_for_url "$source_default")
    else
        log_error "$package: не настроен источник checksums"
        return 1
    fi

    if [[ -z "$checksum_default" ]]; then
        log_error "$package: не удалось вычислить checksum"
        return 1
    fi

    replace_checksum_array "$staplerfile" "checksums" "$checksum_default"

    if [[ -n "$checksum_arm64" ]]; then
        replace_checksum_array "$staplerfile" "checksums_arm64" "$checksum_arm64"
    fi

    log_success "Обновлены checksums для $package"
}

# Обновить версию в README.md
update_readme_version() {
    local package="$1"
    local old_version="$2"
    local new_version="$3"
    local readme="$REPO_ROOT/README.md"

    # Применяем README-трансформ если задан (например, сокращение дат)
    if [[ -n "${README_VERSION_TRANSFORMS["$package"]:+x}" ]]; then
        local transform="${README_VERSION_TRANSFORMS["$package"]}"
        new_version=$("$transform" "$new_version")
    fi

    if $DRY_RUN; then
        log_verbose "[DRY-RUN] Обновил бы README для $package: $old_version -> $new_version"
        return 0
    fi

    if [[ ! -f "$readme" ]]; then
        log_warning "README.md не найден"
        return 1
    fi

    # HTML package cards: <code>package</code> ... <sub><code>version</code>
    if grep -q "<code>${package}</code>" "$readme"; then
        local tmp
        tmp="$(mktemp)"
        awk -v package="$package" -v version="$new_version" '
            index($0, "<code>" package "</code>") {
                in_card = 1
                replaced = 0
                print
                next
            }
            in_card && !replaced && $0 ~ /<sub><code>[^<]+<\/code>/ {
                sub(/<sub><code>[^<]+<\/code>/, "<sub><code>" version "</code>")
                replaced = 1
            }
            in_card && index($0, "</td>") {
                in_card = 0
            }
            { print }
        ' "$readme" > "$tmp"
        mv "$tmp" "$readme"
        log_verbose "README обновлён для $package"
        return 0
    fi

    # HTML-таблицы: <b>package</b> ... <code>version</code>
    if grep -q "<b>${package}</b>" "$readme"; then
        sed -i "/<b>${package}<\/b>/,/<\/tr>/ s|<code>[^<]*</code>|<code>${new_version}</code>|" "$readme"
        log_verbose "README обновлён для $package"
    # Markdown-таблицы (новый формат): `package` | `version` |
    elif grep -q "\`${package}\`" "$readme"; then
        sed -i -E "s/(\`${package}\`[[:space:]]*\|[[:space:]]*)\`[^\`]+\`/\1\`${new_version}\`/" "$readme"
        log_verbose "README обновлён для $package"
    # Markdown-таблицы (старый формат): [**package**](...) | `version` |
    elif grep -q "\[\*\*${package}\*\*\]" "$readme"; then
        sed -i -E "s/(\[\*\*${package}\*\*\][^|]+\|[[:space:]]*)\`[^\`]+\`/\1\`${new_version}\`/" "$readme"
        log_verbose "README обновлён для $package"
    fi
}

# Проверить и обновить один пакет
check_package() {
    local package="$1"
    local repo="${PACKAGE_REPOS["$package"]:-}"

    if [[ -z "${PACKAGE_REPOS["$package"]:+x}" && -z "${PACKAGE_DEB_DEFAULT["$package"]:+x}" && -z "${PACKAGE_TGZ_DEFAULT["$package"]:+x}" && -z "${PACKAGE_APT_INDEX["$package"]:+x}" && -z "${PACKAGE_STATIC_URL["$package"]:+x}" ]]; then
        log_error "Неизвестный пакет: $package"
        return 1
    fi

    log_verbose "Проверка пакета: $package (${PACKAGE_REDIRECT_URL["$package"]:-${PACKAGE_DEB_DEFAULT["$package"]:-${PACKAGE_TGZ_DEFAULT["$package"]:-${PACKAGE_APT_INDEX["$package"]:-${PACKAGE_STATIC_URL["$package"]:-$repo}}}}})"

    local current_version
    current_version=$(get_current_version "$package") || return 1

    local latest_raw
    latest_raw=$(get_latest_version "$repo" "$package")

    if [[ -z "$latest_raw" ]]; then
        log_warning "$package: не удалось получить последнюю версию"
        return 1
    fi

    local latest_version
    latest_version=$(transform_version "$package" "$latest_raw")

    log_verbose "$package: текущая=$current_version, последняя=$latest_version (raw: $latest_raw)"

    if [[ "$current_version" == "$latest_version" ]]; then
        if $UPDATE_CHECKSUMS; then
            update_package_checksums "$package" "$repo" "$latest_version" "$latest_raw"
        fi
        log_success "$package: актуальная версия ($current_version)"
        return 0
    fi

    log_warning "$package: $current_version -> $latest_version"
    update_package_checksums "$package" "$repo" "$latest_version" "$latest_raw"
    update_staplerfile_version "$package" "$latest_version"
    update_readme_version "$package" "$current_version" "$latest_version"
}

# Проверить все пакеты
check_all_packages() {
    local failures=0
    local packages=("${LUMA_DEFAULT_PACKAGES[@]}")

    echo ""
    log_info "Проверка версий пакетов..."
    echo ""

    local _first_pkg=true
    local package
    for package in "${packages[@]}"; do
        if ! $_first_pkg; then
            # снижает риск secondary rate limit GitHub API (без токена ~60 зпр/ч)
            sleep 2
        fi
        _first_pkg=false
        if ! check_package "$package"; then
            failures=$((failures + 1))
        fi
    done

    echo ""

    if [[ $failures -gt 0 ]]; then
        log_error "Проверка завершилась с ошибками: $failures"
        return 1
    fi
}

# Проверка зависимостей
check_dependencies() {
    local missing=()

    if ! command -v curl &>/dev/null; then
        missing+=("curl")
    fi

    if ! command -v jq &>/dev/null; then
        missing+=("jq")
    fi

    if ! command -v sha256sum &>/dev/null; then
        missing+=("sha256sum")
    fi

    if ! command -v ar &>/dev/null; then
        missing+=("binutils")
    fi

    if ! command -v tar &>/dev/null; then
        missing+=("tar")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Отсутствуют зависимости: ${missing[*]}"
        log_info "Установите: sudo apt install ${missing[*]}"
        exit 1
    fi
}

# Парсинг аргументов
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -a|--all)
                UPDATE_ALL=true
                shift
                ;;
            -c|--checksums)
                UPDATE_CHECKSUMS=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                log_error "Неизвестная опция: $1"
                usage
                exit 1
                ;;
            *)
                SPECIFIC_PACKAGE="$1"
                shift
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    check_dependencies

    if $DRY_RUN; then
        log_info "Режим dry-run: изменения не будут применены"
    fi

    if [[ -n "$SPECIFIC_PACKAGE" ]]; then
        check_package "$SPECIFIC_PACKAGE"
    else
        check_all_packages
    fi
}

main "$@"

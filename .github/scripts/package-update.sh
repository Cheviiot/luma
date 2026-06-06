#!/bin/bash
# stplr-spec-compatible update helper for Luma packages.

set -euo pipefail

PACKAGES=(
    adwyra
    clash-verge
    codex-app
    github-plus
    happ
    hydralauncher
    netbird
    netbird-ui
    parsec
    pineconemc
    prismlauncher
    tailscale
    terax
    vanyavpn
    vual
    warp
    windsurf
)

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

usage() {
    cat <<EOF
Usage: $(basename "$0") <command> [package]

Commands:
  check <package>      Print "<current> <latest>" for stplr-spec update-check
  check-all            Print all package version states; exits 10 if updates exist
  apply <package>      Update version, reset release to 1, and refresh checksums
  apply-all            Apply all available updates
EOF
}

die() {
    echo "error: $*" >&2
    exit 1
}

github_api() {
    local headers=(-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28")

    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        headers+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    fi

    curl --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 30 --max-time 120 -fsSL "${headers[@]}" "$@"
}

download() {
    curl --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 30 --max-time 300 -fsSL "$@"
}

strip_v() {
    local version="$1"
    echo "${version#v}"
}

current_version() {
    local package="$1"
    awk -F"'" '/^version=/{print $2; exit}' "${repo_root}/${package}/Staplerfile"
}

github_latest_release() {
    local repo="$1"
    local tag

    tag="$(
        github_api "https://api.github.com/repos/${repo}/releases" |
            jq -r '[.[] | select(.prerelease | not) | .tag_name][0] // empty'
    )"

    if [[ -z "$tag" ]]; then
        tag="$(
            github_api "https://api.github.com/repos/${repo}/tags" |
                jq -r '.[0].name // empty'
        )"
    fi

    [[ -n "$tag" ]] || die "cannot determine latest GitHub tag for ${repo}"
    strip_v "$tag"
}

latest_tailscale() {
    local headers version

    headers="$(curl --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 30 --max-time 120 -fsSLI \
        "https://pkgs.tailscale.com/stable/tailscale_latest_amd64.tgz")"

    version="$(
        printf '%s\n' "$headers" |
            sed -n 's/.*tailscale_\([0-9][0-9.]*\)_amd64\.tgz.*/\1/p' |
            tail -1
    )"

    [[ -n "$version" ]] || die "cannot determine latest Tailscale version"
    echo "$version"
}

deb_control_field() {
    local url="$1"
    local field="$2"
    local tmp

    tmp="$(mktemp -d)"

    download -o "${tmp}/package.deb" "$url"
    (
        cd "$tmp"
        ar x package.deb
        tar -xOf control.tar.* ./control
    ) | awk -v field="${field}:" '$1 == field {print $2; exit}'

    rm -rf "$tmp"
}

latest_warp() {
    deb_control_field "https://app.warp.dev/download?package=deb" Version
}

latest_parsec() {
    deb_control_field "https://builds.parsec.app/package/parsec-linux.deb" Version
}

latest_windsurf() {
    local packages version

    packages="$(
        curl --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 30 --max-time 120 -fsSL \
            "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt/dists/stable/main/binary-amd64/Packages"
    )"

    version="$(
        printf '%s\n' "$packages" |
            awk '
                /^Package: windsurf$/ {found=1; version=""; filename=""; next}
                found && /^Version: / {version=$2; next}
                found && /^Filename: / {filename=$2; next}
                found && /^$/ {
                    if (filename ~ /Windsurf-linux-x64-.*\.deb$/ && version != "") {
                        print version
                        exit
                    }
                    found=0
                }
            '
    )"

    if [[ -z "$version" ]] && printf '%s\n' "$packages" | grep -q 'Devin-linux-x64-.*-transitional\.deb'; then
        current_version windsurf
        return
    fi

    version="${version#*:}"
    version="${version%%-*}"
    [[ -n "$version" ]] || die "cannot determine latest Windsurf version"
    echo "$version"
}

latest_vanyavpn() (
    local appimage_source appimage_url tmp version

    command -v strings >/dev/null 2>&1 || die "strings from binutils is required to determine VanyaVPN version"

    appimage_source="$(
        package_sources vanyavpn sources |
            awk '$0 !~ /^local:\/\// {print; exit}'
    )"
    appimage_url="$(real_source_url "$appimage_source")"
    [[ -n "$appimage_url" ]] || die "cannot determine VanyaVPN AppImage source"

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    download -o "${tmp}/vanyavpn.AppImage" "$appimage_url"
    chmod +x "${tmp}/vanyavpn.AppImage"

    (
        cd "$tmp"
        ./vanyavpn.AppImage --appimage-extract 'resources/app.asar' >/dev/null
    )

    version="$(
        strings "${tmp}/squashfs-root/resources/app.asar" |
            awk '
                version == "" && index($0, "\"APP_VERSION\":\"") {
                    split($0, fields, "\"APP_VERSION\":\"")
                    split(fields[2], parts, "\"")
                    version = parts[1]
                }
                build == "" && index($0, "\"APP_BUILD_NUMBER\":") {
                    split($0, fields, "\"APP_BUILD_NUMBER\":")
                    build = fields[2]
                    sub(/[^0-9].*/, "", build)
                }
                END {
                    if (version != "") {
                        printf "%s", version
                        if (build != "") {
                            printf "+%s", build
                        }
                        print ""
                    }
                }
            '
    )"

    [[ -n "$version" ]] || die "cannot determine latest VanyaVPN version from AppImage"
    echo "$version"
)

latest_version() {
    local package="$1"

    case "$package" in
    adwyra) github_latest_release "Cheviiot/adwyra" ;;
    clash-verge) github_latest_release "clash-verge-rev/clash-verge-rev" ;;
    codex-app) github_latest_release "Boria138/codex-app-linux" ;;
    github-plus) github_latest_release "pol-rivero/github-desktop-plus" ;;
    happ) github_latest_release "Happ-proxy/happ-desktop" ;;
    hydralauncher) github_latest_release "hydralauncher/hydra" ;;
    netbird) github_latest_release "netbirdio/netbird" ;;
    netbird-ui) github_latest_release "netbirdio/netbird" ;;
    parsec) latest_parsec ;;
    pineconemc) github_latest_release "ElyPrismLauncher/Launcher" ;;
    prismlauncher) github_latest_release "PrismLauncher/PrismLauncher" ;;
    tailscale) latest_tailscale ;;
    terax) github_latest_release "crynta/terax-ai" ;;
    vanyavpn) latest_vanyavpn ;;
    vual) github_latest_release "Cheviiot/Vual" ;;
    warp) latest_warp ;;
    windsurf) latest_windsurf ;;
    *) die "unknown package: ${package}" ;;
    esac
}

package_sources() {
    local package="$1"
    local array_name="$2"

    (
        local declaration

        set +u
        cd "${repo_root}/${package}"
        # shellcheck source=/dev/null
        source ./Staplerfile
        if declaration="$(declare -p "$array_name" 2>/dev/null)" && [[ "$declaration" == declare\ -*a* ]]; then
            eval 'printf "%s\n" "${'"$array_name"'[@]}"'
        fi
    )
}

real_source_url() {
    local source="$1"

    source="${source%%&~*}"
    source="${source%%\?~*}"
    echo "$source"
}

source_checksum() {
    local package="$1"
    local source="$2"
    local real_source tmp

    real_source="$(real_source_url "$source")"

    case "$real_source" in
    local:///*)
        sha256sum "${repo_root}/${package}/${real_source#local:///}" | awk '{print $1}'
        ;;
    *)
        tmp="$(mktemp -d)"
        download -o "${tmp}/source" "$real_source"
        sha256sum "${tmp}/source" | awk '{print $1}'
        rm -rf "$tmp"
        ;;
    esac
}

replace_array() {
    local file="$1"
    local array_name="$2"
    shift 2

    local block
    block="${array_name}=("$'\n'

    local value
    for value in "$@"; do
        block+="    '${value}'"$'\n'
    done

    block+=")"

    ARRAY_NAME="$array_name" ARRAY_BLOCK="$block" perl -0pi -e '
        my $name = quotemeta($ENV{"ARRAY_NAME"});
        my $block = $ENV{"ARRAY_BLOCK"};
        s/${name}=\(\n.*?\n\)/$block/s or die "array not found\n";
    ' "$file"
}

set_version() {
    local package="$1"
    local version="$2"
    local file="${repo_root}/${package}/Staplerfile"

    VERSION="$version" perl -0pi -e '
        my $version = $ENV{"VERSION"};
        s/^version='\''[^'\'']*'\''/version='\''$version'\''/m or die "version field not found\n";
        s/^release=[0-9]+/release=1/m or die "release field not found\n";
    ' "$file"
}

refresh_checksums() {
    local package="$1"
    local file="${repo_root}/${package}/Staplerfile"

    local sources=()
    local checksums=()
    mapfile -t sources < <(package_sources "$package" sources)

    local source
    for source in "${sources[@]}"; do
        [[ -n "$source" ]] || continue
        checksums+=("$(source_checksum "$package" "$source")")
    done

    replace_array "$file" checksums "${checksums[@]}"

    local sources_arm64=()
    mapfile -t sources_arm64 < <(package_sources "$package" sources_arm64)

    if [[ -n "${sources_arm64[*]}" ]]; then
        local checksums_arm64=()
        for source in "${sources_arm64[@]}"; do
            [[ -n "$source" ]] || continue
            checksums_arm64+=("$(source_checksum "$package" "$source")")
        done
        replace_array "$file" checksums_arm64 "${checksums_arm64[@]}"
    fi

    if command -v shfmt >/dev/null 2>&1; then
        shfmt -w -i 4 "$file"
    fi
}

join_markdown_codes() {
    local result=""
    local value

    for value in "$@"; do
        if [[ -n "$result" ]]; then
            result+=", "
        fi
        result+="\`${value}\`"
    done

    printf '%s\n' "$result"
}

sync_readme_package() {
    local package="$1"
    local file="${repo_root}/README.md"
    local version arch_text license_text
    local architectures=()
    local licenses=()

    version="$(current_version "$package")"
    mapfile -t architectures < <(package_sources "$package" architectures)
    mapfile -t licenses < <(package_sources "$package" license)
    arch_text="$(join_markdown_codes "${architectures[@]}")"
    license_text="$(join_markdown_codes "${licenses[@]}")"

    PACKAGE="$package" VERSION="$version" ARCHITECTURES="$arch_text" LICENSES="$license_text" perl -0pi -e '
        my $package = quotemeta($ENV{"PACKAGE"});
        my $version = $ENV{"VERSION"};
        my $architectures = $ENV{"ARCHITECTURES"};
        my $licenses = $ENV{"LICENSES"};

        s{^(\|[^\n]*\]\(\./$package\)<br>[^\n]*?\| )`[^`]+`( \| )[^|]+(\|[^\n]*\|)$}{$1`$version`$2$architectures $3}gm
            or die "README catalog row not found for $ENV{PACKAGE}\n";

        s{^(\| `$package` \| [^|]+ \| [^|]+ \| )`[^`]+`( \| )[^|]+( \| )[^|]+(\|)$}{$1`$version`$2$licenses$3$architectures $4}gm
            or die "README summary row not found for $ENV{PACKAGE}\n";
    ' "$file"
}

check_package() {
    local package="$1"
    local current latest

    current="$(current_version "$package")"
    latest="$(latest_version "$package")"

    echo "$current $latest"
}

check_all() {
    local updates=0
    local package current latest status

    printf '%-14s %-32s %-32s %s\n' "PACKAGE" "CURRENT" "LATEST" "STATUS"

    for package in "${PACKAGES[@]}"; do
        read -r current latest < <(check_package "$package")
        if [[ "$current" == "$latest" ]]; then
            status="current"
        else
            status="update"
            updates=1
        fi
        printf '%-14s %-32s %-32s %s\n' "$package" "$current" "$latest" "$status"
    done

    if [[ "$updates" -eq 1 ]]; then
        return 10
    fi
}

apply_package() {
    local package="$1"
    local current latest

    read -r current latest < <(check_package "$package")

    if [[ "$current" == "$latest" ]]; then
        echo "${package}: current (${current})"
        return 0
    fi

    echo "${package}: ${current} -> ${latest}"
    set_version "$package" "$latest"
    refresh_checksums "$package"
    sync_readme_package "$package"
}

apply_all() {
    local package

    for package in "${PACKAGES[@]}"; do
        apply_package "$package"
    done
}

main() {
    local command="${1:-}"
    local package="${2:-}"

    case "$command" in
    check)
        [[ -n "$package" ]] || die "package is required"
        check_package "$package"
        ;;
    check-all)
        check_all
        ;;
    apply)
        [[ -n "$package" ]] || die "package is required"
        apply_package "$package"
        ;;
    apply-all)
        apply_all
        ;;
    -h | --help | help)
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
    esac
}

main "$@"

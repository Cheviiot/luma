#!/bin/bash
# Build every Luma package in Docker images for supported distro families.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

ROOT_DIR="$LUMA_REPO_ROOT"

if [[ -n "${LUMA_DISTROS:-}" ]]; then
    read -r -a DISTROS <<<"${LUMA_DISTROS}"
else
    DISTROS=("${LUMA_DEFAULT_DISTROS[@]}")
fi

if [[ $# -gt 0 ]]; then
    PACKAGES=("$@")
else
    PACKAGES=("${LUMA_DEFAULT_PACKAGES[@]}")
fi

image_for_distro() {
    luma_distro_image "$1"
}

run_distro() {
    local distro="$1"
    local image
    image="$(image_for_distro "$distro")" || return 1

    echo
    echo "=============================================="
    echo "  Docker build matrix: ${distro} (${image})"
    echo "=============================================="

    docker run --rm -i --privileged \
        -e "LUMA_DISTRO=${distro}" \
        -e "LUMA_PACKAGES=${PACKAGES[*]}" \
        -v "${ROOT_DIR}:/repo-src:ro" \
        "${image}" bash -s <<'CONTAINER'
set -euo pipefail

install_common() {
    case "$LUMA_DISTRO" in
        alt-p11)
            apt-get update -qq
            apt-get install -y -qq \
                stplr rpm-build ca-certificates ca-trust git binutils \
                tar gzip bzip2 xz python3 >/dev/null
            update-ca-trust 2>/dev/null || true
            ;;
        debian-13|ubuntu-24.04)
            apt-get update -qq
            DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
                curl ca-certificates git binutils tar gzip bzip2 xz-utils \
                zstd rpm python3 dpkg-dev fakeroot >/dev/null
            curl -fsSL get.stplr.dev | bash >/tmp/stplr-install.log 2>&1
            ;;
        fedora)
            dnf -y -q install \
                curl ca-certificates git binutils tar gzip bzip2 xz zstd \
                rpm-build python3 cpio >/dev/null
            curl -fsSL get.stplr.dev | bash >/tmp/stplr-install.log 2>&1
            ;;
        arch)
            pacman -Sy --noconfirm --needed \
                curl ca-certificates git binutils tar gzip bzip2 xz zstd \
                base-devel python >/dev/null
            trust extract-compat 2>/dev/null || true
            curl -fsSL get.stplr.dev | bash >/tmp/stplr-install.log 2>&1
            ;;
    esac
}

prepare_repo_copy() {
    mkdir -p /work/repo
    tar -C /repo-src \
        --exclude='.git' \
        --exclude='*.rpm' \
        --exclude='*.deb' \
        --exclude='*.pkg.tar*' \
        -cf - . | tar -C /work/repo -xf -
}

build_package() {
    local pkg="$1"
    local log="/tmp/build-${pkg}.log"

    echo
    echo "==> ${LUMA_DISTRO}: build ${pkg}"
    cd "/work/repo/${pkg}"
    rm -f ./*.rpm ./*.deb ./*.pkg.tar* 2>/dev/null || true

    if stplr build --clean >"$log" 2>&1; then
        local artifact
        artifact="$(
            find . -maxdepth 1 -type f \
                \( -name '*.rpm' -o -name '*.deb' -o -name '*.pkg.tar*' \) \
                -printf '%f\n' | head -1
        )"
        if [[ -z "$artifact" ]]; then
            echo "FAIL ${pkg}: build completed but artifact was not produced"
            tail -80 "$log"
            return 1
        fi
        echo "PASS ${pkg}: ${artifact}"
        return 0
    fi

    echo "FAIL ${pkg}: build failed"
    tail -120 "$log"
    return 1
}

install_common
prepare_repo_copy

echo "OS: $(. /etc/os-release && echo "${PRETTY_NAME}")"
echo "stplr: $(stplr version 2>&1)"

fail=0
read -r -a packages <<<"$LUMA_PACKAGES"
for pkg in "${packages[@]}"; do
    build_package "$pkg" || fail=1
done

exit "$fail"
CONTAINER
}

fail=0
for distro in "${DISTROS[@]}"; do
    if run_distro "$distro"; then
        echo "PASS distro: ${distro}"
    else
        echo "FAIL distro: ${distro}"
        fail=1
    fi
done

exit "$fail"

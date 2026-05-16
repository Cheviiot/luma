#!/bin/bash
# Shared CI/test metadata for Luma.

LUMA_COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LUMA_GITHUB_DIR="$(dirname "$LUMA_COMMON_DIR")"
LUMA_REPO_ROOT="$(dirname "$LUMA_GITHUB_DIR")"

LUMA_DEFAULT_PACKAGES=(
    adwyra
    vual
    github-plus
    happ
    clash-verge
    tailscale
    warp
    windsurf
    terax
    vanyavpn
)

LUMA_DEFAULT_DISTROS=(
    alt-p11
    debian-13
    ubuntu-24.04
    fedora
    arch
)

luma_distro_image() {
    case "$1" in
        alt-p11) echo "alt:p11" ;;
        debian-13) echo "debian:13-slim" ;;
        ubuntu-24.04) echo "ubuntu:24.04" ;;
        fedora) echo "fedora:latest" ;;
        arch) echo "archlinux:latest" ;;
        *)
            echo "unknown distro preset: $1" >&2
            return 1
            ;;
    esac
}

luma_join_by() {
    local separator="$1"
    shift

    local first=true
    local item
    for item in "$@"; do
        if [[ "$first" == true ]]; then
            printf '%s' "$item"
            first=false
        else
            printf '%s%s' "$separator" "$item"
        fi
    done
}

luma_log_info() {
    printf '[INFO] %s\n' "$*"
}

luma_log_pass() {
    printf '[PASS] %s\n' "$*"
}

luma_log_fail() {
    printf '[FAIL] %s\n' "$*" >&2
}

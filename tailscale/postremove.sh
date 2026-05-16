#!/bin/bash
# Скрипт после удаления
# Запускается как root

# $1 = 0 означает полное удаление, $1 > 0 означает обновление
if [ "${1:-0}" -eq 0 ]; then
    if command -v tailscale &>/dev/null; then
        tailscale down 2>/dev/null || true
        tailscale logout 2>/dev/null || true
    fi

    if command -v systemctl &>/dev/null; then
        systemctl stop tailscaled.service 2>/dev/null || true
        systemctl stop tailscaled 2>/dev/null || true
        systemctl disable tailscaled.service 2>/dev/null || true
        systemctl disable tailscaled 2>/dev/null || true
        systemctl daemon-reload 2>/dev/null || true
        systemctl reset-failed tailscaled.service 2>/dev/null || true
        systemctl reset-failed tailscaled 2>/dev/null || true
    fi

    rm -rf \
        /var/lib/tailscale \
        /var/cache/tailscale \
        /var/run/tailscale \
        /run/tailscale \
        /etc/tailscale \
        2>/dev/null || true

    rm -f \
        /var/log/tailscaled.log \
        /var/log/tailscale.log \
        2>/dev/null || true
fi

exit 0

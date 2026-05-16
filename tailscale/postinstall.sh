#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /usr/bin/tailscale 2>/dev/null || true
chmod +x /usr/sbin/tailscaled 2>/dev/null || true

if command -v systemctl &>/dev/null; then
    systemctl daemon-reload 2>/dev/null || true
    systemctl enable tailscaled.service 2>/dev/null || true
    systemctl start tailscaled.service 2>/dev/null || true
fi

REAL_USER="${SUDO_USER:-}"
if [[ -z "$REAL_USER" ]] && [[ -n "${PKEXEC_UID:-}" ]]; then
    REAL_USER=$(id -nu "$PKEXEC_UID" 2>/dev/null || true)
fi
if [[ -z "$REAL_USER" ]] && command -v logname &>/dev/null; then
    REAL_USER=$(logname 2>/dev/null || true)
fi

if [[ -n "$REAL_USER" ]] && [[ "$REAL_USER" != "root" ]] && id "$REAL_USER" &>/dev/null && command -v tailscale &>/dev/null; then
    for _ in 1 2 3 4 5; do
        tailscale status --json &>/dev/null && break
        sleep 1
    done
    tailscale set --operator="$REAL_USER" 2>/dev/null || true
fi

exit 0

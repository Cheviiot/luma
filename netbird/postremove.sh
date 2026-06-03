#!/bin/bash
# Скрипт после удаления
# Запускается как root

if [ "${1:-0}" -eq 0 ]; then
    if command -v netbird >/dev/null 2>&1; then
        netbird down 2>/dev/null || true
        netbird service stop 2>/dev/null || true
        netbird service uninstall 2>/dev/null || true
    fi

    if command -v systemctl >/dev/null 2>&1; then
        systemctl stop netbird.service 2>/dev/null || true
        systemctl disable netbird.service 2>/dev/null || true
        systemctl daemon-reload 2>/dev/null || true
        systemctl reset-failed netbird.service 2>/dev/null || true
    fi
fi

exit 0

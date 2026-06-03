#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /usr/bin/netbird 2>/dev/null || true

if command -v systemctl >/dev/null 2>&1; then
    systemctl stop netbird.service 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true
fi

if [ -x /usr/bin/netbird ]; then
    /usr/bin/netbird service uninstall 2>/dev/null || true
    /usr/bin/netbird service install 2>/dev/null || true
    /usr/bin/netbird service start 2>/dev/null || true
fi

if command -v systemctl >/dev/null 2>&1; then
    systemctl enable netbird.service 2>/dev/null || true
    systemctl start netbird.service 2>/dev/null || true
fi

exit 0

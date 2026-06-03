#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /usr/bin/netbird-ui 2>/dev/null || true

if ! command -v netbird >/dev/null 2>&1; then
    echo "NetBird UI установлен, но CLI/daemon netbird не найден. Установите пакет netbird для подключения к сети." >&2
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

pid="$(pgrep -x -f /usr/bin/netbird-ui 2>/dev/null || true)"
if [ -n "${pid}" ]; then
    uid="$(cat "/proc/${pid}/loginuid" 2>/dev/null || true)"
    if [ -z "${uid}" ] || [ "${uid}" = "4294967295" ] || [ "${uid}" = "-1" ]; then
        uid="$(stat -c '%u' "/proc/${pid}" 2>/dev/null || true)"
    fi

    if [ -n "${uid}" ]; then
        username="$(id -nu "${uid}" 2>/dev/null || true)"
        if [ -n "${username}" ]; then
            pkill -x -f /usr/bin/netbird-ui >/dev/null 2>&1 || true
            su - "${username}" -c 'nohup /usr/bin/netbird-ui >/dev/null 2>&1 &' 2>/dev/null || true
        fi
    fi
fi

exit 0

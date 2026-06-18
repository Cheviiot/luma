#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /usr/bin/mindustry 2>/dev/null || true

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

exit 0

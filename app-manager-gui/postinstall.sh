#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /usr/bin/app-manager-gui 2>/dev/null || true
chmod +x /usr/bin/app_manager 2>/dev/null || true
chmod +x /opt/app-manager-gui/app_manager 2>/dev/null || true

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental 2>/dev/null || true
elif command -v kbuildsycoca5 >/dev/null 2>&1; then
    kbuildsycoca5 --noincremental 2>/dev/null || true
fi

exit 0

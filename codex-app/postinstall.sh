#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

chmod +x /opt/codex-app/codex-app 2>/dev/null || true
chmod +x /opt/codex-app/resources/codex 2>/dev/null || true

if [[ -f /opt/codex-app/chrome-sandbox ]]; then
    if [[ -L /proc/self/ns/user ]] && command -v unshare >/dev/null 2>&1 && unshare --user true 2>/dev/null; then
        chmod 0755 /opt/codex-app/chrome-sandbox 2>/dev/null || true
    else
        chmod 4755 /opt/codex-app/chrome-sandbox 2>/dev/null || true
    fi
fi

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

if command -v kbuildsycoca6 &>/dev/null; then
    kbuildsycoca6 --noincremental 2>/dev/null || true
elif command -v kbuildsycoca5 &>/dev/null; then
    kbuildsycoca5 --noincremental 2>/dev/null || true
fi

exit 0

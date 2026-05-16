#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

mkdir -p /usr/bin
ln -sf /opt/Hydra/hydralauncher /usr/bin/hydralauncher

chmod +x /opt/Hydra/hydralauncher 2>/dev/null || true

if [[ -f /opt/Hydra/chrome-sandbox ]]; then
    if [[ -L /proc/self/ns/user ]] && command -v unshare >/dev/null 2>&1 && unshare --user true 2>/dev/null; then
        chmod 0755 /opt/Hydra/chrome-sandbox 2>/dev/null || true
    else
        chmod 4755 /opt/Hydra/chrome-sandbox 2>/dev/null || true
    fi
fi

if command -v update-mime-database >/dev/null 2>&1; then
    update-mime-database /usr/share/mime 2>/dev/null || true
fi

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

if command -v apparmor_status >/dev/null 2>&1 &&
    command -v apparmor_parser >/dev/null 2>&1 &&
    apparmor_status --enabled >/dev/null 2>&1 &&
    [[ -f /opt/Hydra/resources/apparmor-profile ]]; then
    profile_source=/opt/Hydra/resources/apparmor-profile
    profile_target=/etc/apparmor.d/hydralauncher

    if apparmor_parser --skip-kernel-load --debug "$profile_source" >/dev/null 2>&1; then
        install -Dm644 "$profile_source" "$profile_target"
        if ! { [[ -x /usr/bin/ischroot ]] && /usr/bin/ischroot; }; then
            apparmor_parser --replace --write-cache --skip-read-cache "$profile_target" 2>/dev/null || true
        fi
    fi
fi

exit 0

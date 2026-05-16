#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

# Исполняемые файлы из upstream .deb иногда приходят с консервативными правами
chmod +x /usr/bin/clash-verge 2>/dev/null || true
chmod +x /usr/bin/install-service 2>/dev/null || true
chmod +x /usr/bin/uninstall-service 2>/dev/null || true
chmod +x /usr/bin/verge-mihomo 2>/dev/null || true
chmod +x /usr/bin/verge-mihomo-alpha 2>/dev/null || true
chmod +x "/usr/lib/Clash Verge/resources/clash-verge-service" 2>/dev/null || true

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

exit 0

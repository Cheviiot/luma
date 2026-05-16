#!/bin/bash
# Скрипт после удаления
# Запускается как root

# Останавливаем и удаляем OutlineProxyController
SERVICE_NAME="outline_proxy_controller.service"
if command -v systemctl &>/dev/null; then
    systemctl stop "${SERVICE_NAME}" 2>/dev/null || true
    systemctl disable "${SERVICE_NAME}" 2>/dev/null || true
    rm -f "/etc/systemd/system/${SERVICE_NAME}" 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true
fi
rm -f /usr/local/sbin/OutlineProxyController 2>/dev/null || true

# Удаляем пустую директорию приложения
rmdir /opt/vanyavpn 2>/dev/null || true

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

exit 0

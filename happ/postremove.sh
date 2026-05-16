#!/bin/bash
# Скрипт после удаления
# Запускается как root

# $1 = 0 означает полное удаление, $1 > 0 означает обновление
if [ "${1:-0}" -eq 0 ]; then
    # Останавливаем systemd сервис
    if command -v systemctl &>/dev/null; then
        systemctl stop happd.service 2>/dev/null || true
        systemctl disable happd.service 2>/dev/null || true
        systemctl daemon-reload 2>/dev/null || true
    fi

    # Очищаем данные маршрутизации
    rm -rf /opt/happ/bin/core/routing 2>/dev/null || true
fi

# Обновляем MIME-базу данных
if command -v update-mime-database &>/dev/null; then
    update-mime-database /usr/share/mime 2>/dev/null || true
fi

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

exit 0

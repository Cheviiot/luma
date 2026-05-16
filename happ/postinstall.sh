#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

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

# Устанавливаем права на исполнение
chmod +x /opt/happ/bin/Happ 2>/dev/null || true
chmod +x /opt/happ/bin/happ-tcping 2>/dev/null || true
chmod +x /opt/happ/bin/happd 2>/dev/null || true
chmod +x /opt/happ/bin/core/xray 2>/dev/null || true
chmod +x /opt/happ/bin/tun/sing-box 2>/dev/null || true
chmod +x /opt/happ/bin/tun2/tun2proxy-bin 2>/dev/null || true
chmod +x /opt/happ/bin/tun2/udpgw-server 2>/dev/null || true
chmod +x /opt/happ/bin/antifilter/antifilter 2>/dev/null || true

# Запускаем systemd сервис
if command -v systemctl &>/dev/null; then
    systemctl daemon-reload 2>/dev/null || true
    systemctl enable happd.service 2>/dev/null || true
    systemctl start happd.service 2>/dev/null || true
fi

exit 0

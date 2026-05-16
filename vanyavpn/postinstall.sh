#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

CONTROLLER_DIR="/opt/vanyavpn/resources/app.asar.unpacked/tools/outline_proxy_controller/dist"
TUN2SOCKS_DIR="/opt/vanyavpn/resources/app.asar.unpacked/third_party/outline-go-tun2socks/linux"
SERVICE_NAME="outline_proxy_controller.service"

# Исполняемые файлы из распакованного AppImage
chmod +x /opt/vanyavpn/AppRun 2>/dev/null || true
chmod +x /opt/vanyavpn/outline-client 2>/dev/null || true
chmod +x "${CONTROLLER_DIR}/OutlineProxyController" 2>/dev/null || true
chmod +x "${TUN2SOCKS_DIR}/tun2socks" 2>/dev/null || true

# Устанавливаем OutlineProxyController — systemd-сервис для создания TUN-адаптера
if [[ -f "${CONTROLLER_DIR}/OutlineProxyController" ]] && command -v systemctl &>/dev/null; then
    # Создаём группу outlinevpn
    groupadd -f outlinevpn 2>/dev/null || true

    # Добавляем текущего пользователя (SUDO_USER или PKEXEC_UID) в группу
    REAL_USER="${SUDO_USER:-}"
    if [[ -z "$REAL_USER" ]] && [[ -n "${PKEXEC_UID:-}" ]]; then
        REAL_USER=$(id -nu "$PKEXEC_UID" 2>/dev/null || true)
    fi
    if [[ -n "$REAL_USER" ]] && id "$REAL_USER" &>/dev/null; then
        usermod -aG outlinevpn "$REAL_USER" 2>/dev/null || true
    fi

    # Копируем контроллер
    install -Dm755 "${CONTROLLER_DIR}/OutlineProxyController" /usr/local/sbin/OutlineProxyController

    # Устанавливаем service-файл с правильным owning-user-id
    install -Dm644 "${CONTROLLER_DIR}/${SERVICE_NAME}" "/etc/systemd/system/${SERVICE_NAME}"
    if [[ -n "$REAL_USER" ]] && id "$REAL_USER" &>/dev/null; then
        OWNER_UID=$(id -u "$REAL_USER")
        sed -i "s/--owning-user-id=-1/--owning-user-id=${OWNER_UID}/g" \
            "/etc/systemd/system/${SERVICE_NAME}"
    fi

    # Запускаем сервис
    systemctl daemon-reload 2>/dev/null || true
    systemctl enable "${SERVICE_NAME}" 2>/dev/null || true
    systemctl restart "${SERVICE_NAME}" 2>/dev/null || true
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

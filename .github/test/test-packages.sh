#!/bin/bash
# Test package build, install, and removal inside the lifecycle Docker image.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASS=0
FAIL=0
SKIP=0
RESULTS=()

log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; RESULTS+=("PASS: $1"); ((PASS++)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; RESULTS+=("FAIL: $1"); ((FAIL++)); }
log_skip() { echo -e "${YELLOW}[SKIP]${NC} $1"; RESULTS+=("SKIP: $1"); ((SKIP++)); }
log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }

RPM_RESULT=""

test_build() {
    local pkg="$1"
    RPM_RESULT=""
    log_info "Сборка $pkg..."

    cd "/repo/$pkg" || { log_fail "$pkg: директория не найдена"; return 1; }

    # Удаляем старые RPM
    rm -f /repo/"$pkg"/*.rpm 2>/dev/null

    # Сборка через stplr
    if stplr build 2>&1 | tee "/tmp/build-${pkg}.log" | tail -5; then
        # Ищем собранный RPM
        local rpm_file
        rpm_file=$(find /repo/"$pkg" -name "*.rpm" -type f 2>/dev/null | head -1)
        if [[ -n "$rpm_file" ]]; then
            log_pass "$pkg: сборка ($(basename "$rpm_file"))"
            RPM_RESULT="$rpm_file"
            return 0
        else
            log_fail "$pkg: сборка — RPM не найден"
            return 1
        fi
    else
        log_fail "$pkg: сборка"
        tail -20 "/tmp/build-${pkg}.log"
        return 1
    fi
}

test_install() {
    local pkg="$1"
    local rpm_file="$2"

    log_info "Установка $pkg ($rpm_file)..."

    # stplr install подтягивает зависимости автоматически
    if stplr install "$rpm_file" 2>&1 | tee "/tmp/install-${pkg}.log" | tail -5; then
        # Проверяем что пакет установлен
        local installed
        installed=$(rpm -qa | grep -i "$pkg" | head -1)
        if [[ -n "$installed" ]]; then
            log_pass "$pkg: установка ($installed)"
            return 0
        fi
        log_fail "$pkg: установка — пакет не найден в rpm -qa"
        return 1
    else
        # stplr может вернуть ненулевой код, но пакет всё равно установлен
        local installed
        installed=$(rpm -qa | grep -i "$pkg" | head -1)
        if [[ -n "$installed" ]]; then
            log_pass "$pkg: установка ($installed) [код возврата ненулевой]"
            return 0
        fi
        log_fail "$pkg: установка"
        cat "/tmp/install-${pkg}.log" | tail -20
        return 1
    fi
}

test_remove() {
    local pkg="$1"

    log_info "Удаление $pkg..."

    # Находим точное имя установленного пакета
    local rpm_name
    rpm_name=$(rpm -qa | grep -i "$pkg" | head -1)

    if [[ -z "$rpm_name" ]]; then
        log_skip "$pkg: удаление — пакет не установлен"
        return 1
    fi

    if rpm -e "$rpm_name" 2>&1 | tee "/tmp/remove-${pkg}.log"; then
        # Проверяем что пакета больше нет
        if rpm -qa | grep -i "$pkg" &>/dev/null; then
            log_fail "$pkg: удаление — пакет всё ещё установлен"
            return 1
        else
            log_pass "$pkg: удаление"
            return 0
        fi
    else
        log_fail "$pkg: удаление"
        cat "/tmp/remove-${pkg}.log" | tail -20
        return 1
    fi
}

test_postscripts() {
    local pkg="$1"

    # Проверяем синтаксис postinstall.sh и postremove.sh
    for script in postinstall.sh postremove.sh; do
        if [[ -f "/repo/$pkg/$script" ]]; then
            if bash -n "/repo/$pkg/$script" 2>&1; then
                log_pass "$pkg: синтаксис $script"
            else
                log_fail "$pkg: синтаксис $script"
            fi
        fi
    done
}

test_package_full() {
    local pkg="$1"

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  Тестирование пакета: $pkg${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Синтаксис скриптов
    test_postscripts "$pkg"

    # Сборка
    test_build "$pkg"
    local build_rc=$?

    if [[ $build_rc -ne 0 ]]; then
        log_skip "$pkg: установка (сборка не удалась)"
        log_skip "$pkg: удаление (сборка не удалась)"
        return
    fi

    # Установка
    test_install "$pkg" "$RPM_RESULT"
    local install_rc=$?

    if [[ $install_rc -ne 0 ]]; then
        log_skip "$pkg: удаление (установка не удалась)"
        return
    fi

    # Удаление
    test_remove "$pkg"
}

# ==================== MAIN ====================

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║   Luma — тест сборки/установки/удаления       ║"
echo "║   Docker lifecycle                            ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Информация о системе
log_info "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
log_info "stplr: $(stplr version 2>&1)"
log_info "rpm: $(rpm --version)"
echo ""

if [[ $# -gt 0 ]]; then
    PACKAGES=("$@")
else
    PACKAGES=("${LUMA_DEFAULT_PACKAGES[@]}")
fi

for pkg in "${PACKAGES[@]}"; do
    test_package_full "$pkg"
done

# ==================== ИТОГИ ====================

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗"
echo -e "║               ИТОГИ ТЕСТИРОВАНИЯ              ║"
echo -e "╚══════════════════════════════════════════════╝${NC}"
echo ""

for r in "${RESULTS[@]}"; do
    case "$r" in
        PASS:*) echo -e "  ${GREEN}✓${NC} ${r#PASS: }" ;;
        FAIL:*) echo -e "  ${RED}✗${NC} ${r#FAIL: }" ;;
        SKIP:*) echo -e "  ${YELLOW}⊘${NC} ${r#SKIP: }" ;;
    esac
done

echo ""
echo -e "  ${GREEN}Passed: $PASS${NC}  ${RED}Failed: $FAIL${NC}  ${YELLOW}Skipped: $SKIP${NC}"
echo ""

if [[ $FAIL -gt 0 ]]; then
    echo -e "${RED}Есть ошибки!${NC}"
    exit 1
else
    echo -e "${GREEN}Все тесты пройдены!${NC}"
    exit 0
fi

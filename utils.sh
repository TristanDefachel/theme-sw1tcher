#!/bin/bash
# =============================================================
#  Utils Functions
# =============================================================
set -e

# Colors variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Bold variables
BOLD='\033[1m'

# Echo with stepper (example: [1/7])
log_step() {
    local current_file="${BASH_SOURCE[1]}"

    if [[ "$LAST_FILE" != "$current_file" ]]; then
        export LAST_FILE="$current_file"
        export STEP_TOTAL=$(grep -c 'log_step' "$current_file")
        export STEP_CURRENT=0
    fi

    export STEP_CURRENT=$((STEP_CURRENT + 1))
    echo -e "==> [$STEP_CURRENT/$STEP_TOTAL] $1"
}
export -f log_step

log_success() { echo -e "  ${GREEN}✔${NC} $1"; }
export -f log_success

log_info() { echo -e "  ${BLUE}➜${NC} $1"; }
export -f log_info

log_warn() { echo -e "  ${RED}⚠️ WARNING:${NC} $1"; }
export -f log_warn


# Ask Question [Y/n]
ask_yes_no() {
    while true; do
        read -p "$(echo -e "🤔 $1 [Y/n] ")" yn
        case $yn in
            ""|Yes|yes|Y|y) return 0 ;;
            No|no|N|n) return 1 ;;
            * ) echo "Please answer y or n." ;;
        esac
    done
}
export -f ask_yes_no

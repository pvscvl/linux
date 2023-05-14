#!/bin/bash


    #   bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/wip.sh)"
    COL_NC='\e[0m' # 
    COL_GREEN='\e[1;32m'
    COL_RED='\e[1;31m'
    COL_GREY='\e[0;37m'
    COL_DARK_GREY='\e[1;30m'
    COL_PURPLE='\e[0;35m'
    COL_BLUE='\e[0;34m'
    COL_YELLOW='\e[0;33m'
    COL_CYAN='\e[0;36m'
    COL_CL=`echo "\033[m"` 
    COL_DIM='\e[2m' #dim
    COL_ITAL='\e[3m' #it
    COL_BOLD='\e[1m' #b
    COL_UNDER='\e[4m' #un
    TICK="${COL_NC}[${COL_GREEN}✓${COL_NC}]  "
    QUEST="${COL_NC}[${COL_BLUE}?${COL_NC}]  "
    col='\e[38;5;46m'
    CROSS="${COL_NC}[${COL_RED}✗${COL_NC}]  "
    INFO="${COL_NC}[i]  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="${COL_NC}[${COL_YELLOW}⚠${COL_NC}]  "
    OVER="\\r\\033[K"

function msg_info() {
    local msg="$1"
    printf "%b ${msg}\\n" "${INFO}"
}

function msg_ok() {
    local msg="$1"
    printf "%b ${msg}\\n" "${TICK}"
}

function msg_no() {
    local msg="$1"
    printf "%b ${msg}\\n" "${CROSS}"
}

# Define dialog boxes
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "install updates" off
         2 "install dist-upgrades" off
         3 "reboot now" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

# Check the options and perform the tasks
for choice in $choices
do
    case $choice in
        1)
            msg_info "${COL_DIM}$hostsys:${COL_NC} installing updates"
            apt-get update &>/dev/null
            apt-get -y upgrade &>/dev/null
            apt-helper
            msg_ok "${COL_DIM}$hostsys:${COL_NC} updates installed"
            echo "Complete"
            ;;
        2)
            msg_info "${COL_DIM}$hostsys:${COL_NC} installing dist-upgrades"
            apt-get update &>/dev/null
            apt-get -y dist-upgrade &>/dev/null
            apt-helper
            msg_ok "${COL_DIM}$hostsys:${COL_NC} dist-upgrades installed"
            echo "Complete"
            ;;
        3)
            msg_info "${COL_DIM}$hostsys:${COL_NC} rebooting"
            sleep 1
            msg_ok "Completed post-installation routines"
            sleep 1
            if [ "$WEBSITE_AVAILABLE" = false ]; then
                echo "Failed"
                msg_no "${COL_DIM}public keys:${COL_NC} not copied"
            fi
            sleep 2
            reboot
            ;;
    esac
done
#!/usr/bin/env bash
PREPPSREVISION=01
PREPPSVERSION="Q3.${REVISION}"

    # Variables
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
    #########################################
    RESET_COLOR='\e[0m' # 
    GREEN='\e[1;32m'
    RED='\e[1;31m'
    GREY='\e[0;37m'
    DARK_GREY='\e[1;30m'
    PURPLE='\e[0;35m'
    BLUE='\e[0;34m'
    YELLOW='\e[0;33m'
    CYAN='\e[0;36m'
    NEW_LINE=`echo "\033[m"` 
    DIMMED='\e[2m' #dim
    ITALICS='\e[3m' #it
    BOLD='\e[1m' #b
    UNDERLINE='\e[4m' #un
    ########################################
    TICK="${COL_NC}[${COL_GREEN}✓${COL_NC}]  "
    QUEST="${COL_NC}[${COL_BLUE}?${COL_NC}]  "
    col='\e[38;5;46m'
    CROSS="${COL_NC}[${COL_RED}✗${COL_NC}]  "
    INFO="${COL_NC}[i]  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="${COL_NC}[${COL_YELLOW}⚠${COL_NC}]  "
    OVER="\\r\\033[K"
    OSTYPE=`uname`
    detected_architecture=`uname -m`
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_env=`systemd-detect-virt`
    zbxagent_current_version="zabbix agent not installed"


    if [ -x "$(command -v zabbix_agentd)" ] ; then
        zbxagent_current_version=`zabbix_agentd --version | head -n1 | sed -e 's/ +$//' -e 's/.* //'`
    fi
    zbxagent_latest_version="$(curl -s "https://api.github.com/repos/zabbix/zabbix/tags" | grep -oP '"name": "\K(.*)(?=")' | head -n1)"
    chktz=`cat /etc/timezone`
    hostsys=`hostname -f`

    WEBSITE_AVAILABLE=false
    if curl --head --silent http://download.local &> /dev/null; then
        URL="http://download.local/"
        WEBSITE_AVAILABLE=true
    else
        if curl --head --silent http://10.0.0.254 &> /dev/null; then
            URL="http://10.0.0.254/"
            WEBSITE_AVAILABLE=true
        fi
    fi
    # Functions
    # Function to check if a package is installed
function package_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

function package_installer() {
    if ! package_installed "$1" then
    echo "$1 installing"
    apt install -y "$1" &> /dev/null
}

function msg_info() {
    local msg="$1"
    printf "%b ${msg}\\n" "${INFO}"
    }
function msg_quest() {
    local msg="$1"
    printf "%b ${msg}${COL_NC}\\n" "${QUEST}${COL_NC}"
    }
function msg_quest_prompt() {
    local msg="$1"
    printf "%b ${msg}"" <y/N> " "${QUEST}";read -r -p "" prompt
	}
function msg_quest() {
    local msg="$1"
    printf "%b ${msg}\\n" "${QUEST}"
	}
function msg_ok() {
    local msg="$1"
    printf "%b ${msg}\\n" "${TICK}"
    }
function msg_no() {
    local msg="$1"
    printf "%b ${msg}\\n" "${CROSS}"
    }
function msg_warn() {
    local msg="$1"
    printf "%b ${msg}\\n" "${WARN}"
    }

function header_info {
    echo -e "${COL_GREEN}
    pascal's    ____  ____  _____
    prepare    / __ \/ __ \/ ___/
    script    / /_/ / /_/ (__  ) 
 ____________/ .___/ .___/____/  
/_____________/   /_/       

${COL_CL}"
    }

function apt-helper {
        # Check if either command needs input and prompt the user
    while [ -n "$(fuser /var/lib/dpkg/lock)" ]; do
        msg_info "Waiting for another package manager to finish..."
       # sleep 5
    done
    while debconf-communicate --list >/dev/null 2>&1; do
        msg_warn "Configuration files have changed. Please review and press Enter to continue."
        read -p ""
    done
    while systemctl status --no-pager -l "systemd-services-shutdown" >/dev/null 2>&1; do
        msg_warn "System services need to be restarted. Please enter 'y' to continue, or 'n' to cancel."
        read -p "" input
        if [ "$input" = "y" ]; then
            systemctl daemon-reexec
        else
            msg_no "Script cancelled."
            exit 1
        fi
    done
    #msg_info "All updates complete!"
}
msg_info "${COL_ITAL}${COL_GREEN}Pre-PPS Version:\\t\\t${COL_NC}${COL_BOLD}${COL_YELLOW}$VERSION ${COL_NC}"

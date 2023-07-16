#!/usr/bin/env bash
VARREVISION="20"
VARVERSION="V7.${VARREVISION}"
export POS=0
    # Variables
#    COL_NC='\e[0m' 
#   COL_GREEN='\e[1;32m'
#    COL_RED='\e[1;31m'
#    COL_GREY='\e[0;37m'
#    COL_DARK_GREY='\e[1;30m'
#    COL_PURPLE='\e[0;35m'
#    COL_BLUE='\e[0;34m'
#    COL_YELLOW='\e[0;33m'
#    COL_CYAN='\e[0;36m'
#    COL_CL=`echo "\033[m"` 
#    COL_DIM='\e[2m' #dim
#    COL_ITAL='\e[3m' #it
#    COL_BOLD='\e[1m' #b
#    COL_UNDER='\e[4m' #un
COL_NC=$(tput sgr0)
COL_GREEN=$(tput setaf 2)
COL_RED=$(tput setaf 1)
COL_GREY=$(tput setaf 7)
COL_DARK_GREY=$(tput setaf 8)
COL_PURPLE=$(tput setaf 5)
COL_BLUE=$(tput setaf 4)
COL_YELLOW=$(tput setaf 3)
COL_CYAN=$(tput setaf 6)
COL_CL=$(tput sgr0)
COL_DIM=$(tput dim)
COL_ITAL=$(tput sitm)
COL_BOLD=$(tput bold)
COL_UNDER=$(tput smul)
ORANGE=$(tput setaf 202)
BLUE1=$(tput setaf 4)
BLUE2=$(tput setaf 12)
BLUE3=$(tput setaf 20)
GREEN2=$(tput setaf 10)
GREEN3=$(tput setaf 40)
    RESET_COLOR='\e[0m' 
    GREEN='\e[1;32m'
    RED='\e[1;31m'
    GREY='\e[0;37m'
    DARK_GREY='\e[1;30m'
    PURPLE='\e[0;35m'
    BLUE='\e[0;34m'
    YELLOW='\e[0;33m'
    CYAN='\e[0;36m'
    NEW_LINE=$(echo "\033[m")
    #NEW_LINE=`echo "\033[m"`     
    DIMMED='\e[2m' #dim
    ITALICS='\e[3m' #it
    BOLD='\e[1m' #b
    UNDERLINE='\e[4m' #un
    
    TICK="${COL_NC}${BOLD}[${COL_GREEN}✓${COL_NC}]  "
    QUEST="${COL_NC}${BOLD}[${COL_CYAN}?${COL_NC}]  "
    col='\e[38;5;46m'
    CROSS="${COL_NC}[${BOLD}${COL_RED}✗${COL_NC}]  "
    INFO="${COL_NC}${BOLD}[i]${COL_NC}  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="${COL_NC}[${BOLD}${COL_YELLOW}!${COL_NC}]  "
    OVER="\\r\\033[K"
    #OSTYPE=`uname`
    OSTYPE=$(uname)
    #detected_architecture=`uname -m`
    detected_architecture=$(uname -m)   
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
#   detected_env=`systemd-detect-virt` 
    detected_env=$(systemd-detect-virt)
    zbxagent_current_version="zabbix agent not installed"
    #zbxagent_latest_version="$(curl -s "https://api.github.com/repos/zabbix/zabbix/tags" | grep -oP '"name": "\K(.*)(?=")' | head -n1)"
    chktz=$(cat /etc/timezone)    
    #chktz=`cat /etc/timezone`
    #hostsys=`hostname -f`  
    hostsys=$(hostname -f)
PPS_DEBUG_CODE=-0
TABSTOP=$(tput hpa 8)
remote_user="loguser"
remote_pw="0000"
remote_path="/Volumes/ssd0/Users/pascaL/logs"
logfile="$(hostname).log"

# Define remote hosts
remote_hosts=("10.0.0.12" "10.0.0.9")
remote_host=""
for host in "${remote_hosts[@]}"; do
  if ping -c 1 $host &> /dev/null
  then
    remote_host=$host
    break
  fi
done

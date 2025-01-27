#!/usr/bin/env bash

#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/pps-bashfull.sh)"


VARREVISION="01"
VARVERSION="V9.${VARREVISION}"

COL_NC=$(tput sgr0)
DEFAULT=$(tput sgr0)
RESETFORMAT=$(tput sgr0)
COL_GREEN=$(tput setaf 2)
GREEN=$(tput setaf 2)
COL_RED=$(tput setaf 1)
COL_GREY=$(tput setaf 7)
COL_DARK_GREY=$(tput setaf 8)
COL_PURPLE=$(tput setaf 5)
COL_BLUE=$(tput setaf 4)
COL_YELLOW=$(tput setaf 3)
YELLOW=$(tput setaf 3)
COL_CYAN=$(tput setaf 6)
COL_CL=$(tput sgr0)
COL_DIM=$(tput dim)
DIMMED=$(tput dim)
COL_ITAL=$(tput sitm)
ITALICS=$(tput sitm)
COL_BOLD=$(tput bold)
BOLD=$(tput bold)
COL_UNDER=$(tput smul)
UNDERLINED=$(tput smul)
ORANGE=$(tput setaf 202)
BLUE1=$(tput setaf 4)
BLUE2=$(tput setaf 12)
BLUE3=$(tput setaf 20)
GREEN2=$(tput setaf 10)
GREEN3=$(tput setaf 40)
RESET_COLOR='\e[0m' 
RED='\e[1;31m'
GREY='\e[0;37m'
DARK_GREY='\e[1;30m'
PURPLE='\e[0;35m'
BLUE='\e[0;34m'
#YELLOW='\e[0;33m'
CYAN='\e[0;36m'
#NEW_LINE=$(echo "\033[m")
#NEW_LINE=`echo "\033[m"`     
#DIMMED='\e[2m' #dim
#ITALICS='\e[3m' #it
#BOLD='\e[1m' #b
UNDERLINE='\e[4m' #un
    
TICK="${COL_NC}${BOLD}[${COL_GREEN}✓${COL_NC}]  "
TICK2="${COL_NC}${BOLD}「${COL_GREEN}✓${COL_NC}」  "
QUEST="${COL_NC}${BOLD}[${COL_CYAN}?${COL_NC}]  "
QUEST2="${COL_NC}${BOLD}「${COL_CYAN}?${COL_NC}」  "
col='\e[38;5;46m'
CROSS="${COL_NC}[${BOLD}${COL_RED}✗${COL_NC}]  "
CROSS2="${COL_NC}「${BOLD}${COL_RED}✗${COL_NC}」  "
INFO="${COL_NC}${BOLD}[i]${COL_NC}  "   
INFO2="${COL_NC}${BOLD}「i」${COL_NC}  "   
DONE="${COL_GREEN} done!${COL_NC}"
WARN="${COL_NC}[${BOLD}${COL_YELLOW}!${COL_NC}]  "
WARN2="${COL_NC}「${BOLD}${COL_YELLOW}!${COL_NC}」  "
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


FUNCREVISION="B#03"
FUNCVERSION="F9.${FUNCREVISION}"
#	export POS=0

function get_mac() {
	local interface
	interface=$(ip route | awk '/default/ {print $5}')

	local mac_address
	mac_address=$(ip link show "$interface" | awk '/ether/ {print $2}')

	local ip_address
	ip_address=$(ip addr show dev "$interface" | awk '/inet / {print $2}')
	echo "$mac_address"
}

function get_ip() {
	local interface
	interface=$(ip route | awk '/default/ {print $5}')

	local mac_address
	mac_address=$(ip link show "$interface" | awk '/ether/ {print $2}')

	local ip_address
	ip_address=$(ip addr show dev "$interface" | awk '/inet / {print $2}')
	echo "$ip_address"
}

function get_interface() {
	local interface
	interface=$(ip route | awk '/default/ {print $5}')

	local mac_address
	mac_address=$(ip link show "$interface" | awk '/ether/ {print $2}')

	local ip_address
	ip_address=$(ip addr show dev "$interface" | awk '/inet / {print $2}')
	echo "$interface"
}

function msg_info() {
	local msg="$1"
	printf "%b ${msg}\\n" "${INFO}"
}

function move2start() {
	tput hpa 0
}

function moveup() {
	tput cuu 1
}  
    
function eraseline() {
	tput el
}  
    
function msg_linfo() {
	#local number="$1"  # Number in digits
	local number=$(echo $POS)  # Number in digits
	local msg="$1"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${INFO}" "$msg"
}

function msg_quest_prompt() {
	local msg="$1"
	printf "%b ${msg}"" <y/N> " "${QUEST}";read -r -p "" prompt
}

function msg_lquest_prompt2() {
	local number="$1"  # Number in digits
	local msg="$2"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${QUEST}" "$msg <Y/N>"  ;read -r -p "" prompt
}

function msg_lquest5_prompt() {
	number=$(< <(echo $POS))
	#local number="$1"  # Number in digits
	local msg="$2 <y/N> "     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s" "$number" "${QUEST}" "$msg"  ;read -r -p "" prompt
}

function msg_lquest_prompt() {
	local number=$(< <(echo $POS))
	local msg="$1 <y/N> "     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s" "$number" "${QUEST}" "$msg"  ;read -r -p "" prompt
}

function msg_quest() {
	local msg="$1"
	printf "%b ${msg}\\n" "${QUEST}"
}
 
function msg_lquest() {
	#local number="$1"  # Number in digits
	local number=$(< <(echo $POS))
	local msg="$1"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${QUEST}" "$msg"
}

function msg_ok() {
	local msg="$1"
	printf "%b ${msg}\\n" "${TICK}"
}

function msg_lok() {
	local number=$(< <(echo $POS))
	#local number="$1"  # Number in digits
	local msg="$1"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${TICK}" "$msg"
}

function msg_no() {
	local msg="$1"
	printf "%b ${msg}\\n" "${CROSS}"
}

function msg_lno() {
	local number=$(< <(echo $POS))
	#local number="$1"  # Number in digits
	local msg="$1"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${CROSS}" "$msg"
}

function msg_warn() {
	local msg="$1"
	printf "%b ${msg}\\n" "${WARN}"
}

function msg_lwarn() {
	local number=$(< <(echo $POS))
	#local number="$1"  # Number in digits
	local msg="$1"     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s\n" "$number" "${WARN}" "$msg"
}

function msg_list() {
	local position="$1"
	local msg="$2"
	local INFO="${COL_NC}[i]  "   
	printf "%b ${msg}\\n" "\\t${COL_NC}[$position]  "
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

function header_info {
	echo -e "${COL_GREEN}
                              ____  ____  _____
                             / __ \/ __ \/ ___/
    「pascal's prep script」/ /_/ / /_/ (__  ) 
     ______________________/ .___/ .___/____/  
    /_______________________/   /_/       

	${COL_CL}"
}

function apt-helper {
        # Check if either command needs input and prompt the user
    	while [ -n "$(fuser /var/lib/dpkg/lock)" ]; do
        	msg_info "Waiting for another package manager to finish..."
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
}

function install_package() {
	if ! dpkg -s "$1" &>/dev/null; then
        	apt install -y "$1" &>/dev/null
	fi
}

function replace-prevline() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${CUU1}${EL}$1"
}

function replace-prevlineCR() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${CUU1}${EL}${CR}$1"
}

function replace-line() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${EL}$1"
}

function remove-prevline() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${CUU1}${EL}"
}

function remove-prevlineCR() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${CUU1}${EL}${CR}"
}

function remove-line() {
	CUU1=$(tput cuu1)    
	EL=$(tput el)       
	CR=$(tput cr) 
	echo -ne "${EL}"
}

pps_debug() {
	PPS_DEBUG_CODE=$((PPS_DEBUG_CODE + 1))
	printf "${TABSTOP}E%03d\n" "$PPS_DEBUG_CODE"
}

init_log() {
	ssh "$remote_user@$remote_host" "if [ ! -f $remote_path/$logfile ]; then printf "\\t$(hostname)\\t\\t$(hostname -I)" && echo "" && echo "" > $remote_path/$logfile; fi"
}

log() {
	local message="$1"
	echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" | ssh "$remote_user@$remote_host" "cat >> $logfile"
}

if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
fi

local_ip=$(get_ip)
local_mac=$(get_mac)
local_if=$(get_interface)




REVISION="B02"
VERSION="N06.${REVISION}"
function install_package() {
	if ! dpkg -s "$1" &>/dev/null; then
        	apt install -y "$1" &>/dev/null
	fi
}
apt update &>/dev/null
install_package curl
install_package wget
install_package unzip
install_package ncdu
install_package ripgrep
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-var.sh")
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-bash-func.sh")

header_info
export POS=0

msg_info "${ITALICS}${GREEN}Main PPS Version: ${DEFAULT}${BOLD}${YELLOW}$VERSION ${DEFAULT}"
msg_info "${ITALICS}${GREEN}PPS-vars Version: ${DEFAULT}${BOLD}${YELLOW}$VARVERSION ${DEFAULT}"
msg_info "${ITALICS}${GREEN}PPS-func Version: ${DEFAULT}${BOLD}${YELLOW}$FUNCVERSION ${DEFAULT}"
echo ""
msg_info "${BOLD}Hostname: ${DEFAULT}${ITALICS}$hostsys ${DEFAULT}"
msg_info "${BOLD}Virtual environment: ${DEFAULT}${ITALICS}$detected_env${DEFAULT}"
msg_info "${BOLD}Detected OS: ${DEFAULT}${ITALICS}$detected_os $detected_version${DEFAULT}"
msg_info "${BOLD}Detected architecture: ${DEFAULT}${ITALICS}${detected_architecture}${DEFAULT}"
msg_info "${BOLD}IP Address: ${DEFAULT}${ITALICS}${local_ip}${DEFAULT}"
msg_info "${BOLD}MAC Address: ${DEFAULT}${ITALICS}${local_mac}${DEFAULT}"
msg_info "${BOLD}Interface: ${DEFAULT}${ITALICS}${local_if}${DEFAULT}"
echo ""
msg_info "${BOLD}Timezone: ${DEFAULT}${ITALICS}$chktz${DEFAULT}"

if grep -q "Europe/Berlin" /etc/timezone ; then
	echo -n ""
else
	timedatectl set-timezone Europe/Berlin
	chktz=$(cat /etc/timezone)
	msg_ok "${BOLD}Timezone set to: ${DEFAULT}${ITALICS}$chktz${DEFAULT}"        
fi

apt update &>/dev/null
echo ""

if [[ "${EUID}" -ne 0 ]] ; then
	printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
	printf "%b Root privileges are needed for this script\\n" "${INFO}"
	printf "%b %bPlease re-run this script as root${DEFAULT}\\n" "${INFO}" "${COL_RED}"
	exit 1
fi
    
if [[ "${OSTYPE}" == "Darwin" || "${OSTYPE}" == "darwin" ]]; then
	msg_lno "Can't execute sript"
	msg_info "This script is for linux machines, not macOS machines"
	exit 1
fi

install_package dnsutils

WEBSITE_AVAILABLE=false
if curl --head --silent http://download.local &> /dev/null; then
	URL="http://download.local/"
else
        if curl --head --silent http://10.0.0.254 &> /dev/null; then
		URL="http://10.0.0.254/"
        fi
fi
#ssh-copy-id -i ~/.ssh/id_rsa.pub "$remote_user@$remote_host"
#init_log
#log "Test Log . Start"
#sleep 2
#log "Test Log . Ende"

((POS++))
msg_lquest_prompt "${BOLD}root login:${DEFAULT} set password?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
	if [[ $WEBSITE_AVAILABLE == false ]]; then
    		echo "Please enter a value for root password:"
    		read rootpw
	fi
	echo -e "${rootpw}\n${rootpw}" | passwd root &>/dev/null
	msg_lok "${BOLD}root login:${DEFAULT} changed"
else
	msg_linfo "${BOLD}root login:${DEFAULT} unchanged"
fi
echo ""

((POS++))
msg_lquest_prompt "${BOLD}sshd_config:${DEFAULT} permit root login?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
	sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
	sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
	sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
	msg_lok "${BOLD}sshd_config:${DEFAULT} root permitted"
	if [ "$detected_env" == "lxc" ]; then
        	sed -i '/^Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' /etc/ssh/sshd_config
	fi
else
	msg_linfo "${BOLD}sshd_config:${DEFAULT} unchanged"
fi
echo ""

((POS++))
if [ "$WEBSITE_AVAILABLE" = true ]; then
	msg_lquest_prompt "${BOLD}ssh:${DEFAULT} copy public keys?${DIMMED}"
	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
		if ! [[ -f "/root/.ssh/authorized_keys" ]] ; then
			mkdir /root/.ssh
		echo "" > /root/.ssh/authorized_keys
		fi
        chmod 700 /root/.ssh
        FILE_LIST=$(curl -s $URL)
        KEY_URLS=$(echo "$FILE_LIST" | grep -o '"[^"]*\.pub"' | sed 's/"//g')
        for KEY_URL in $KEY_URLS; do
        	KEY=$(curl -s "${URL}${KEY_URL}")
        	if ! grep -q -F "$KEY" ~/.ssh/authorized_keys; then
                	echo "$KEY" >> ~/.ssh/authorized_keys
                	msg_lok "${BOLD}ssh: ${DEFAULT}copied         ${GREEN}${BOLD}${ITALICS}${KEY_URL}${DEFAULT}"
            	else
        msg_linfo "${BOLD}ssh: ${DEFAULT}${DIMMED}already exists:     ${KEY_URL}${DEFAULT}"
        fi
        done
        	chmod 600 /root/.ssh/authorized_keys
	else    
        	msg_linfo "${BOLD}ssh:${DEFAULT} public keys not copied"
    	fi
fi
echo ""

((POS++))
msg_lquest_prompt "${BOLD}.bashrc:${DEFAULT} modify?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
	msg_lok "${BOLD}.bashrc:${DEFAULT} modified"
else
	msg_linfo "${BOLD}.bashrc:${DEFAULT} unchanged"
fi
        if ! grep -q "BASHVERSION=2" /root/.bashrc; then
            wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
        fi
echo ""

((POS++))
if [ ! -x "$(command -v pfetch)" ] ; then
	msg_lquest_prompt "${BOLD}pfetch:${DEFAULT} install?${DIMMED}"
	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        	msg_linfo "${BOLD}pfetch:${DEFAULT} installing"
        	wget -q https://github.com/dylanaraps/pfetch/archive/master.zip
        	apt install unzip &>/dev/null
        	unzip master.zip &>/dev/null
        	install pfetch-master/pfetch /usr/local/bin/ &>/dev/null
        	msg_lok "${BOLD}pfetch:${DEFAULT} installed"
        	if ! grep -q "clear" /root/.bashrc; then
        		echo " " >> /root/.bashrc
            		echo "clear" >> /root/.bashrc
        	fi
        	if ! grep -q "pfetch" /root/.bashrc; then
        		echo " " >> /root/.bashrc
        		echo "pfetch" >> /root/.bashrc
        	fi
    	else
        	msg_linfo  "${BOLD}pfetch:${DEFAULT} not installed"
	fi
else
	msg_lquest "${BOLD}pfetch:${DEFAULT} install?"
    	msg_lok "${BOLD}pfetch:${DEFAULT} already installed"
fi

if grep -q "neofetch" /root/.bashrc ; then
	sed -i "/neofetch/ s//#neofetch/g" /root/.bashrc
	msg_linfo "${BOLD}pfetch:${DEFAULT} removed neofetch from .bashrc"
fi

echo ""

((POS++))
if [ ! -x "$(command -v ack)" ] ; then
	msg_lquest_prompt "${BOLD}ack:${DEFAULT} install?${DIMMED}"
	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        	msg_linfo "${BOLD}ack:${DEFAULT} installing"
        	apt install ack -y &>/dev/null
        	apt-helper
        	msg_lok "${BOLD}ack:${DEFAULT} installed"
        else
        	msg_linfo "${BOLD}ack:${DEFAULT} not installed"
        fi
else
        msg_lquest "${BOLD}ack:${DEFAULT} install?"
        msg_lok "${BOLD}ack:${DEFAULT} already installed"
fi
echo ""

((POS++))
if [ ! -x "$(command -v mc)" ] ; then
	msg_lquest_prompt "${BOLD}Midnight Commander:${DEFAULT} install?${DIMMED}"
	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        	msg_linfo "${BOLD}Midnight Commander:${DEFAULT} installing"
        	apt install mc -y &>/dev/null
		msg_lok "${BOLD}Midnight Commander:${DEFAULT} installed"
	else
        	msg_linfo "${BOLD}Midnight Commander:${DEFAULT} not installed"
	fi
else
	msg_lquest "${BOLD}Midnight Commander:${DEFAULT} install?"
	msg_lok "${BOLD}Midnight Commander:${DEFAULT} already installed"
fi    
echo ""

((POS++))    
if [[ $detected_env == "kvm" ]]; then
	if [ ! -x "$(command -v qemu-ga)" ]; then
		msg_lquest_prompt "${BOLD}qemu-guest-agent:${DEFAULT} install?${DIMMED}"
        	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        		msg_linfo "${BOLD}qemu-guest-agent:${DEFAULT} installing"
        		apt install qemu-guest-agent -y &>/dev/null
        		msg_lok "${BOLD}qemu-guest-agent:${DEFAULT} installed"
        	else
        		msg_linfo "${BOLD}qemu-guest-agent:${DEFAULT} not installed"
        	fi
	else
        	msg_lquest "${BOLD}qemu-guest-agent:${DEFAULT} install?"
        	msg_lok "${BOLD}qemu-guest-agent:${DEFAULT} already installed"
	fi
else
	msg_lquest "${BOLD}qemu-guest-agent:${DEFAULT} install?"
	msg_linfo "${BOLD}qemu-guest-agent:${DEFAULT} not applicable"
fi
echo ""

((POS++))  
if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]; then
	if ! dpkg -s linux-virtual >/dev/null 2>&1; then
        	msg_lquest_prompt "${DIMMED}linux-virtual-packages:${DEFAULT} install?${DIMMED}"
        	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            		msg_linfo "${DIMMED}linux-virtual-packages:${DEFAULT} installing"
            		apt install --install-recommends linux-virtual -y &>/dev/null
            		apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
           		msg_lok "${DIMMED}linux-virtual-packages:${DEFAULT} installed"
        	else
           		msg_lno "${BOLD}linux-virtual-packages:${DEFAULT} not installed"
        	fi
    	else
        	msg_lquest "${BOLD}linux-virtual-packages:${DEFAULT} install?${DIMMED}"
        	msg_lok "${BOLD}linux-virtual-packages:${DEFAULT} already installed"
    	fi
else
	msg_lquest "${BOLD}linux-virtual-packages:${DEFAULT} install?${DIMMED}"
	msg_linfo "${BOLD}linux-virtual-packages:${DEFAULT} not applicable${DIMMED}"
fi
echo ""


((POS++))  
if [[ -f /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service && $detected_env == "kvm" && $detected_os == "ubuntu" && ($detected_version == "22.04" || $detected_version == "20.04") ]] ; then
	if grep -q "^After=systemd-remount-fs.service" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service ; then
        	msg_lquest "${BOLD}KVP daemon bug:${DEFAULT} apply workaround?${DIMMED}"
        	msg_lok "${BOLD}KVP daemon bug:${DEFAULT} workaround already applied"
    	else
        	msg_lquest_prompt "${BOLD}KVP daemon bug:${DEFAULT} apply workaround?${DIMMED}"
        	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        		msg_linfo "${BOLD}KVP daemon bug:${DEFAULT} applying workaround"
        		sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
        		systemctl daemon-reload
        		msg_lok "${BOLD}KVP daemon bug:${DEFAULT} workaround applied"
        	else
        		msg_linfo "${BOLD}KVP daemon bug:${DEFAULT} workaround not applied"
        	fi
	fi
else
	msg_lquest "${BOLD}KVP daemon bug:${DEFAULT} apply workaround?${DIMMED}"
	msg_linfo "${BOLD}KVP daemon bug:${DEFAULT} not applicable"
fi
echo ""

case "$detected_os-$detected_version" in
	debian-10)
        	deb_file=zabbix-release_7.0-1+debian10_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-11)
        	deb_file=zabbix-release_7.0-1+debian11_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-12)
        	deb_file=zabbix-release_7.0-1+debian12_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-20.04)
        	deb_file=zabbix-release_7.0-1+ubuntu20.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-22.04)
        	deb_file=zabbix-release_7.0-1+ubuntu22.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
	ubuntu-24.04)
        deb_file=zabbix-release_7.0-1+ubuntu24.04_all.deb
        deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
	*)
       		msg_lno "${BOLD}zabbix-agent:${DEFAULT} Unsupported OS version: $detected_os $detected_version"
        	#exit 1
        ;;
esac

if [ -f "$deb_file" ]; then
	sleep 1
else
	wget -q "$deb_url"
fi
dpkg -i "$deb_file" &>/dev/null

((POS++))  
msg_lquest_prompt "${BOLD}zabbix-agent:${DEFAULT} install?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	msg_linfo "${BOLD}zabbix-agent:${DEFAULT} installing"
        apt update &>/dev/null
	DEBIAN_FRONTEND=noninteractive apt-get install zabbix-agent -y #&>/dev/null
        #apt install zabbix-agent -y &>/dev/null
        #apt-helper
        msg_linfo "${BOLD}zabbix-agent:${DEFAULT} modify config"
        systemctl restart zabbix-agent &>/dev/null
        systemctl enable zabbix-agent &>/dev/null
        sed -i "/Server=127.0.0.1/ s//Server=10.255.255.10/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# StartAgents=3/ s//StartAgents=5/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.255.255.10:10051/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agentd.conf
        systemctl restart zabbix-agent &>/dev/null
        msg_linfo "${BOLD}zabbix-agent:${DEFAULT} config modified"
	msg_lok "${BOLD}zabbix-agent:${DEFAULT} installed"
else
        msg_linfo "${BOLD}zabbix-agent:${DEFAULT} not installed"
fi
echo ""

((POS++))  
msg_lquest_prompt "${BOLD}zabbix-agent2:${DEFAULT} install?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_linfo "${BOLD}zabbix-agent2:${DEFAULT} installing"
	apt update &>/dev/null
	DEBIAN_FRONTEND=noninteractive apt-get install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
	#apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
       	#apt-helper
	msg_linfo "${BOLD}zabbix-agent2:${DEFAULT} modify config"
        systemctl restart zabbix-agent2 &>/dev/null
        systemctl enable zabbix-agent2  &>/dev/null
        sed -i "/Server=127.0.0.1/ s//Server=10.255.255.10/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.255.255.10:10051/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agent2.conf
        msg_linfo "${BOLD}zabbix-agent2:${DEFAULT} config modified"
        systemctl restart zabbix-agent2 &>/dev/null
	msg_ok "${BOLD}zabbix-agent2:${DEFAULT} installed"
else            
        msg_linfo "${BOLD}zabbix-agent2:${DEFAULT} not installed"
fi       
echo ""

((POS++))  
msg_lquest_prompt "${BOLD}$hostsys:${DEFAULT} install updates?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	msg_linfo "${BOLD}$hostsys:${DEFAULT} installing updates"
	apt-get update &>/dev/null
	DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confold" upgrade -y &>/dev/null
	#apt-get -y upgrade &>/dev/null
	#apt-helper
	msg_lok "${BOLD}$hostsys:${DEFAULT} updates installed"
else
	msg_linfo "${BOLD}$hostsys:${DEFAULT} no updates installed"
fi
echo ""

((POS++))  
msg_lquest_prompt "${BOLD}$hostsys:${DEFAULT} install dist-upgrades?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	msg_linfo "${BOLD}$hostsys:${DEFAULT} installing dist-upgrades"
	apt-get update &>/dev/null
	DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -y &>/dev/null
	#apt-get -y dist-upgrade &>/dev/null
	#apt-helper
	msg_lok "${BOLD}$hostsys:${DEFAULT} dist-upgrades installed"
else
	msg_linfo "${BOLD}$hostsys:${DEFAULT} no updates installed"
fi
echo ""

((POS++))  
msg_lquest_prompt "${BOLD}$hostsys:${DEFAULT} reboot now?${DIMMED}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	msg_linfo "${BOLD}$hostsys:${DEFAULT} rebooting"
	sleep 1
	msg_lok "Completed post-installation routines"
	sleep 1
	if [ "$WEBSITE_AVAILABLE" = false ]; then
		echo ""
   		msg_lno "${BOLD}public keys:${DEFAULT} not copied"
	fi
	sleep 1
    	reboot
else
	msg_linfo "${BOLD}$hostsys:${DEFAULT} not rebooted"
fi


if [ "$WEBSITE_AVAILABLE" = false ]; then
	echo ""
	msg_lno "${BOLD}public keys:${DEFAULT} not copied"
fi
sleep 1

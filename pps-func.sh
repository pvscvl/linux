#!/usr/bin/env bash
FUNCREVISION="04"
FUNCVERSION="F8.${FUNCREVISION}"
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


function msg_lquest_promptzsh() {
	local number=$(< <(echo $POS))
	local msg="$1 <y/N> "     # Message text
	printf "${COL_DIM} [%02d/15]${COL_NC}\\t %b %s" "$number" "${QUEST}" "$msg" ""
}
read REPLY\?


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

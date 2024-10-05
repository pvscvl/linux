#!/usr/bin/env bash

<<'###SCRIPT-EXECUTION###'


bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/ths-bash.sh)"


###SCRIPT-EXECUTION###


#### Variables ####
	DEFAULT=$(tput sgr0)
	BOLD=$(tput bold)
	ITALICS=$(tput sitm)
	DIMMED=$(tput dim)
	OVER="\\r\\033[K"
	GREY=$(tput setaf 7)
	PURPLE=$(tput setaf 5)
	YELLOW=$(tput setaf 3)
	CYAN=$(tput setaf 6)
	BLUE=$(tput setaf 4)
	ORANGE=$(tput setaf 202)
	GREEN=$(tput setaf 2)
	RED=$(tput setaf 1)

	CROSS="${DEFAULT}[${BOLD}${RED}✗${DEFAULT}]  "
	INFO="${DEFAULT}${BOLD}[i]${DEFAULT}  "   
	TICK="${DEFAULT}${BOLD}[${GREEN}✓${DEFAULT}]  "
	WARN="${DEFAULT}[${BOLD}${ORANGE}!${DEFAULT}]  "

#### Functions ####
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
	
	function msg_warn() {
		local msg="$1"
		printf "%b ${msg}\\n" "${WARN}"
	}

#### Script ####
	## Check for root privileges
		if [[ "${EUID}" -ne 0 ]] ; then
			printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
			printf "%b Root privileges are needed for this script\\n" "${INFO}"
			printf "%b %bPlease re-run this script as root${DEFAULT}\\n" "${INFO}" "${RED}"
			exit 1
		fi

	## Check for Timezone
		if grep -q "Europe/Berlin" /etc/timezone ; then
			echo -n ""
		else
			timedatectl set-timezone Europe/Berlin
			CHECKEDTZ=$(cat /etc/timezone)
			msg_ok "${BOLD}Timezone set to: ${DEFAULT}${ITALICS}$CHECKEDTZ${DEFAULT}"        
		fi

		
apt update &>/dev/null

	if ! command -v fzf &> /dev/null; then
		apt install -y fzf
	fi

	if ! command -v iperf &> /dev/null; then
		apt install -y iperf
	fi


	if ! command -v iperf3 &> /dev/null; then
		apt install -y iperf3
	fi


	if ! command -v wget &> /dev/null; then
		apt install -y wget
	fi

 
	if ! command -v curl &> /dev/null; then
		apt install -y curl
	fi

 
	if ! command -v unzip &> /dev/null; then
		apt install -y unzip
	fi

 
	if ! command -v ncdu &> /dev/null; then
		apt install -y ncdu
	fi

 
	if ! command -v ripgrep &> /dev/null; then
		apt install -y ripgrep
	fi

 
	if ! command -v htop &> /dev/null; then
		apt install -y htop
	fi

 
	if ! command -v atop &> /dev/null; then
		apt install -y atop
	fi

 
	if ! command -v ack &> /dev/null; then
		apt install -y ack
	fi

 
	if ! command -v mc &> /dev/null; then
		apt install -y mc
	fi

 
	if ! command -v netstat &> /dev/null; then
		apt install -y net-tools 
	fi



cp /root/.bashrc /root/.bashrc.bak
msg_info "${BOLD}.bashrc:${DEFAULT}${ITALICS}.bashrc backup created.${DEFAULT}"        

wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrcths
msg_ok "${BOLD}.bashrc:${DEFAULT}${ITALICS}.bashrc updated.${DEFAULT}"        

sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
sed -i '/^Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' /etc/ssh/sshd_config



	if ! command -v pfetch &> /dev/null; then
		mkdir /root/pfetch 
		cd /root/pfetch
		wget https://github.com/dylanaraps/pfetch/archive/master.zip
		unzip master.zip
		install pfetch-master/pfetch /usr/local/bin/ 		
  		rm -r /root/pfetch
	fi

	

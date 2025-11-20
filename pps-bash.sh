#!/usr/bin/env bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/pps-bash.sh)"
VYEAR="2025"
BUILD="7"
MAYORVERSION="0."

VERSION="${VYEAR}.$(printf "%03d" ${BUILD})"
#	VERSION="${MAYORBERSION}${VYEAR}.$(printf "%03d" ${BUILD})"

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
install_package net-tools

source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-var.sh")
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-bash-func.sh")

header_info
export POS=0

msg_info "${ITALICS}${GREEN}Main PPS Version: ${DEFAULT}${BOLD}${YELLOW}$VERSION ${DEFAULT}"
# msg_info "${ITALICS}${GREEN}PPS-vars Version: ${DEFAULT}${BOLD}${YELLOW}$VARVERSION ${DEFAULT}"
# msg_info "${ITALICS}${GREEN}PPS-func Version: ${DEFAULT}${BOLD}${YELLOW}$FUNCVERSION ${DEFAULT}"
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
# if curl --head --silent http://download.local &> /dev/null; then
if curl --head --silent --fail --output /dev/null --write-out "%{http_code}" http://download.local/sshkeys/ | grep -q "^200$"; then
	# URL="http://download.local/"
	URL="http://download.local/sshkeys/"
	WEBSITE_AVAILABLE=true
else
        # if curl --head --silent http://10.0.0.254 &> /dev/null; then
	 if curl --head --silent --fail --output /dev/null --write-out "%{http_code}" http://10.0.0.254/sshkeys/ | grep -q "^200$"; then
		# URL="http://10.0.0.254/"
		URL="http://10.0.0.254/sshkeys/"
		WEBSITE_AVAILABLE=true
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
#	msg_lquest_prompt "${BOLD}.bashrc:${DEFAULT} modify?${DIMMED}"
#	if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
#		wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
#		msg_lok "${BOLD}.bashrc:${DEFAULT} modified"
#	else
#		msg_linfo "${BOLD}.bashrc:${DEFAULT} unchanged"
#	fi
#       if ! grep -q "BASHVERSION=2" /root/.bashrc; then
#		wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
#		fi
#	echo ""
msg_lquest_prompt "${BOLD}.bashrc:${DEFAULT} modify?${DIMMED}"
if [[ ${prompt} =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
	BASHRC_PATH="/root/.bashrc"
	TIMESTAMP=$(date +"%Y%m%d-%H%M")
	BACKUP_PATH="${BASHRC_PATH}_${TIMESTAMP}"
	
	cp ${BASHRC_PATH} ${BACKUP_PATH}
	
	PS1_LINE='export PS1="\[\e]0;\u@\H: \w\a\]\t ${debian_chroot:+($debian_chroot)}\033[00m\]\u\[\033[01;30m\]@\[\033[01;32m\]\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "'
	LS_COLORS_LINE='export LS_COLORS="no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"'
	LSCOLORS_LINE='export LSCOLORS="BxBxhxDxfxhxhxhxhxcxcx"'
	COLORFLAG_LINE='export colorflag="-G"'
	ALIAS_LINES='
alias ..="cd .."
alias ....="cd ../.."
alias _ls="ls -alhFXp --color=always --group-directories-first" 
alias ll="ls -alhFXp --color=always --group-directories-first" 
alias show-ports="netstat -tulpn"
alias show-ports="netstat -tulpn"
'
	ALIAS_FUNCTIONS='
function show-ports {
	ARGS="-tulp"
	RESOLVED=false

	for ARG in "$@"; do
		case ${ARG} in
			-r|--resolved|--dns|--dnsname)
				RESOLVED=true
				;;
			--extended|-e)
				ARGS="${ARGS}e"
				;;
			--all|-a)
				ARGS="${ARGS}a"
				;;
		esac
	done

	if ${RESOLVED}; then
		ARGS="${ARGS}N"
	else
		ARGS="${ARGS}n"
	fi

	netstat ${ARGS}
}
 '
	APPEND=false

	if ! grep -Fxq "${PS1_LINE}" ${BASHRC_PATH}; then
		echo "${PS1_LINE}" >> ${BASHRC_PATH}
		APPEND=true
	fi
	if ! grep -Fxq "${LS_COLORS_LINE}" ${BASHRC_PATH}; then
		echo "${LS_COLORS_LINE}" >> ${BASHRC_PATH}
		APPEND=true
	fi
	if ! grep -Fxq "${LSCOLORS_LINE}" ${BASHRC_PATH}; then
		echo "${LSCOLORS_LINE}" >> ${BASHRC_PATH}
		APPEND=true
	fi
	if ! grep -Fxq "${COLORFLAG_LINE}" ${BASHRC_PATH}; then
		echo "${COLORFLAG_LINE}" >> ${BASHRC_PATH}
		APPEND=true
	fi
	if ! grep -Fqx "alias ..=\"cd ..\"" ${BASHRC_PATH}; then
		echo "${ALIAS_LINES}" >> ${BASHRC_PATH}
		APPEND=true
	fi
 	if ! grep -Fqx "function show-ports" ${BASHRC_PATH}; then
		echo "${ALIAS_FUNCTIONS}" >> ${BASHRC_PATH}
		APPEND=true
	fi

	if ${APPEND}; then
		msg_lok "${BOLD}.bashrc:${DEFAULT} modified"
	else
		msg_linfo "${BOLD}.bashrc:${DEFAULT} already contains the necessary lines"
	fi
else
	msg_linfo "${BOLD}.bashrc:${DEFAULT} unchanged"
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
        	deb_file=zabbix-release_latest_7.4+debian10_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-11)
        	deb_file=zabbix-release_latest_7.4+debian11_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-12)
        	deb_file=zabbix-release_latest_7.4+debian12_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/$deb_file
        ;;
	debian-13)
		deb_file=zabbix-release_latest_7.4+debian13_all.deb
		deb_url=https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/$deb_file
	;;
    	ubuntu-20.04)
        	deb_file=zabbix-release_latest_7.2+ubuntu20.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-22.04)
        	deb_file=zabbix-release_latest_7.2+ubuntu22.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
	ubuntu-24.04)
 		deb_file=zabbix-release_latest_7.2+ubuntu24.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/$deb_file
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

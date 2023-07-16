#!/usr/bin/env bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/pps.sh)"
REVISION=08
VERSION="M7.${REVISION}"
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-var.sh")
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pps-func.sh")
header_info
export POS=0
msg_linfo "${COL_ITAL}${COL_GREEN}Main PPS Version: ${COL_NC}${COL_BOLD}${COL_YELLOW}$VERSION ${COL_NC}"
msg_linfo "${COL_ITAL}${COL_GREEN}PPS-vars Version: ${COL_NC}${COL_BOLD}${COL_YELLOW}$VARVERSION ${COL_NC}"
msg_linfo "${COL_ITAL}${COL_GREEN}PPS-func Version: ${COL_NC}${COL_BOLD}${COL_YELLOW}$FUNCVERSION ${COL_NC}"echo ""
echo ""

msg_linfo "${COL_BOLD}Hostname: ${COL_NC}${COL_ITAL}$hostsys ${COL_NC}"
msg_linfo "${COL_BOLD}Virtual environment: ${COL_NC}${COL_ITAL}$detected_env${COL_NC}"
msg_linfo "${COL_BOLD}Detected OS: ${COL_NC}${COL_ITAL}$detected_os $detected_version${COL_NC}"
msg_linfo "${COL_BOLD}Detected architecture: ${COL_NC}${COL_ITAL}${detected_architecture}${COL_NC}"
msg_linfo "${COL_BOLD}IP Address: ${COL_NC}${COL_ITAL}${local_ip}${COL_NC}"
msg_linfo "${COL_BOLD}MAC Address: ${COL_NC}${COL_ITAL}${local_mac}${COL_NC}"
msg_linfo "${COL_BOLD}Interface: ${COL_NC}${COL_ITAL}${local_if}${COL_NC}"
echo ""
msg_linfo "${COL_BOLD}Timezone: ${COL_NC}${COL_ITAL}$chktz${COL_NC}"
if  grep -q "Europe/Berlin" /etc/timezone ; then
    echo -n ""
else
    timedatectl set-timezone Europe/Berlin
    chktz=$(cat /etc/timezone)
    msg_lok "${COL_BOLD}Timezone set to: ${COL_NC}${COL_ITAL}$chktz${COL_NC}"        
    fi

apt update &>/dev/null
echo ""
if [[ "${EUID}" -ne 0 ]] ; then
    printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
    printf "%b Root privileges are needed for this script\\n" "${INFO}"
    printf "%b %bPlease re-run this script as root${COL_NC}\\n" "${INFO}" "${COL_RED}"
    exit 1
fi
    
if [[ "${OSTYPE}" == "Darwin" || "${OSTYPE}" == "darwin" ]]; then
   msg_lno "Can't execute sript"
    msg_info "This script is for linux machines, not macOS machines"
    exit 1
fi
install_package curl
install_package wget
install_package dnsutils

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
ssh-copy-id -i ~/.ssh/id_rsa.pub "$remote_user@$remote_host"
init_log
log "Test Log . Start"
sleep 2
log "Test Log . Ende"
((POS++))
msg_lquest_prompt "${COL_BOLD}root login:${COL_NC} set password?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
	if [[ $WEBSITE_AVAILABLE == false ]]; then
    		echo "Please enter a value for root password:"
    		read rootpw
	fi
    echo -e "${rootpw}\n${rootpw}" | passwd root &>/dev/null
    msg_lok "${COL_BOLD}root login:${COL_NC} changed"
else
    msg_linfo "${COL_BOLD}root login:${COL_NC} unchanged"
fi
echo ""

((POS++))
msg_lquest_prompt "${COL_BOLD}sshd_config:${COL_NC} permit root login?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
    sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
    sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
    sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
    msg_lok "${COL_BOLD}sshd_config:${COL_NC} root permitted"
    if [ "$detected_env" == "lxc" ]; then
        sed -i '/^Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' /etc/ssh/sshd_config
    fi
else
    msg_linfo "${COL_BOLD}sshd_config:${COL_NC} unchanged"
fi

echo ""
((POS++))
if [ "$WEBSITE_AVAILABLE" = true ]; then
    msg_lquest_prompt "${COL_BOLD}ssh:${COL_NC} copy public keys?${COL_DIM}"
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
                msg_lok "${COL_BOLD}ssh: ${COL_NC}copied         ${COL_GREEN}${COL_BOLD}${COL_ITAL}${KEY_URL}${COL_NC}"
            else
                msg_linfo "${COL_BOLD}ssh: ${COL_NC}${COL_DIM}already exists:     ${KEY_URL}${COL_NC}"
            fi
        done
        chmod 600 /root/.ssh/authorized_keys
    else    
        msg_linfo "${COL_BOLD}ssh:${COL_NC} public keys not copied"
    fi
fi
echo ""
((POS++))
msg_lquest_prompt "${COL_BOLD}.bashrc:${COL_NC} modify?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
    msg_lok "${COL_BOLD}.bashrc:${COL_NC} modified"
else
    msg_linfo "${COL_BOLD}.bashrc:${COL_NC} unchanged"
fi
        if ! grep -q "BASHVERSION=2" /root/.bashrc; then
            wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
        fi
	
echo ""
sleep 1
((POS++))
if [ ! -x "$(command -v pfetch)" ] ; then
    msg_lquest_prompt "${COL_BOLD}pfetch:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        msg_linfo "${COL_BOLD}pfetch:${COL_NC} installing"
        wget -q https://github.com/dylanaraps/pfetch/archive/master.zip
        apt install unzip &>/dev/null
        unzip master.zip &>/dev/null
        install pfetch-master/pfetch /usr/local/bin/ &>/dev/null
        msg_lok "${COL_BOLD}pfetch:${COL_NC} installed"
        if ! grep -q "clear" /root/.bashrc; then
            echo " " >> /root/.bashrc
            echo "clear" >> /root/.bashrc
        fi
        if ! grep -q "pfetch" /root/.bashrc; then
            echo " " >> /root/.bashrc
            echo "pfetch" >> /root/.bashrc
        fi
    else
        msg_linfo  "${COL_BOLD}pfetch:${COL_NC} not installed"
    fi
else
    msg_lquest "${COL_BOLD}pfetch:${COL_NC} install?"
    	msg_lok "${COL_BOLD}pfetch:${COL_NC} already installed"
fi
if  grep -q "neofetch" /root/.bashrc ; then
    sed -i "/neofetch/ s//#neofetch/g" /root/.bashrc
      msg_linfo "${COL_BOLD}pfetch:${COL_NC} removed neofetch from .bashrc"
fi

echo ""
sleep 1
((POS++))
if [ ! -x "$(command -v ack)" ] ; then
    msg_lquest_prompt "${COL_BOLD}ack:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_linfo "${COL_BOLD}ack:${COL_NC} installing"
            apt install ack -y &>/dev/null
            apt-helper
           msg_lok "${COL_BOLD}ack:${COL_NC} installed"
        else
            msg_linfo "${COL_BOLD}ack:${COL_NC} not installed"
        fi
else
        msg_lquest "${COL_BOLD}ack:${COL_NC} install?"
        msg_lok "${COL_BOLD}ack:${COL_NC} already installed"
fi
echo ""

sleep 1
((POS++))
if [ ! -x "$(command -v mc)" ] ; then
    msg_lquest_prompt "${COL_BOLD}Midnight Commander:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_linfo "${COL_BOLD}Midnight Commander:${COL_NC} installing"
        apt install mc -y &>/dev/null
       msg_lok "${COL_BOLD}Midnight Commander:${COL_NC} installed"
    else
        msg_linfo "${COL_BOLD}Midnight Commander:${COL_NC} not installed"
    fi
else
    msg_lquest "${COL_BOLD}Midnight Commander:${COL_NC} install?"
    msg_lok "${COL_BOLD}Midnight Commander:${COL_NC} already installed"

fi    
echo ""
sleep 1
((POS++))    
if [[ $detected_env == "kvm" ]]; then
    if [ ! -x "$(command -v qemu-ga)" ]; then
        msg_lquest_prompt "${COL_BOLD}qemu-guest-agent:${COL_NC} install?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            msg_linfo "${COL_BOLD}qemu-guest-agent:${COL_NC} installing"
            apt install qemu-guest-agent -y &>/dev/null
            msg_lok "${COL_BOLD}qemu-guest-agent:${COL_NC} installed"
        else
            msg_linfo "${COL_BOLD}qemu-guest-agent:${COL_NC} not installed"
        fi
    else
        msg_lquest "${COL_BOLD}qemu-guest-agent:${COL_NC} install?"
        msg_lok "${COL_BOLD}qemu-guest-agent:${COL_NC} already installed"
    fi
else
    msg_lquest "${COL_BOLD}qemu-guest-agent:${COL_NC} install?"
    msg_linfo "${COL_BOLD}qemu-guest-agent:${COL_NC} not applicable"
fi
echo ""

sleep 1
((POS++))  
if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]; then
    if ! dpkg -s linux-virtual >/dev/null 2>&1; then
        msg_lquest_prompt "${COL_DIM}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            msg_linfo "${COL_DIM}linux-virtual-packages:${COL_NC} installing"
            apt install --install-recommends linux-virtual -y &>/dev/null
            apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
           msg_lok "${COL_DIM}linux-virtual-packages:${COL_NC} installed"
        else
           msg_lno "${COL_BOLD}linux-virtual-packages:${COL_NC} not installed"
        fi
    else
        msg_lquest "${COL_BOLD}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
        msg_lok "${COL_BOLD}linux-virtual-packages:${COL_NC} already installed"
    fi
else
    msg_lquest "${COL_BOLD}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
    msg_linfo "${COL_BOLD}linux-virtual-packages:${COL_NC} not applicable${COL_DIM}"
fi

echo ""
sleep 1
((POS++))  
if [[ -f /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service && $detected_env == "kvm" && $detected_os == "ubuntu" && ($detected_version == "22.04" || $detected_version == "20.04") ]] ; then
    if grep -q "^After=systemd-remount-fs.service" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service ; then
        msg_lquest "${COL_BOLD}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
        msg_lok "${COL_BOLD}KVP daemon bug:${COL_NC} workaround already applied"
    else
        msg_lquest_prompt "${COL_BOLD}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            msg_linfo "${COL_BOLD}KVP daemon bug:${COL_NC} applying workaround"
            sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
            systemctl daemon-reload
           msg_lok "${COL_BOLD}KVP daemon bug:${COL_NC} workaround applied"
        else
            msg_linfo "${COL_BOLD}KVP daemon bug:${COL_NC} workaround not applied"
        fi
    fi
    else
    msg_lquest "${COL_BOLD}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
    msg_linfo "${COL_BOLD}KVP daemon bug:${COL_NC} not applicable"
fi
echo ""

case "$detected_os-$detected_version" in
    debian-10)
        deb_file=zabbix-release_6.5-1+debian10_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.5/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    debian-11)
        deb_file=zabbix-release_6.5-1+debian11_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.5/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    debian-12)
        deb_file=zabbix-release_6.5-1+debian12_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.5/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    ubuntu-20.04)
        deb_file=zabbix-release_6.5-1+ubuntu20.04_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.5/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    ubuntu-22.04)
        deb_file=zabbix-release_6.5-1+ubuntu22.04_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.5/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    *)
       msg_lno "${COL_BOLD}zabbix-agent:${COL_NC} Unsupported OS version: $detected_os $detected_version"
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
    msg_lquest_prompt "${COL_BOLD}zabbix-agent:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_linfo "${COL_BOLD}zabbix-agent:${COL_NC} installing"
        apt update &>/dev/null
        apt install zabbix-agent -y &>/dev/null
        apt-helper
        msg_linfo "${COL_BOLD}zabbix-agent:${COL_NC} modify config"
        systemctl restart zabbix-agent &>/dev/null
        systemctl enable zabbix-agent &>/dev/null
        sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# StartAgents=3/ s//StartAgents=5/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agentd.conf
        sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agentd.conf
        systemctl restart zabbix-agent &>/dev/null
        msg_linfo "${COL_BOLD}zabbix-agent:${COL_NC} config modified"
       msg_lok "${COL_BOLD}zabbix-agent:${COL_NC} installed"
    else
        msg_linfo "${COL_BOLD}zabbix-agent:${COL_NC} not installed"
    fi
echo ""
((POS++))  
    msg_lquest_prompt "${COL_BOLD}zabbix-agent2:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_linfo "${COL_BOLD}zabbix-agent2:${COL_NC} installing"
        apt update &>/dev/null
		apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
        apt-helper
        msg_linfo "${COL_BOLD}zabbix-agent2:${COL_NC} modify config"
        systemctl restart zabbix-agent2 &>/dev/null
        systemctl enable zabbix-agent2  &>/dev/null
        sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agent2.conf
        msg_linfo "${COL_BOLD}zabbix-agent2:${COL_NC} config modified"
        systemctl restart zabbix-agent2 &>/dev/null
		msg_ok "${COL_BOLD}zabbix-agent2:${COL_NC} installed"
    else            
        msg_linfo "${COL_BOLD}zabbix-agent2:${COL_NC} not installed"
    fi
       
echo ""
sleep 1
((POS++))  
msg_lquest_prompt "${COL_BOLD}$hostsys:${COL_NC} install updates?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} installing updates"
    apt-get update &>/dev/null
    apt-get -y upgrade &>/dev/null
    apt-helper
   msg_lok "${COL_BOLD}$hostsys:${COL_NC} updates installed"
else
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} no updates installed"
fi
echo ""
sleep 1
((POS++))  
msg_lquest_prompt "${COL_BOLD}$hostsys:${COL_NC} install dist-upgrades?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} installing dist-upgrades"
    apt-get update &>/dev/null
    apt-get -y dist-upgrade &>/dev/null
    apt-helper
   msg_lok "${COL_BOLD}$hostsys:${COL_NC} dist-upgrades installed"
else
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} no updates installed"
fi

echo ""
sleep 1 
((POS++))  
msg_lquest_prompt "${COL_BOLD}$hostsys:${COL_NC} reboot now?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} rebooting"
    sleep 1
   msg_lok "Completed post-installation routines"
    sleep 1
if [ "$WEBSITE_AVAILABLE" = false ]; then
    echo ""
   msg_lno "${COL_BOLD}public keys:${COL_NC} not copied"
fi
sleep 2
    reboot
else
    msg_linfo "${COL_BOLD}$hostsys:${COL_NC} not rebooted"
fi


if [ "$WEBSITE_AVAILABLE" = false ]; then
    echo ""
   msg_lno "${COL_BOLD}public keys:${COL_NC} not copied"
fi
sleep 2

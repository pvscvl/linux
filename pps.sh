#!/usr/bin/env bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/pps.sh)"
REVISION=14
VERSION="v3.2.${REVISION}"
source <(curl  -sSL "https://raw.githubusercontent.com/pvscvl/linux/main/pre-pps.sh")
header_info
msg_info "${COL_ITAL}${COL_GREEN}Script Version:\\t\\t${COL_NC}${COL_BOLD}${COL_YELLOW}$VERSION ${COL_NC}"
echo ""
echo ""
msg_info "${COL_DIM}Hostname: ${COL_NC}${COL_BOLD}$hostsys ${COL_NC}"
msg_info "${COL_DIM}Virtual environment: ${COL_NC}${COL_BOLD}$detected_env${COL_NC}"
echo ""
msg_info "${COL_DIM}Detected OS: ${COL_NC}${COL_BOLD}$detected_os $detected_version${COL_NC}"
msg_info "${COL_DIM}Detected architecture: ${COL_NC}${COL_BOLD}${detected_architecture}${COL_NC}"
echo ""
msg_info "${COL_DIM}Timezone: ${COL_NC}${COL_BOLD}$chktz${COL_NC}"
if  grep -q "Europe/Berlin" /etc/timezone ; then
    echo -n ""
else
    timedatectl set-timezone Europe/Berlin
    chktz=`cat /etc/timezone`
    msg_ok "${COL_DIM}Timezone set to: ${COL_NC}${COL_BOLD}$chktz${COL_NC}"        
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
    msg_no "Can't execute sript"
    msg_info "This script is for linux machines, not macOS machines"
    exit 1
fi

msg_quest_prompt "${COL_DIM}.bashrc:${COL_NC} modify?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
    msg_ok "${COL_DIM}.bashrc:${COL_NC} modified"
    echo ""
else
    msg_info "${COL_DIM}.bashrc:${COL_NC} unchanged"
    echo ""
fi

if [ ! -x "$(command -v pfetch)" ] ; then
    msg_quest_prompt "${COL_DIM}pfetch:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        msg_info "${COL_DIM}pfetch:${COL_NC} installing"
        wget -q https://github.com/dylanaraps/pfetch/archive/master.zip
        apt install unzip &>/dev/null
        unzip master.zip &>/dev/null
        install pfetch-master/pfetch /usr/local/bin/ &>/dev/null
        msg_ok "${COL_DIM}pfetch:${COL_NC} installed"
        echo ""
        if ! grep -q "clear" /root/.bashrc; then
            echo " " >> /root/.bashrc
            echo "clear" >> /root/.bashrc
        fi

        if ! grep -q "pfetch" /root/.bashrc; then
            echo " " >> /root/.bashrc
            echo "pfetch" >> /root/.bashrc
        fi

    else
        msg_no "${COL_DIM}pfetch:${COL_NC} not installed"
        echo ""
    fi
else
    msg_quest "${COL_DIM}pfetch:${COL_NC} install?"
    msg_info "${COL_DIM}pfetch:${COL_NC} already installed"
    echo ""
fi

if  grep -q "neofetch" /root/.bashrc ; then
    sed -i "/neofetch/ s//#neofetch/g" /root/.bashrc
    msg_info "${COL_DIM}pfetch:${COL_NC} Removed neofetch from .bashrc"
fi

if [ ! -x "$(command -v ack)" ] ; then
    msg_quest_prompt "${COL_DIM}ack:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_info "${COL_DIM}ack:${COL_NC} installing"
            #apt update &>/dev/null
            apt install ack -y &>/dev/null
            apt-helper
            msg_ok "${COL_DIM}ack:${COL_NC} installed"
            echo ""
        else
            msg_info "${COL_DIM}ack:${COL_NC} not installed"
            echo ""
        fi
else
        msg_quest "${COL_DIM}ack:${COL_NC} install?"
        msg_info "${COL_DIM}ack:${COL_NC} already installed"
        echo ""
fi

if [ ! -x "$(command -v mc)" ] ; then
    msg_quest_prompt "${COL_DIM}Midnight Commander:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_info "${COL_DIM}Midnight Commander:${COL_NC} installing"
    #apt update &>/dev/null
        apt install mc -y &>/dev/null
        msg_ok "${COL_DIM}Midnight Commander:${COL_NC} installed"
        echo ""
    else
        msg_info "${COL_DIM}Midnight Commander:${COL_NC} not installed"
        echo ""
    fi
else
    msg_quest "${COL_DIM}Midnight Commander:${COL_NC} install?"
    msg_info "${COL_DIM}Midnight Commander:${COL_NC} already installed"
    echo ""
fi    
    
if [ ! -x "$(command -v qemu-ga)" ] ; then
    if [[ $detected_env == "kvm" ]] ; then
        msg_quest_prompt "${COL_DIM}qemu-guest-agent:${COL_NC} install?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
            msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} installing"
            apt install qemu-guest-agent -y &>/dev/null
            msg_ok "${COL_DIM}qemu-guest-agent:${COL_NC} installed"
            echo ""
        else
            msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} not installed"
            echo ""
        fi
    fi
else
    msg_quest "${COL_DIM}qemu-guest-agent:${COL_NC} install?"
    msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} already installed"
    echo ""
fi

if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]; then
    if ! dpkg -s linux-virtual >/dev/null 2>&1; then
        msg_quest_prompt "${COL_DIM}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            msg_info "${COL_DIM}linux-virtual-packages:${COL_NC} installing"
            apt install --install-recommends linux-virtual -y &>/dev/null
            apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
            msg_ok "${COL_DIM}linux-virtual-packages:${COL_NC} installed"
            echo ""
        else
            msg_no "${COL_DIM}linux-virtual-packages:${COL_NC} not installed"
            echo ""
        fi
    else
        msg_quest "${COL_DIM}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
        msg_info "${COL_DIM}linux-virtual-packages:${COL_NC} already installed"
        echo ""
    fi
fi

if [[ -f /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service && $detected_env == "kvm" && $detected_os == "ubuntu" && ($detected_version == "22.04" || $detected_version == "20.04") ]] ; then
    if grep -q "^After=systemd-remount-fs.service" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service ; then
        msg_quest "${COL_DIM}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
        msg_info "${COL_DIM}KVP daemon bug:${COL_NC} workaround already applied"
        echo ""
    else
        msg_quest_prompt "${COL_DIM}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
        if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
            msg_info "${COL_DIM}KVP daemon bug:${COL_NC} applying workaround"
            sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
            systemctl daemon-reload
            msg_ok "${COL_DIM}KVP daemon bug:${COL_NC} workaround applied"
            echo ""
        else
            msg_info "${COL_DIM}KVP daemon bug:${COL_NC} workaround not applied"
            echo ""
        fi
    fi
fi

msg_quest_prompt "${COL_DIM}root login:${COL_NC} set password?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
    echo -e "7fd32tmas96\n7fd32tmas96" | passwd root &>/dev/null
    msg_ok "${COL_DIM}root login:${COL_NC} password set"
    echo ""
else
    msg_info "${COL_DIM}root login:${COL_NC} unchanged"
    echo ""
fi

msg_quest_prompt "${COL_DIM}sshd_config:${COL_NC} permit root login via SSH?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
    sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
    sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
    sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
    msg_ok "${COL_DIM}sshd_config:${COL_NC} root login via SSH permitted"
    echo ""
    if [ "$detected_env" == "lxc" ]; then
        #cp /etc/ssh/sshd_config /root/sshd_config.bckup
        #sed -i 's/^Subsystem    sftp    \/usr\/lib\/openssh\/sftp-server$/#&/' /etc/ssh/sshd_config
        sed -i '/^Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' /etc/ssh/sshd_config
        #msg_info "${COL_DIM}sshd_config:${COL_NC} changed sftp subsystem to internal"
        echo ""
    fi
else
    msg_info "${COL_DIM}sshd_config:${COL_NC} root login via SSH unchanged"
    echo ""
fi

if [ "$WEBSITE_AVAILABLE" = true ]; then
    msg_quest_prompt "${COL_DIM}ssh:${COL_NC} copy public keys for root login?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]]; then
        if ! [[ -d "/root/.ssh" ]] ; then
            mkdir /root/.ssh
        fi
        chmod 700 /root/.ssh
        FILE_LIST=$(curl -s $URL)
        KEY_URLS=$(echo "$FILE_LIST" | grep -o '"[^"]*\.pub"' | sed 's/"//g')
        for KEY_URL in $KEY_URLS; do
            KEY=$(curl -s "${URL}${KEY_URL}")
            if ! grep -q -F "$KEY" ~/.ssh/authorized_keys; then
                echo "$KEY" >> ~/.ssh/authorized_keys
                msg_ok "${COL_DIM}ssh:${COL_NC} copied\\t\\t${COL_BOLD}${COL_ITAL}${KEY_URL}${COL_NC}"
            else
                msg_info "${COL_DIM}ssh:${COL_NC} already exists:\\t${KEY_URL}${COL_NC}"
            fi
        done
        echo ""
        chmod 600 /root/.ssh/authorized_keys
    else    
        msg_info "${COL_DIM}ssh:${COL_NC} public keys unchanged"
        echo ""
    fi
fi

case "$detected_os-$detected_version" in
    debian-10)
        deb_file=zabbix-release_6.4-1+debian10_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    debian-11)
        deb_file=zabbix-release_6.4-1+debian11_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    ubuntu-20.04)
        deb_file=zabbix-release_6.4-1+ubuntu20.04_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    ubuntu-22.04)
        deb_file=zabbix-release_6.4-1+ubuntu22.04_all.deb
        deb_url=https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    *)
        msg_no "${COL_DIM}zabbix-agent:${COL_NC} Unsupported OS version: $detected_os $detected_version"
        #exit 1
        ;;
esac
if [ -f "$deb_file" ]; then
    sleep 1
else
    wget -q "$deb_url"
fi
dpkg -i "$deb_file" &>/dev/null

    msg_quest_prompt "${COL_DIM}zabbix-agent:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_info "${COL_DIM}zabbix-agent:${COL_NC} installing"
        apt update &>/dev/null
        apt install zabbix-agent -y &>/dev/null
        apt-helper
        msg_info "${COL_DIM}zabbix-agent:${COL_NC} modify config"
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
        msg_info "${COL_DIM}zabbix-agent:${COL_NC} config modified"
        msg_ok "${COL_DIM}zabbix-agent:${COL_NC} installed"
        echo ""
    else
        msg_info "${COL_DIM}zabbix-agent:${COL_NC} not installed"
        echo ""
    fi

    msg_quest_prompt "${COL_DIM}zabbix-agent2:${COL_NC} install?${COL_DIM}"
    if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
        msg_info "${COL_DIM}zabbix-agent2:${COL_NC} installing"
        apt update &>/dev/null
		apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
        apt-helper
        msg_info "${COL_DIM}zabbix-agent2:${COL_NC} modify config"
        systemctl restart zabbix-agent2 &>/dev/null
        systemctl enable zabbix-agent2  &>/dev/null
        sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agent2.conf
        sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agent2.conf
        msg_info "${COL_DIM}zabbix-agent2:${COL_NC} config modified"
        systemctl restart zabbix-agent2 &>/dev/null
		msg_ok "${COL_DIM}zabbix-agent2:${COL_NC} installed"
        echo ""
    else            
        msg_info "${COL_DIM}zabbix-agent2:${COL_NC} not installed"
        echo ""
    fi

msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} install updates?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_info "${COL_DIM}$hostsys:${COL_NC} installing updates"
    apt-get update &>/dev/null
    apt-get -y upgrade &>/dev/null
    apt-helper
    msg_ok "${COL_DIM}$hostsys:${COL_NC} updates installed"
    echo ""
else
    msg_info "${COL_DIM}$hostsys:${COL_NC} no updates installed"
    echo ""
fi

msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} install dist-upgrades?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_info "${COL_DIM}$hostsys:${COL_NC} installing dist-upgrades"
    apt-get update &>/dev/null
    apt-get -y dist-upgrade &>/dev/null
    apt-helper
    msg_ok "${COL_DIM}$hostsys:${COL_NC} dist-upgrades installed"
    echo ""
else
    msg_info "${COL_DIM}$hostsys:${COL_NC} no updates installed"
    echo ""
fi

msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} reboot now?${COL_DIM}"
if [[ $prompt =~ ^[Yy][Ee]?[Ss]?|[Jj][Aa]?$ ]] ; then
    msg_info "${COL_DIM}$hostsys:${COL_NC} rebooting"
    sleep 1
    msg_ok "Completed post-installation routines"
    sleep 1
if [ "$WEBSITE_AVAILABLE" = false ]; then
    echo ""
    msg_no "${COL_DIM}public keys:${COL_NC} not copied"
fi
sleep 2
    reboot
else
    msg_info "${COL_DIM}$hostsys:${COL_NC} not rebooted"
fi


if [ "$WEBSITE_AVAILABLE" = false ]; then
    echo ""
    msg_no "${COL_DIM}public keys:${COL_NC} not copied"
fi
sleep 2
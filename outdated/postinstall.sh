#!/usr/bin/env bash -ex
set -euo pipefail
shopt -s inherit_errexit nullglob
YW=`echo "\033[33m"`
BL=`echo "\033[36m"`
RD=`echo "\033[01;31m"`
BGN=`echo "\033[4;92m"`
GN=`echo "\033[1;92m"`
DGN=`echo "\033[32m"`
CL=`echo "\033[m"`
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"








echo -e "${BL}This script will Perform Post Install Routines.${CL}"
while true; do
    read -p "Start the Script (y/n)?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [[ "${UID}" -ne 0 ]]; then
    echo " You need to run this script as root"
    exit 1
fi

function header_info {
    echo -e "${RD}
 ____           _      _           _        _ _ 
|  _ \ ___  ___| |_   (_)_ __  ___| |_ __ _| | |
| |_) / _ \/ __| __|  | | '_ \/ __| __/ _' | | |
|  __/ (_) \__ \ |_   | | | | \__ \ || (_| | | |
|_|   \___/|___/\__|  |_|_| |_|___/\__\__,_|_|_|                                                
 ____                   ____            _       _   
|  _ \ _ __ ___ _ __   / ___|  ___ _ __(_)_ __ | |_ 
| |_) | '__/ _ \ '_ \  \___ \ / __| '__| | '_ \| __|
|  __/| | |  __/ |_) |  ___) | (__| |  | | |_) | |_ 
|_|   |_|  \___| .__/  |____/ \___|_|  |_| .__/ \__|
               |_|                       |_|        
${CL}"
}

function msg_info() {
    local msg="$1"
    echo -ne " ${HOLD} ${YW}${msg}..."
}

function msg_info2() {
    local msg="$1"
    echo -e " ${HOLD} ${YW}${msg}..."
}

function msg_ok() {
    local msg="$1"
    echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}
function msg_no() {
    local msg="$1"
    echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

header_info

echo Hostname is $HOSTNAME
read -r -p "Change hostname? <y/N>" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then    
        echo -n "New hostname:  "
        read -r -p "" hostnameprompt
        #hostname=$hostnameprompt
        echo $hostnameprompt > /etc/hostname
        msg_ok "Hostname changed to $hostnameprompt"
    else
    msg_no "Hostname unchanged"
fi


read -r -p "Load .bashrc? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
    #    msg_info "Moving existing .bashrc in ./dotfiles and load .bashrc from github"
    #    [ ! -d "/root/dotfiles" ] && mkdir -p "root/dotfiles"
    #    cp /root/.bashrc /root/dotfiles/bashrc-$(date +\%Y-\%m-\%d_\%H\%M).txt
        wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/dotfiles/main/.bashrc 
        msg_ok ".bashrc loaded"
        else
        msg_no ".bashrc unchanged"
fi


if command -v Neofetch &> /dev/null
then
    read -r -p "Install Neofetch <y/N> " prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            msg_info "Installing Neofetch"
            apt update &>/dev/null
            apt install neofetch -y &>/dev/null
            echo "neofetch" >> .bashrc
            msg_ok "Neofetch installed"
        else
            msg_no "Neofetch not installed"
        fi
    else
    echo "neofetch already installed"
fi


read -r -p "Install qemu-guest-agent? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
        msg_info "Installing qemu-guest-agent"
        apt update &>/dev/null
        apt install qemu-guest-agent -y &>/dev/null
        msg_ok "Installed qemu-guest-agent"
    else
    msg_no "qemu-guest-agent not installed"
    fi



if [[ $(lsb_release -rs) == "20.04" ||  $(lsb_release -rs) == "22.04" ]]
then
    read -r -p "Install linux-virtual packages? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
        msg_info "Installing linux-virtual packages"
        apt update &>/dev/null
        apt install --install-recommends linux-virtual -y &>/dev/null
        apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
        msg_ok "Installed linux-virtual packages"
    else
    msg_no "Linux-virtual packages not installed"
    fi
fi




if [[ $(lsb_release -rs) == "20.04" ||  $(lsb_release -rs) == "22.04" ]]
then
    read -r -p "Apply workaround for ubuntu booting bug? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
    msg_info "Applying ubuntu boot workaround"
    sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
    systemctl daemon-reload
    msg_ok "Ubuntu boot workaround applied"
    else
    msg_no "Ubuntu boot workaround not applied"
    fi
fi

read -r -p "Set root PW? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    msg_info "Setting root PW"
    echo -e "7fd32tmas96\n7fd32tmas96" | passwd root &>/dev/null
    msg_ok "root pw set"
else
msg_no "root password unchanged"
fi

read -r -p "SSH: allow root login? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    msg_info "Enabling root login via SSH"
    sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
    sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
    sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
    msg_ok "SSH Login with root is now permitted"
else
msg_no "/etc/ssh/sshd_config unchanged"
fi


read -r -p "Set SSH Keys for root <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    msg_info "Loading public key"
    chmod 700 /root/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJd7Z+LQJ9rqYoIGgVusQ2XBLsoJgW2wPbj5k+ZDOS2G9/eTuzX0RC8pXSH1ovJVVr8AxOFIeRZg4gMn2OcwIPskD1qCpNLWAv9ChoXEyn5TKW4gU+9Yngj4w+YRLUAHXjrcEaPA1zOzDwDxdasO3cNJpJ5jhwnqPtNpy7dSYg4kc5j52MNoYJYYwNUJMDBFPmPOj4bg7TW8D2DNYc2jGVsVPClhdA4IRyylW4ozJDLLlOk+nvbBUBWQs3WgpY8QsnHqaP+dz0s1TAW1Vw4YAQGcVac2/dEb+UoCuHu9D4cKSRv+ObL5FYb4TtJogZY7+00Jf3W1Bl33lEyH/AZJrhaTO7mp5HTHajYVBtwsICZQl5VH+RQ0P8ERmXF+3aSd8UQkGl2JUXQfCLaHbr39dsB7DFQd8NgoAIkzpQhCv9JH/JtTt1Luafkegn+owlhJpTd7IribzkWofLB6M+7pky2m1jTtH5cScBDHhMGse3aj28PAJ4Ywe7G4QujiLnphc= zhr@wsred" >> /root/.ssh/authorized_keys2
    chmod 600 /root/.ssh/authorized_keys2
    msg_ok "Publickey provided"
else
msg_no "SSH Keys unchanged"
fi

read -r -p "Install Zabbix Agent? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then

    if [[ $(lsb_release -rs) == "22.04" ]]; 
        then
        msg_info "Prepare package for Ubuntu 22.04"
	    wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu22.04_all.deb &>/dev/null
	    dpkg -i zabbix-release_6.2-2+ubuntu22.04_all.deb &>/dev/null
    fi

    if [[ $(lsb_release -rs) == "20.04" ]]; 
        then
        msg_info "Prepare package for Ubuntu 20.04"
	    wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu20.04_all.deb &>/dev/null
	    dpkg -i zabbix-release_6.2-2+ubuntu20.04_all.deb &>/dev/null
    fi

apt update &>/dev/null
    echo ""
    PS3='Install this Option: '
    options=("zabbix-agent" "zabbix-agent2" "None")
    select opt in "${options[@]}"
    do
        case $opt in
            "zabbix-agent")
                msg_info "Installing zabbix-agent" 
		        apt install zabbix-agent -y &>/dev/null
		        systemctl restart zabbix-agent
		        systemctl enable zabbix-agent
                sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/# StartAgents=3/ s//StartAgents=5/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agentd.conf
                sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agentd.conf
                systemctl restart zabbix-agent
                msg_ok "zabbix-agent installed" 
                break
            ;;
            "zabbix-agent2")
                msg_info "Installing zabbix-agent2"
		        apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
		        systemctl restart zabbix-agent2
		        systemctl enable zabbix-agent2 
                sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agent2.conf
                sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agent2.conf
                systemctl restart zabbix-agent2
                msg_ok "zabbix-agent2 installed" 
                break
            ;;
            "None")
                msg_no "No zabbix-agent selected for installation"
		        break
            ;;
            *) msg_info "invalid option $REPLY";;
    esac
    done
else
msg_no "zabbix-agent not installed"
fi

read -r -p "Update system? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Updating package lists"
apt update &>/dev/null
msg_info "Updating system"
apt upgrade -y &>/dev/null
msg_ok "Update complete"
else
msg_no "System was not updated"
fi

echo ""
sleep 1
echo ""
sleep 1
msg_ok "Completed Post Install Preparation Routines"






if command -v neofetch &> /dev/null
then

            XXXX

else
echo "neofetch already installed"

fi




<< '////'
read -r -p "Add/Correct PVE7 Sources (sources.list)? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Adding or Correcting PVE7 Sources"
cat <<EOF > /etc/apt/sources.list
deb http://ftp.debian.org/debian bullseye main contrib
deb http://ftp.debian.org/debian bullseye-updates main contrib
deb http://security.debian.org/debian-security bullseye-security main contrib
EOF
sleep 2
msg_ok "Added or Corrected PVE7 Sources"
fi

read -r -p "Enable No-Subscription Repository? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Enabling No-Subscription Repository"
cat <<EOF >> /etc/apt/sources.list
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
EOF
sleep 2
msg_ok "Enabled No-Subscription Repository"
fi

read -r -p "Add (Disabled) Beta/Test Repository? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Adding Beta/Test Repository and set disabled"
cat <<EOF >> /etc/apt/sources.list
# deb http://download.proxmox.com/debian/pve bullseye pvetest
EOF
sleep 2
msg_ok "Added Beta/Test Repository"
fi

read -r -p "Disable Subscription Nag? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Disabling Subscription Nag"
echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data.status/{s/\!//;s/Active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" > /etc/apt/apt.conf.d/no-nag-script
apt --reinstall install proxmox-widget-toolkit &>/dev/null
msg_ok "Disabled Subscription Nag"
fi

read -r -p "Update Proxmox VE 7 now? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Updating Proxmox VE 7 (Patience)"
apt-get update &>/dev/null
apt-get -y dist-upgrade &>/dev/null
msg_ok "Updated Proxmox VE 7 (⚠ Reboot Recommended)"
fi

read -r -p "Reboot Proxmox VE 7 now? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "Rebooting Proxmox VE 7"
sleep 2
msg_ok "Completed Post Install Routines"
reboot
fi


sleep 2
msg_ok "Completed Post Install Routines"
////


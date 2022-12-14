#!/usr/bin/env bash

#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/autoinstall.sh)"

    COL_NC='\e[0m' # No Color
    COL_GREEN='\e[1;32m'
    COL_RED='\e[1;31m'
    COL_GREY='\e[0;37m'
    COL_DARK_GREY='\e[1;30m'
    COL_PURPLE='\e[0;35m'
    COL_BLUE='\e[0;34m'
    COL_YELLOW='\e[0;33m'
    COL_CYAN='\e[0;36m'
    COL_CL=`echo "\033[m"` #zeilenumbruch
    COL_DIM='\e[2m' #dimmed 
    COL_ITAL='\e[3m' #italics
    COL_BOLD='\e[1m' #bold
    COL_UNDER='\e[4m' #underline
    TICK="[ ${COL_GREEN}✓${COL_NC} ]  "
    QUEST="[ ${COL_PURPLE}?${COL_NC} ]  "
    CROSS="[ ${COL_RED}✗${COL_NC} ]  "
    INFO="[ i ]  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="[ ${COL_YELLOW}⚠${COL_NC} ]  "
    OVER="\\r\\033[K"
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_env=`systemd-detect-virt`
    chktz=`cat /etc/timezone`
    rsakey1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBPqZaPRjavF9wGzSUZVwDF639JbpDA1Ocy8YbV+LwIT6gvCW0b8I6tbILz2PuER9B2MQqnlGB3iZb0bCqRn7BB6s62E6WnWwWzRoM8zvbV6ftLitG2pu6xoBGuEnRWGpjxncE4CZEF5QjGilZkotavPloUxZytRy5AXHfeX9O9S3FAfdxP34QEYVgM1Xqv8t3SL0Jz9v2k7/3SOyPMKHr9UDKykZeEjn+0zQwztPwX94kK9LP2s/DhMDCLLHK+ksEisekCI5qpkAjdft/sImPOBFtKLR+fWZdr/mwhBGLX5O72Rso5qkpeIhZri4DkAHweUAUCLem12KtUHDpImyO2ajCm/Gq8qJPRqGOuHpsbxIVIOfy7hQJEknNaLtHmd0MGSKQY1aw1vDGTtK2ELAi9N+3G1oUAb2wYrA+6qM1+aiiis38gGSh8Fnzs3cFlwuuRIFOs0QlIRnpo9EbCqyR7HxDoNBMfq7CQrLmEATO7S1yPlvgzxGD7ES7rM+FOWk= install@TKM-MG-NB030"
    rsakey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJd7Z+LQJ9rqYoIGgVusQ2XBLsoJgW2wPbj5k+ZDOS2G9/eTuzX0RC8pXSH1ovJVVr8AxOFIeRZg4gMn2OcwIPskD1qCpNLWAv9ChoXEyn5TKW4gU+9Yngj4w+YRLUAHXjrcEaPA1zOzDwDxdasO3cNJpJ5jhwnqPtNpy7dSYg4kc5j52MNoYJYYwNUJMDBFPmPOj4bg7TW8D2DNYc2jGVsVPClhdA4IRyylW4ozJDLLlOk+nvbBUBWQs3WgpY8QsnHqaP+dz0s1TAW1Vw4YAQGcVac2/dEb+UoCuHu9D4cKSRv+ObL5FYb4TtJogZY7+00Jf3W1Bl33lEyH/AZJrhaTO7mp5HTHajYVBtwsICZQl5VH+RQ0P8ERmXF+3aSd8UQkGl2JUXQfCLaHbr39dsB7DFQd8NgoAIkzpQhCv9JH/JtTt1Luafkegn+owlhJpTd7IribzkWofLB6M+7pky2m1jTtH5cScBDHhMGse3aj28PAJ4Ywe7G4QujiLnphc= zhr@wsred"

function msg_info() {
    local msg="$1"
    printf "%b ${msg}\\n" "${INFO}"
}

function msg_quest() {
    local msg="$1"
    printf "%b ${msg}" "${QUEST}"
}

function msg_quest_prompt() {
    local msg="$1"
    printf "%b ${msg}"" <y/N> " "${QUEST}";read -r -p "" prompt
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
    ____             __     _            __        ____         
   / __ \____  _____/ /_   (_)___  _____/ /_____ _/ / / 
  / /_/ / __ \/ ___/ __/  / / __ \/ ___/ __/ __ '/ / /  
 / ____/ /_/ (__  ) /_   / / / / (__  ) /_/ /_/ / / / 
/_/    \____/____/\__/  /_/_/ /_/____/\__/\__,_/_/_/ 
${COL_CL}
${COL_CL}"
}

header_info
#msg_info "${COL_DIM}autoinstall.sh:\\t${COL_NC} Executing"
msg_info "${COL_DIM}Detected OS:        \\t${COL_NC}${COL_BOLD}$detected_os $detected_version${COL_NC}"
    msg_info "${COL_DIM}Virtual environment:\\t${COL_NC}${COL_BOLD}$detected_env${COL_NC}"
            msg_info "${COL_DIM}Timezone:           \\t${COL_NC}${COL_BOLD}$chktz${COL_NC}"
        if  grep -q "Europe/Berlin" /etc/timezone ; then
            sleep 1
        else
            timedatectl set-timezone Europe/Berlin
            chktz=`cat /etc/timezone`
            msg_ok "${COL_DIM}Timezone set to:      \\t${COL_NC}${COL_BOLD}$chktz${COL_NC}"
        fi
    echo ""
    if [[ "${EUID}" -ne 0 ]]; then
        #printf "\\n\\n"
        printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
        printf "%b Root privileges are needed for this script\\n" "${INFO}"
        printf "%b %bPlease re-run this script as root${COL_NC}\\n" "${INFO}" "${COL_RED}"
        exit 1
    fi


    msg_info "${COL_DIM}.bashrc:\\t${COL_NC} Downloading"
    wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
    sleep 1
    msg_ok "${COL_DIM}.bashrc:\\t${COL_NC} Modified"
    echo ""

    msg_info "${COL_DIM}Neofetch:\\t${COL_NC} Installing"
    apt update &>/dev/null
    apt install neofetch -y &>/dev/null
    msg_ok "${COL_DIM}Neofetch:\\t${COL_NC} Installed"
        if  grep -q "neofetch" /root/.bashrc ; then
            sleep 1
        else
            echo "clear" >> /root/.bashrc
            echo "neofetch" >> /root/.bashrc
        fi
        echo ""

if [[ $detected_env == "kvm" ]]
    then
            msg_info "${COL_DIM}qemu-guest-agent:\\t${COL_NC} Installing"
            apt install qemu-guest-agent -y &>/dev/null
            msg_ok "${COL_DIM}qemu-guest-agent:\\t${COL_NC} Installed"
            echo ""
    fi
    
    if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]
    then
        msg_info "${COL_DIM}Linux-virtual packages:\\t${COL_NC} Installing"
        apt install --install-recommends linux-virtual -y &>/dev/null
        apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
        msg_ok "${COL_DIM}Linux-virtual packages:\\t${COL_NC} Installed"
        echo ""
        if [[ -d "/etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service" ]]
        then
            if [[ $detected_os == "ubuntu" &&  $detected_version == "22.04" || $detected_version == "20.04" ]]
                then
                msg_info "${COL_DIM}KVP daemon bug:\\t${COL_NC} Apply workaround"
                msg_info "Applying workaround for KVP daemon bug"
                sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
                systemctl daemon-reload
                msg_ok "${COL_DIM}KVP daemon bug:\\t${COL_NC} Workaround applied"
                echo ""
            fi
        fi
fi



msg_info "${COL_DIM}root password:\\t${COL_NC} Setting root password"
echo -e "7fd32tmas96\n7fd32tmas96" | passwd root &>/dev/null
sleep 1
msg_ok "${COL_DIM}root password:\\t${COL_NC} root password set"
    echo ""

msg_info "${COL_DIM}sshd_config:\\t${COL_NC} Allowing root login"
sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
sleep 1
msg_ok "${COL_DIM}sshd_config:\\t${COL_NC} root login allowed"
echo ""

msg_info "${COL_DIM}ssh:\\t${COL_NC} Copying public keys"
if [[ -d "/root/.ssh" ]]
    then
        chmod 700 /root/.ssh
        echo $rsakey1 > /root/.ssh/authorized_keys2
        echo $rsakey2 >> /root/.ssh/authorized_keys2
        chmod 600 /root/.ssh/authorized_keys2
        sleep 1
msg_ok "${COL_DIM}ssh:\\t${COL_NC} Public keys copied"
    else
        mkdir /root/.ssh
        chmod 700 /root/.ssh
        echo $rsakey1 > /root/.ssh/authorized_keys2
        echo $rsakey2 >> /root/.ssh/authorized_keys2
        chmod 600 /root/.ssh/authorized_keys2
        sleep 1
        msg_ok "${COL_DIM}ssh:\\t${COL_NC} Public keys copied"
fi
echo ""

msg_info "${COL_DIM}zabbix-agent:\\t${COL_NC} Installing"
if [[ $detected_os == "debian" && $detected_version == "10" ]]
    then
	wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bdebian10_all.deb
	dpkg -i zabbix-release_6.2-2+debian10_all.deb &>/dev/null
fi
if [[ $detected_os == "debian" && $detected_version == "11" ]]
    then
	wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bdebian11_all.deb
	dpkg -i zabbix-release_6.2-2+debian11_all.deb &>/dev/null
fi
if [[ $detected_os == "ubuntu" && $detected_version == "20.04" ]]
    then
	wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu20.04_all.deb
	dpkg -i zabbix-release_6.2-2+ubuntu20.04_all.deb &>/dev/null
fi
if [[ $detected_os == "ubuntu" && $detected_version == "22.04" ]]
    then
	wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu22.04_all.deb
	dpkg -i zabbix-release_6.2-2+ubuntu22.04_all.deb &>/dev/null
fi
apt update &>/dev/null
apt install zabbix-agent -y &>/dev/null

msg_ok "${COL_DIM}zabbix-agent:\\t${COL_NC} Installed"
systemctl restart zabbix-agent &>/dev/null
systemctl enable zabbix-agent &>/dev/null
msg_info "${COL_DIM}zabbix-agent:\\t${COL_NC} Modify config"
sed -i "/Server=127.0.0.1/ s//Server=10.0.0.5/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# StartAgents=3/ s//StartAgents=5/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.0.0.5:10051/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agentd.conf
msg_info "${COL_DIM}zabbix-agent:\\t${COL_NC} Config modified"
echo ""
systemctl restart zabbix-agent &>/dev/null

msg_info "${COL_DIM}$HOSTNAME:\\t${COL_NC} Installing updates"
apt-get -y upgrade &>/dev/null
msg_ok "${COL_DIM}$HOSTNAME:\\t${COL_NC} Updates installed"
echo ""
msg_ok "Completed post-installation routines"


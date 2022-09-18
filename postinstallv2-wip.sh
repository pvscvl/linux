#!/usr/bin/env bash
    COL_NC='\e[0m' # No Color
    COL_LIGHT_GREEN='\e[1;32m'
    COL_LIGHT_RED='\e[1;31m'
    COL_LIGHT_GREY='\e[0;37m'
    COL_DARK_GREY='\e[1;30m'
    COL_PURPLE='\e[0;35m'
    COL_BLUE='\e[0;34m'
    COL_CL=`echo "\033[m"`
    TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]\\t"
    QUEST="[${COL_PURPLE}?${COL_NC}]\\t"
    CROSS="[${COL_LIGHT_RED}✗${COL_NC}]\\t"
    INFO="[i]\\t"
    DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
    OVER="\\r\\033[K"
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
#    RD=`echo "\033[01;32m"`
#    CL=`echo "\033[m"`
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

function msg_ok() {
    local msg="$1"
    printf "%b ${msg}\\n" "${TICK}"
}
function msg_no() {
    local msg="$1"
    printf "%b ${msg}\\n" "${CROSS}"
}




function header_info {
    echo -e "${COL_LIGHT_GREEN}
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
${COL_CL}"
}

msg_info "This script will perform post-installation routines"
while true; do
    msg_quest "Start the script? "; read -p "<y/n> " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * )  msg_ok "Please answer yes or no";echo "";
    esac
done
if [[ "${EUID}" -ne 0 ]]; then
    printf "\\n\\n"
    printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
    printf "%b Root privileges are needed for this script\\n" "${INFO}"
    printf "%b %bPlease re-run this script as root${COL_NC}\\n" "${INFO}" "${COL_LIGHT_RED}"
    exit 1
fi

clear
YW=`echo "\033[33m"`
header_info
sleep 1

|| $prompt == "Yes" ]]
    then
        wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/dotfiles/main/.bashrc 
        msg_ok ".bashrc loaded"
        sleep 1
msg_quest "Load .bashrc? <y/N> "; read -r -p "" prompt
#printf "%b %b Load .bashrc? <y/N> " "${QUEST}"; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" 
    else
        msg_info ".bashrc unchanged"
        sleep 1
    fi
    
    
if command -v Neofetch &> /dev/null
then
msg_quest "Install neofetch? <y/N> "; read -r -p "" prompt
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
    
    
    


if  grep -q "KVM processor" /proc/cpuinfo ; then
    msg_quest "Install qemu-guest-agent? <y/N> " ; read -r -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
            msg_info "Installing qemu-guest-agent"
            apt update &>/dev/null
           apt install qemu-guest-agent -y &>/dev/null
           msg_ok "Installed qemu-guest-agent"
            sleep 1
            else
             msg_no "qemu-guest-agent not installed"
            if [[ $detected_os == "ubuntu" ]]
            then
            msg_info "Installing linux-virtual packages"
                apt update &>/dev/null
                apt install --install-recommends linux-virtual -y &>/dev/null
                apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
                msg_ok "Installed linux-virtual packages"
                sleep 1
            else
                msg_info "Linux-virtual packages not compatible with OS"
                msg_info "Only installed qemu-guest-agent"
                sleep 1
            fi
        fi
fi

if [[ $detected_os == "ubuntu" &&  $detected_version == "22.04" ]]
    then
    msg_quest "Apply workaround for ubuntu booting bug? <y/N> "; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
    msg_info "Applying ubuntu boot workaround"
    sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
    systemctl daemon-reload
    sleep 1
    msg_ok "Ubuntu boot workaround applied"
    sleep 1
    else
    msg_no "Ubuntu boot workaround not applied"
    sleep 1
    fi
fi

msg_quest "Set root password? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    msg_info "Setting root password"
    echo -e "7fd32tmas96\n7fd32tmas96" | passwd root &>/dev/null
    msg_ok "root password set"
else
msg_no "root password unchanged"
fi

msg_quest "SSH: allow root login? <y/N> "; read -r -p "" prompt
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

msg_quest "Set SSH Keys for root <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    msg_info "Loading public keys"
    chmod 700 /root/.ssh
    
    echo $rsakey1 > /root/.ssh/authorized_keys2
    echo $rsakey2 >> /root/.ssh/authorized_keys2
    chmod 600 /root/.ssh/authorized_keys2
    msg_ok "Publickeys provided"
else
msg_no "SSH Keys unchanged"
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
                msg_info "No zabbix-agent selected for installation"
                msg_info "zabbix-agent not installed"
		        break
            ;;
            *) msg_info "invalid option $REPLY";;
    esac
    done
msg_no "zabbix-agent not installed"
fi
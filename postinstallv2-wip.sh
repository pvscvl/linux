#!/usr/bin/env bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/postinstallv2-wip.sh)"
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
    TICK="${COL_NC}[ ${COL_GREEN}✓${COL_NC} ]  "
    QUEST="${COL_NC}[ ${COL_BLUE}?${COL_NC} ]  "
    col='\e[38;5;46m'
    ${col}
    CROSS="${COL_NC}[ ${COL_RED}✗${COL_NC} ]  "
    INFO="${COL_NC}[ i ]  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="${COL_NC}[ ${COL_YELLOW}⚠${COL_NC} ]  "
    OVER="\\r\\033[K"
    detected_architecture=`uname -m`
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_env=`systemd-detect-virt`
    chktz=`cat /etc/timezone`
    hostsys=`hostname -f`
    #rsakey1 = tkm\pascal@TKM-MG-NB029
    #rsakey2 = zhr@wsred
    #rsakey3 = pascal@pascal-mba.local
    rsakey1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDu4GY7aercgm2ooseWTJCJWNIdi2e0Mbf+rDSDJnG1EdBh9pUh9WQ4bxr2YWcaVkjL9Ph7mcuE01FyhRyQRsySigx543rgjHCEhpGR4XUN1R1Oz2CIduaHNMEWOCrNZ6LnYMyomhsqwjRSk7+PyW+3bzNVwqQaQGf/UwcnjaWo+N0tampJKK8ZZqnPbAEgc2VwwcjcKCET3JmE38KesBJsauEW3uyXFTnEhijhfCweyZKIwQHGApGJot+TKH3XpA2FHs8hrIbAXVLFXvuNFwu9ECQ/bw7MIzfd2zLcju2hmm7JC3NdEqah5Rni9bEFD8dwCb0EYUBpwXMEVtgSTe0nZN21Kx1IBIXRABmbljsmHFaUgp2l1gYdPiQP28PDRV7u+unQ/A3hYKxiq6Py88VdDzcplSdrcnqrBp9hL5KcX6iLPHDpmCbD+xhJyUhiUYfM/hLgRq4jG8YpbuvDnX/dNyok9q5h0VjeAD/WlqzltHFVNcLqNhUUJ2ToHylRPfU= tkm\pascal@TKM-MG-NB029"
    rsakey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJd7Z+LQJ9rqYoIGgVusQ2XBLsoJgW2wPbj5k+ZDOS2G9/eTuzX0RC8pXSH1ovJVVr8AxOFIeRZg4gMn2OcwIPskD1qCpNLWAv9ChoXEyn5TKW4gU+9Yngj4w+YRLUAHXjrcEaPA1zOzDwDxdasO3cNJpJ5jhwnqPtNpy7dSYg4kc5j52MNoYJYYwNUJMDBFPmPOj4bg7TW8D2DNYc2jGVsVPClhdA4IRyylW4ozJDLLlOk+nvbBUBWQs3WgpY8QsnHqaP+dz0s1TAW1Vw4YAQGcVac2/dEb+UoCuHu9D4cKSRv+ObL5FYb4TtJogZY7+00Jf3W1Bl33lEyH/AZJrhaTO7mp5HTHajYVBtwsICZQl5VH+RQ0P8ERmXF+3aSd8UQkGl2JUXQfCLaHbr39dsB7DFQd8NgoAIkzpQhCv9JH/JtTt1Luafkegn+owlhJpTd7IribzkWofLB6M+7pky2m1jTtH5cScBDHhMGse3aj28PAJ4Ywe7G4QujiLnphc= zhr@wsred"
    rsakey3="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoQKnjv/EduKIfY3tKtfCjZ8PkBJCDtE5Wc8vuK6wUQqKU5g0moZaYMVQZlBLCNKD3BvczU4kaz9JGIGJfCOq9TgBtEJbfW3rRaUlrIHrsRl+yga3EJeY0HttmZ+lDJNIaCQiaA9vtLQY/6GY+bYTaiEU8NxElFDF7NyKWbebJqJfoqQW0M5en46xXwBitqIMs1RYqXJ67YWqypjtHeOTYddwYQO0AKc4r4UZ8dNjIHe5y8sSUx4OhFoXvBxhz3BNEpsjHP9qyYCbFZl4bS9RRi2nB/meXcdlv8lKw0v5hLUijXqc5AEZ+oOi/z25MawxHaLtz/lWk7BA284odpT6i1aNEd0OvPchYpQKkQtZEJSL+a+OVFFVmBcCfA1NbJ420Ga7q0lZfnJDxIvX6tbxPfoQYWpVmJ4mCsH1Exgpw7/pH7CvulFh3j6DRI8qMeXCeH4YBttUadJE9SJCk6u2WnfnrBiLZpLWX0ZNT1msHMMO+nN22BxYangYWk+ayAeU= pascal@pascal-mba.local"

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
 _    ____  ___   ___        __   _  ________   
| |  / /  |/  /  ( _ )      / /  | |/ / ____/   
| | / / /|_/ /  / __ \/|   / /   |   / /        
| |/ / /  / /  / /_/  <   / /___/   / /___      
|___/_/  /_/   \____/\/  /_____/_/|_\____/      
       _____           _       __               
      / ___/__________(_____  / /_              
      \__ \/ ___/ ___/ / __ \/ __/              
     ___/ / /__/ /  / / /_/ / /_                
    /____/\___/_/  /_/ .___/\__/                
                    /_/    

${COL_CL}
${COL_CL}"
    }
header_info
     msg_info "${COL_DIM}Hostname: ${COL_NC}${COL_BOLD}$hostsys ${COL_NC}"
    msg_info "${COL_DIM}Detected OS: ${COL_NC}${COL_BOLD}$detected_os $detected_version${COL_NC}"
    msg_info "${COL_DIM}Detected architecture: ${COL_NC}${COL_BOLD}${detected_architecture}${COL_NC}"
    msg_info "${COL_DIM}Virtual environment: ${COL_NC}${COL_BOLD}$detected_env${COL_NC}"

            msg_info "${COL_DIM}Timezone: ${COL_NC}${COL_BOLD}$chktz${COL_NC}"
        if  grep -q "Europe/Berlin" /etc/timezone ; then
            #msg_info "Timezone is correct.${COL_NC}"
            echo -n ""
            #echo "" &>/dev/null   
        else
            timedatectl set-timezone Europe/Berlin
            chktz=`cat /etc/timezone`
            msg_ok "${COL_DIM}Timezone set to: ${COL_NC}${COL_BOLD}$chktz${COL_NC}"
                
        fi
    echo ${COL_DIM}\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#${COL_NC}
    #msg_ok "${COL_DIM}postinstall.sh:\\t${COL_NC} Executing"
    if [[ "${EUID}" -ne 0 ]]; then
        #printf "\\n\\n"
        printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
        printf "%b Root privileges are needed for this script\\n" "${INFO}"
        printf "%b %bPlease re-run this script as root${COL_NC}\\n" "${INFO}" "${COL_RED}"
        exit 1
    fi

    msg_quest_prompt "${COL_DIM}.bashrc: ${COL_NC} modify?${COL_DIM}"
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
        wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
        msg_ok "${COL_DIM}.bashrc:${COL_NC} modified"
            echo ""
    else
        msg_no "${COL_DIM}.bashrc:${COL_NC} not modified"
            echo ""
    fi


    msg_quest_prompt "${COL_DIM}Neofetch: ${COL_NC} install?${COL_DIM}"
    #msg_quest "Install neofetch? <y/N> "; read -r -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            msg_info "${COL_DIM}Neofetch:${COL_NC} installing"
           apt update &>/dev/null
           apt install neofetch -y &>/dev/null


            msg_ok "${COL_DIM}Neofetch:${COL_NC} installed"
            echo ""
            if  grep -q "clear" .bashrc ; then
                   echo -n ""
            else
                echo " " >> .bashrc
                echo "clear" >> .bashrc
            fi
            if  grep -q "neofetch" .bashrc ; then
                 echo -n ""
            else
                echo " " >> .bashrc
                echo "neofetch" >> .bashrc
            fi



            if  grep -q "clear" /root/.bashrc ; then
                                      echo -n ""

            else
                echo " " >> /root/.bashrc
                echo "clear" >> /root/.bashrc
            fi
            if  grep -q "neofetch" /root/.bashrc ; then
                                     echo -n ""

            else
                echo " " >> /root/.bashrc
                echo "neofetch" >> /root/.bashrc
            fi

         
        else
            msg_no "${COL_DIM}Neofetch:${COL_NC} not installed"
            echo ""
        fi


        if [[ $detected_env == "kvm" ]]
        then
            msg_quest_prompt "${COL_DIM}qemu-guest-agent: ${COL_NC} install?${COL_DIM}"
            #msg_quest "Install qemu-guest-agent? <y/N> " ; read -r -p "" prompt
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} installing"
                apt update &>/dev/null
                apt install qemu-guest-agent -y &>/dev/null
                msg_ok "${COL_DIM}qemu-guest-agent:${COL_NC} installed"
                echo ""
            else
                msg_no "${COL_DIM}qemu-guest-agent:${COL_NC} not installed"
                echo ""
            fi
        fi
    
    if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]
    then
        msg_quest_prompt "${COL_DIM}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
        #msg_quest "Install linux-virtual packages? <y/N> "; read -r -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                msg_info "${COL_DIM}linux-virtual-packages:${COL_NC} installing"
                apt update &>/dev/null
                apt install --install-recommends linux-virtual -y &>/dev/null
                apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
                msg_ok "${COL_DIM}linux-virtual-packages:${COL_NC} installed"
                echo ""
        else
            msg_no "${COL_DIM}linux-virtual-packages:${COL_NC} not installed"
            echo ""
        fi
    fi

    if [[ $detected_os == "ubuntu" &&  $detected_version == "22.04" || $detected_version == "20.04" ]]
    then
        msg_quest_prompt "${COL_DIM}KVP daemon bug:${COL_NC} apply workaround?${COL_DIM}"
        #msg_quest "Apply workaround for KVP daemon bug? <y/N> "; read -r -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            msg_info "${COL_DIM}KVP daemon bug:${COL_NC} applying workaround"
            sed -i "s/^After=.*/After=systemd-remount-fs.service/" /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
            systemctl daemon-reload
            msg_ok "${COL_DIM}KVP daemon bug:${COL_NC} workaround applied"
            echo ""
        else
            msg_no "${COL_DIM}KVP daemon bug:${COL_NC} workaround not applied"
            echo ""
        fi
    fi
    msg_quest_prompt "${COL_DIM}root login:${COL_NC} set password?${COL_DIM}"
    #msg_quest "Set root password? <y/N> "; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        msg_info "${COL_DIM}root login:${COL_NC} setting password"
        echo -e "7fd32tmas96\n7fd32tmas96" | passwd root &>/dev/null
        msg_ok "${COL_DIM}root login:${COL_NC} password set"
        echo ""
    else
        msg_no "${COL_DIM}root login:${COL_NC} password not set"
        echo ""
    fi

    msg_quest_prompt "${COL_DIM}sshd_config:${COL_NC} permit root login?${COL_DIM}"
    #msg_quest "Allow r"Allow root login via SSH?"oot login via SSH? <y/N> "; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        msg_info "${COL_DIM}sshd_config:${COL_NC} enabling root login"
        sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" /etc/ssh/sshd_config
        sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" /etc/ssh/sshd_config
        sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" /etc/ssh/sshd_config
        msg_ok "${COL_DIM}sshd_config:${COL_NC} root login permitted"
        echo ""
    else
    msg_no "${COL_DIM}sshd_config:${COL_NC} root login not permitted"
    echo ""
    fi

    msg_quest_prompt "${COL_DIM}ssh:${COL_NC} copy public keys for root login?${COL_DIM}"
    #msg_quest "Copy public keys for root login <y/N> "; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        msg_info "${COL_DIM}ssh:${COL_NC} copying public keys"
        if [[ -d "/root/.ssh" ]]
        then
            chmod 700 /root/.ssh
            echo $rsakey1 > /root/.ssh/authorized_keys2
            echo $rsakey2 >> /root/.ssh/authorized_keys2
            echo $rsakey3 >> /root/.ssh/authorized_keys2
            chmod 600 /root/.ssh/authorized_keys2
            msg_ok "${COL_DIM}ssh:${COL_NC} public keys copied"
            echo ""
        else
            mkdir /root/.ssh
            chmod 700 /root/.ssh
            echo $rsakey1 > /root/.ssh/authorized_keys2
            echo $rsakey2 >> /root/.ssh/authorized_keys2
            echo $rsakey3 >> /root/.ssh/authorized_keys2
            chmod 600 /root/.ssh/authorized_keys2
            msg_ok "${COL_DIM}ssh:${COL_NC} public keys copied"
            echo ""
        fi
    else
        msg_no "${COL_DIM}ssh:${COL_NC} public keys not copied"
        echo ""
    fi

    msg_quest_prompt "${COL_DIM}zabbix-agent:${COL_NC} install?${COL_DIM}"
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        msg_info "${COL_DIM}zabbix-agent:${COL_NC} installing"
        if [[ $detected_os == "debian" && $detected_version == "10" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bdebian10_all.deb
		    dpkg -i zabbix-release_6.2-4+debian10_all.deb &>/dev/null
        fi

        if [[ $detected_os == "debian" && $detected_version == "11" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bdebian11_all.deb
		    dpkg -i zabbix-release_6.2-4+debian11_all.deb &>/dev/null
        fi

        if [[ $detected_os == "ubuntu" && $detected_version == "20.04" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu20.04_all.deb
		    dpkg -i zabbix-release_6.2-4+ubuntu20.04_all.deb &>/dev/null
        fi

        if [[ $detected_os == "ubuntu" && $detected_version == "22.04" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu22.04_all.deb
		    dpkg -i zabbix-release_6.2-4+ubuntu22.04_all.deb &>/dev/null
        fi

            apt update &>/dev/null
            apt install zabbix-agent -y &>/dev/null
            msg_ok "${COL_DIM}zabbix-agent:${COL_NC} installed"
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
            echo ""
        else
            msg_no "${COL_DIM}zabbix-agent:${COL_NC} not installed"
            echo ""
    fi

    msg_quest_prompt "${COL_DIM}zabbix-agent2:${COL_NC} install?${COL_DIM}"
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        msg_info "${COL_DIM}zabbix-agent2:${COL_NC} installing"
        if [[ $detected_os == "debian" && $detected_version == "10" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bdebian10_all.deb
		    dpkg -i zabbix-release_6.2-4+debian10_all.deb &>/dev/null
        fi

        if [[ $detected_os == "debian" && $detected_version == "11" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bdebian11_all.deb
		    dpkg -i zabbix-release_6.2-4+debian11_all.deb &>/dev/null
        fi

        if [[ $detected_os == "ubuntu" && $detected_version == "20.04" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu20.04_all.deb
		    dpkg -i zabbix-release_6.2-4+ubuntu20.04_all.deb &>/dev/null
        fi

        if [[ $detected_os == "ubuntu" && $detected_version == "22.04" ]]
            then
		    wget -q https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu22.04_all.deb
		    dpkg -i zabbix-release_6.2-4+ubuntu22.04_all.deb &>/dev/null
        fi    
                apt update &>/dev/null
		        apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y &>/dev/null
                        msg_ok "${COL_DIM}zabbix-agent2:${COL_NC} installed"
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
                msg_info "${COL_DIM}zabbix-agent:${COL_NC} config modified"
                systemctl restart zabbix-agent2 &>/dev/null
                echo ""
                else
                msg_no "${COL_DIM}zabbix-agent2:${COL_NC} not installed"
                echo ""
                fi


msg_quest_prompt "${COL_DIM}$HOSTNAME:${COL_NC} install updates?${COL_DIM}"
#msg_quest "Update $HOSTNAME? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$HOSTNAME:${COL_NC} installing updates"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "${COL_DIM}$HOSTNAME:${COL_NC} updates installed"
echo ""
else
msg_no "${COL_DIM}$HOSTNAME:${COL_NC} no updates installed"
echo ""
fi

msg_quest_prompt "${COL_DIM}$HOSTNAME:${COL_NC} install dist-upgrades?${COL_DIM}"
#msg_quest "Perform dist-upgrade on $HOSTNAME? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$HOSTNAME:${COL_NC} installing dist-upgrades"
apt-get update &>/dev/null
apt-get -y dist-upgrade &>/dev/null
msg_ok "${COL_DIM}$HOSTNAME:${COL_NC} dist-upgrades installed"
echo ""
else
msg_no "${COL_DIM}$HOSTNAME:${COL_NC} no updates installed"
echo ""
fi
msg_quest_prompt "${COL_DIM}$HOSTNAME:${COL_NC} reboot now?${COL_DIM}"
#msg_quest "Reboot $HOSTNAME now? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$HOSTNAME:${COL_NC} rebooting"
sleep 2
msg_ok "Completed post-installation routines"
reboot
fi

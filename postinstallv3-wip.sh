#!/usr/bin/env bash
    #    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/postinstallv3-wip.sh)"
    VERSION="v2023-04-29v5"
    COL_NC='\e[0m' # No Color
    COL_GREEN='\e[1;32m'
    COL_RED='\e[1;31m'
    COL_GREY='\e[0;37m'
    COL_DARK_GREY='\e[1;30m'
    COL_PURPLE='\e[0;35m'
    COL_BLUE='\e[0;34m'
    COL_YELLOW='\e[0;33m'
    COL_CYAN='\e[0;36m'
    COL_CL=`echo "\033[m"` 
    COL_DIM='\e[2m' #dimmed
    COL_ITAL='\e[3m' #italics
    COL_BOLD='\e[1m' #bold
    COL_UNDER='\e[4m' #underline
    TICK="${COL_NC}[${COL_GREEN}✓${COL_NC}]  "
    QUEST="${COL_NC}[${COL_BLUE}?${COL_NC}]  "
    col='\e[38;5;46m'
    CROSS="${COL_NC}[${COL_RED}✗${COL_NC}]  "
    INFO="${COL_NC}[i]  "   
    DONE="${COL_GREEN} done!${COL_NC}"
    WARN="${COL_NC}[${COL_YELLOW}⚠${COL_NC}]  "
    OVER="\\r\\033[K"
    OSTYPE=`uname`
    detected_architecture=`uname -m`
    detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')
    detected_env=`systemd-detect-virt`
    #zbxagent_current_version=`zabbix_agentd --version | head -n1 | sed -e 's/ +$//' -e 's/.* //'`
    zbxagent_latest_version="$(curl -s "https://api.github.com/repos/zabbix/zabbix/tags" | grep -oP '"name": "\K(.*)(?=")' | head -n1)"
    chktz=`cat /etc/timezone`
    hostsys=`hostname -f`
    #rsakey1 = tkm\pascal@TKM-MG-NB029
    #rsakey2 = root@zbx
    #rsakey3 = pascal@pascal-mba.local
    #rsakey4 = jump-srv
    #rsakey1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCypjxXe3QRnMC1dl+GF7lvCjs8dWYnzLTxzNlB0z8kgeow7cSmOfNspPVYk27XWH4k3r+NJruj41A25s1xQ+s5bFdhgCQCMDNAEu/L5KI1il7GkS5/o+dtu2qGHBpj03c0GCmgT2d7eog7yeQQVDT2V/IEObYpD34HATWoyMs4saUEwtochh2lYfgFcdWf+jnhZgIt2LBG8LIy7BWQYfAix/ciFxgrfCFN9FlJdWtMwrhcZSIeYyZHjys2B8Ayjn8LM2oD6vxSRLaCXJHj7joYOMMyBVYZYeYzTQw/hamzkJZ/4t/jtGyJ7vQooykUHhaH/s+Pb5u4AH1yGTsbC+pwgLfKOAB8vp2BSUEqziBLTrRMvVxj4yVIb1vUiEQlVtCkGUprJW0UjPc9w7WjYyf4QfWBDl+ukaZRUOARvdgxxeKOCavhqoWJmfszMdMBSD8fXQxfdiY5rT/JHxeVvpAvPQtdw8xG+L1Tm1tco6vHhwUruxmRZBVdbarWxl0dfbs= tkm\pascal@TKM-MG-NB029"
    #rsakey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa9mIOvb7SfQH65IzxwzkaUUTrDvbzURwKbHbIL6ngDHnuRaipZ6nEXhRetAoPR6M3xJa0jEo2st767eQP9yhWuYGNL4644JFKWk6reZ95j4jSbkOk7YvKMcph8ZsamAYKMfzNNf9MZkCNFM0uQYbVdIx1IqB6xFdnicFivVicouN1eLNGvm2956+zUVwXZOSB4BPtZ3gwgzC5EGRvwXXYSi58vJ/UPyVLsKzQ0hB0I/0CDKlesNiqfN9pxy5YkAY6kgWxa/kFsVIpLOydtTF+BMo8ZGOs5+dgGfLqUMp3O1oA8KKb0Ko1kREK4Q2dKQ6V127wX2SS6qx/lJ4u+JwVn4FiA7vAeP1NZZ6THfFw8E+5O7ezbIv2Tf62PZg1M5nMd2/wZ0PM3yVyRQBcjLukQ7ejN/755+uRwcndncsJX5ahK2f2nfk1qWyiJsu2/CpzubX4okNnympV+PwcyR5oZufNbhtW2Njf5y2jsEsZO0ABaM9MedGP8ye6/LJSzW0= root@zbx01"
    #rsakey3="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoQKnjv/EduKIfY3tKtfCjZ8PkBJCDtE5Wc8vuK6wUQqKU5g0moZaYMVQZlBLCNKD3BvczU4kaz9JGIGJfCOq9TgBtEJbfW3rRaUlrIHrsRl+yga3EJeY0HttmZ+lDJNIaCQiaA9vtLQY/6GY+bYTaiEU8NxElFDF7NyKWbebJqJfoqQW0M5en46xXwBitqIMs1RYqXJ67YWqypjtHeOTYddwYQO0AKc4r4UZ8dNjIHe5y8sSUx4OhFoXvBxhz3BNEpsjHP9qyYCbFZl4bS9RRi2nB/meXcdlv8lKw0v5hLUijXqc5AEZ+oOi/z25MawxHaLtz/lWk7BA284odpT6i1aNEd0OvPchYpQKkQtZEJSL+a+OVFFVmBcCfA1NbJ420Ga7q0lZfnJDxIvX6tbxPfoQYWpVmJ4mCsH1Exgpw7/pH7CvulFh3j6DRI8qMeXCeH4YBttUadJE9SJCk6u2WnfnrBiLZpLWX0ZNT1msHMMO+nN22BxYangYWk+ayAeU= pascal@pascal-mba.local"
    #rsakey4="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzhxYE6WuRctmLUCqRWJZtG2nLZjbzUmT9ujDYY/zPLErrn8LgpCMRZ1C3U6avEJBGQsokZpSpPUkotNkjn7DH0B86aXYBlLipbO3qhTnZ3Z63Xg7GsI65XZt1esFSpHc6itp0BpKx8GObh4sRZiJf02tH/TZO7+FThRGcklFbKBb7w4D+I5qz1OtL35xUfKAlnk1ZYcrwze7OJ1eeOYfo0rMqlUT5QSrEQhseH6tWxDD7GJBe11jGwuynacgnQgpN0c/WMsdY6FeFpSEFaSN7qmHev1CLoNjHiLjRNsCP1wHR6HZhBc3k8+Y6Z6LD/J5M4O/D9EHHEGnH8+YzFYDAqIIzdws9wFsgGe21aH7UK5ff8i6TVUYiOCG+1H15XqeriLrOlYbu62oEMVOGdMC7DfhnI3xmobCDeRXh+dLhE9Bd/UyZrFhpDPev+7dJScguzUb/NGYv/VoQR3ZLYC/+1OEcJLr0A4R/9aDa5MM/jpooUbVjmua3xwFuudNDbQc= root@jump-srv"
function msg_info() {
    local msg="$1"
    printf "%b ${msg}\\n" "${INFO}"
    }
function msg_quest() {
    local msg="$1"
    printf "%b ${msg}${COL_NC}" "${QUEST}${COL_NC}"
    }
function msg_quest_prompt() {
    local msg="$1"
    printf "%b ${msg}"" <y/N> " "${QUEST}";read -r -p "" prompt
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
function msg_warn() {
    local msg="$1"
    printf "%b ${msg}\\n" "${WARN}"
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
header_info
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

    msg_info "Zabbix version available: $zbxagent_latest_version"
    if command -v zabbix_agentd >/dev/null 2>&1; 
        then
            zbxagentd_current_version=`zabbix_agentd --version | head -n1 | sed -e 's/ +$//' -e 's/.* //'`
            msg_info "zabbix-agentd version: $zbxagentd_current_version"
    fi

    if command -v zabbix_agent2 >/dev/null 2>&1; 
        then
            zbxagent2_current_version=`zabbix_agent2 --version | head -n1 | sed -e 's/ +$//' -e 's/.* //'`
            msg_info "zabbix-agent2 version: $zbxagent2_current_version"
    fi

    if [[ "$zbxagent_latest_version" > "$zbxagentd_current_version" || "$zbxagent_latest_version" > "$zbxagent2_current_version" ]]; 
        then
            msg_info "A new version of zabbix-agent is available"
    fi

msg_info "${COL_DIM}Script Version: ${COL_NC}${COL_BOLD}$VERSION ${COL_NC}"
apt update &>/dev/null
echo ""
    if [[ "${EUID}" -ne 0 ]]; then
        #printf "\\n\\n"
        printf "%b%b Can't execute script\\n" "${OVER}" "${CROSS}"
        printf "%b Root privileges are needed for this script\\n" "${INFO}"
        printf "%b %bPlease re-run this script as root${COL_NC}\\n" "${INFO}" "${COL_RED}"
        exit 1
    fi
    
    if [[ "${OSTYPE}" == "Darwin" || "${OSTYPE}" == "darwin" ]]; then
        #printf "\\n\\n"
        msg_no "Can't execute sript"
        msg_info "This script is for linux machines, not macOS machines"
        exit 1
    fi

    msg_quest_prompt "${COL_DIM}.bashrc:${COL_NC} modify?${COL_DIM}"
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            wget -q -O /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
            msg_ok "${COL_DIM}.bashrc:${COL_NC} modified"
            echo ""
        else
            msg_no "${COL_DIM}.bashrc:${COL_NC} not modified"
            echo ""
    fi

    if [ ! -x "$(command -v pfetch)" ]
    then
        msg_quest_prompt "${COL_DIM}pfetch:${COL_NC} install?${COL_DIM}"
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            msg_info "${COL_DIM}pfetch:${COL_NC} installing"
            wget -q https://github.com/dylanaraps/pfetch/archive/master.zip
            apt install unzip &>/dev/null
            unzip master.zip &>/dev/null
            sleep 1
            install pfetch-master/pfetch /usr/local/bin/ &>/dev/null
            msg_ok "${COL_DIM}pfetch:${COL_NC} installed"
            echo ""
            if  grep -q "clear" /root/.bashrc ; then
                echo -n ""
            else
                echo " " >> /root/.bashrc
                echo "clear" >> /root/.bashrc
            fi
            if  grep -q "pfetch" /root/.bashrc ; then
                echo -n ""
            else
                echo " " >> /root/.bashrc
                echo "pfetch" >> /root/.bashrc
            fi
        else
            msg_no "${COL_DIM}pfetch:${COL_NC} not installed"
            echo ""
        fi
    else
        msg_quest "${COL_DIM}pfetch:${COL_NC} install?"
        echo ""
        msg_info "${COL_DIM}pfetch:${COL_NC} already installed"
        echo ""
    fi

    if  grep -q "neofetch" /root/.bashrc
        then
            sed -i "/neofetch/ s//#neofetch/g" /root/.bashrc
            msg_info "${COL_DIM}pfetch:${COL_NC} Removed neofetch from .bashrc"
    fi

    if [ ! -x "$(command -v ack)" ]
    then
        msg_quest_prompt "${COL_DIM}ack:${COL_NC} install?${COL_DIM}"
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                msg_info "${COL_DIM}ack:${COL_NC} installing"
                #apt update &>/dev/null
                apt install ack -y &>/dev/null
                msg_ok "${COL_DIM}ack:${COL_NC} installed"
                echo ""
            else
                msg_no "${COL_DIM}ack:${COL_NC} not installed"
                echo ""
        fi
    else
        msg_quest "${COL_DIM}ack:${COL_NC} install?"
        echo ""
        msg_info "${COL_DIM}ack:${COL_NC} already installed"
        echo ""
    fi

    if [ ! -x "$(command -v mc)" ]
        then
            msg_quest_prompt "${COL_DIM}Midnight Commander:${COL_NC} install?${COL_DIM}"
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
                then
                    msg_info "${COL_DIM}Midnight Commander:${COL_NC} installing"
                    #apt update &>/dev/null
                    apt install mc -y &>/dev/null
                    msg_ok "${COL_DIM}Midnight Commander:${COL_NC} installed"
                    echo ""
                else
                msg_no "${COL_DIM}Midnight Commander:${COL_NC} not installed"
                echo ""
            fi
        else
            msg_quest "${COL_DIM}Midnight Commander:${COL_NC} install?"
            echo ""
            msg_info "${COL_DIM}Midnight Commander:${COL_NC} already installed"
            echo ""
    fi    
    

    if [ ! -x "$(command -v qemu-ga)" ]
        then
            if [[ $detected_env == "kvm" ]]
                then
                    msg_quest_prompt "${COL_DIM}qemu-guest-agent: ${COL_NC} install?${COL_DIM}"
                    #msg_quest "Install qemu-guest-agent? <y/N> " ; read -r -p "" prompt
                    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
                        then
                            msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} installing"
                            #apt update &>/dev/null
                            apt install qemu-guest-agent -y &>/dev/null
                            msg_ok "${COL_DIM}qemu-guest-agent:${COL_NC} installed"
                            echo ""
                        else
                        msg_no "${COL_DIM}qemu-guest-agent:${COL_NC} not installed"
                        echo ""
                    fi
            fi
        else
            msg_quest "${COL_DIM}qemu-guest-agent:${COL_NC} install?"
            echo ""
            msg_info "${COL_DIM}qemu-guest-agent:${COL_NC} already installed"
            echo ""
    fi
    
    if [[ $detected_os == "ubuntu" && $detected_env == "kvm" ]]
        then
            msg_quest_prompt "${COL_DIM}linux-virtual-packages:${COL_NC} install?${COL_DIM}"
            #msg_quest "Install linux-virtual packages? <y/N> "; read -r -p "" prompt
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
                then
                    msg_info "${COL_DIM}linux-virtual-packages:${COL_NC} installing"
                    #apt update &>/dev/null
                    apt install --install-recommends linux-virtual -y &>/dev/null
                    apt install linux-tools-virtual linux-cloud-tools-virtual -y &>/dev/null
                    msg_ok "${COL_DIM}linux-virtual-packages:${COL_NC} installed"
                    echo ""
                else
                    msg_no "${COL_DIM}linux-virtual-packages:${COL_NC} not installed"
                    echo ""
            fi
    fi

    if [[ $detected_env == "kvm" && $detected_os == "ubuntu" &&  $detected_version == "22.04" || $detected_version == "20.04" ]]
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
            
            
            if [ "$detected_env" == "lxc" ]; then
                cp /etc/ssh/sshd_config /root/sshd_config.bckup
                # Look for the sftp subsystem line and comment it out
                sed -i 's/^Subsystem    sftp    \/usr\/lib\/openssh\/sftp-server$/#&/' /etc/ssh/sshd_config
                # Insert a new line above the commented out sftp subsystem line
                sed -i '/^#Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' /etc/ssh/sshd_config
                # Restart the sshd service to apply the changes
                msg_info "${COL_DIM}sshd_config:${COL_NC} changed sftp subsystem to internal"
                echo ""
            fi

        else
            msg_no "${COL_DIM}sshd_config:${COL_NC} root login not permitted"
            echo ""
    fi

msg_quest_prompt "${COL_DIM}ssh:${COL_NC} copy public keys for root login?${COL_DIM}"
#msg_quest "Copy public keys for root login <y/N> "; read -r -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
            msg_info "${COL_DIM}ssh:${COL_NC} copying public keys"
            if ! [[ -d "/root/.ssh" ]]
                then
                mkdir /root/.ssh
            fi
                chmod 700 /root/.ssh
                URL="download.local"
                FILE_LIST=$(curl -s $URL)

                # Extract the URLs for the public key files
                KEY_URLS=$(echo "$FILE_LIST" | grep -o '"[^"]*\.pub"' | sed 's/"//g')

                # Loop through the URLs and add the public keys to authorized_keys
                for KEY_URL in $KEY_URLS; do
                    KEY=$(curl -s "${URL}${KEY_URL}")
                    msg_info "${COL_DIM}ssh:${COL_NC} adding key from ${URL}${KEY_URL}"
                    #echo "Adding key from ${URL}${KEY_URL}"
                    # Check if the key already exists in authorized_keys
                    if ! grep -q -F "$KEY" ~/.ssh/authorized_keys; then
                        echo "$KEY" >> ~/.ssh/authorized_keys
                    fi
                done
                #echo "$rsakey1" > /root/.ssh/authorized_keys
               # echo "$rsakey2" >> /root/.ssh/authorized_keys
               # echo "$rsakey3" >> /root/.ssh/authorized_keys
              #  echo "$rsakey4" >> /root/.ssh/authorized_keys
                chmod 600 /root/.ssh/authorized_keys
                msg_ok "${COL_DIM}ssh:${COL_NC} public keys copied"
                echo ""
        else
            msg_no "${COL_DIM}ssh:${COL_NC} public keys not copied"
            echo ""
    fi


        case "$detected_os-$detected_version" in
            debian-10)
                wget -q https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian10_all.deb
                dpkg -i zabbix-release_6.4-1+debian10_all.deb &>/dev/null
                ;;
            debian-11)
                wget -q https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb
                dpkg -i zabbix-release_6.4-1+debian11_all.deb &>/dev/null
                ;;
            ubuntu-20.04)
                wget -q https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
                dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb &>/dev/null
                ;;
            ubuntu-22.04)
                wget -q https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
                dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb &>/dev/null
                ;;
            *)
                msg_no "${COL_DIM}zabbix-agent:${COL_NC} Unsupported OS version: $detected_os $detected_version"
                #exit 1
                ;;
        esac

    msg_quest_prompt "${COL_DIM}zabbix-agent:${COL_NC} install?${COL_DIM}"
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                msg_info "${COL_DIM}zabbix-agent:${COL_NC} installing"
        apt update &>/dev/null
        apt install zabbix-agent -y #&>/dev/null
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
        apt update &>/dev/null
		apt install zabbix-agent2 zabbix-agent2-plugin-mongodb -y #&>/dev/null
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
                msg_info "${COL_DIM}zabbix-agent2:${COL_NC} config modified"
                systemctl restart zabbix-agent2 &>/dev/null
                echo ""
                else
                msg_no "${COL_DIM}zabbix-agent2:${COL_NC} not installed"
                echo ""
                fi


msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} install updates?${COL_DIM}"
#msg_quest "Update $HOSTNAME? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$hostsys:${COL_NC} installing updates"
apt-get update &>/dev/null
apt-get -y upgrade #&>/dev/null
msg_ok "${COL_DIM}$hostsys:${COL_NC} updates installed"
echo ""
else
msg_no "${COL_DIM}$hostsys:${COL_NC} no updates installed"
echo ""
fi

msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} install dist-upgrades?${COL_DIM}"
#msg_quest "Perform dist-upgrade on $HOSTNAME? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$hostsys:${COL_NC} installing dist-upgrades"
apt-get update &>/dev/null
apt-get -y dist-upgrade #&>/dev/null
msg_ok "${COL_DIM}$hostsys:${COL_NC} dist-upgrades installed"
echo ""
else
msg_no "${COL_DIM}$hostsys:${COL_NC} no updates installed"
echo ""
fi
msg_quest_prompt "${COL_DIM}$hostsys:${COL_NC} reboot now?${COL_DIM}"
#msg_quest "Reboot $HOSTNAME now? <y/N> "; read -r -p "" prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
msg_info "${COL_DIM}$hostsys:${COL_NC} rebooting"
sleep 1
msg_ok "Completed post-installation routines"
sleep 1
reboot
else
msg_no "${COL_DIM}$hostsys:${COL_NC} not rebooted"
fi

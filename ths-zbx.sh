#!/bin/bash

<<'###SCRIPT-EXECUTION###'


bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/ths-zbx.sh)"


###SCRIPT-EXECUTION###

# Check if zabbix_agentd or zabbix_agent2 is installed
if command -v zabbix_agentd &> /dev/null || command -v zabbix_agent2 &> /dev/null; then
	echo "Zabbix agent is already installed."
	exit 0
fi

# Detect OS architecture, OS name, and version
detected_architecture=$(uname -m)
detected_os=$(grep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
detected_version=$(grep VERSION_ID /etc/os-release | cut -d '=' -f2 | tr -d '"')

# Determine the appropriate package URL based on OS and version
case "$detected_os-$detected_version" in
	debian-10)
        	deb_file=zabbix-release_7.0-2+debian10_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-11)
        	deb_file=zabbix-release_7.0-2+debian11_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	debian-12)
        	deb_file=zabbix-release_7.0-2+debian12_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-20.04)
        	deb_file=zabbix-release_7.0-2+ubuntu20.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-22.04)
        	deb_file=zabbix-release_7.0-2+ubuntu22.04_all.deb
        	deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    	ubuntu-24.04)
		deb_file=zabbix-release_7.0-2+ubuntu24.04_all.deb
		deb_url=https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/$deb_file
        ;;
    	*)
        	echo "Unsupported OS version: $detected_os $detected_version"
        	exit 1
        ;;
esac

# Check if the deb file already exists; if not, download it
if [ -f "$deb_file" ]; then
    echo "$deb_file already exists."
else
    echo "Downloading $deb_file..."
    wget -q "$deb_url"
fi

# Install the package
echo "Installing $deb_file..."
dpkg -i "$deb_file" &>/dev/null
apt update &>/dev/null

#### Zabbix Agent ####
<<'####ZABBIX_AGENTD'
apt install zabbix-agent
systemctl restart zabbix-agent &>/dev/null
systemctl enable zabbix-agent &>/dev/null
sed -i "/Server=127.0.0.1/ s//Server=10.123.254.124/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# StartAgents=3/ s//StartAgents=5/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.123.254.124:10051/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agentd.conf
sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent &>/dev/null
####ZABBIX_AGENTD



#### Zabbix Agent 2 ####
apt install zabbix-agent2 zabbix-agent2-plugin-*
systemctl restart zabbix-agent2 &>/dev/null
systemctl enable zabbix-agent2  &>/dev/null
sed -i "/Server=127.0.0.1/ s//Server=10.123.254.124/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/# ListenPort=10050/ s//ListenPort=10050/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/# ListenIP=0.0.0.0/ s//ListenIP=0.0.0.0/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/ServerActive=127.0.0.1/ s//ServerActive=10.123.254.124:10051/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/Hostname=Zabbix server/ s//Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/# RefreshActiveChecks=120/ s//RefreshActiveChecks=60/g" /etc/zabbix/zabbix_agent2.conf
sed -i "/# HeartbeatFrequency=/ s//HeartbeatFrequency=60/g" /etc/zabbix/zabbix_agent2.conf
systemctl restart zabbix-agent2 &>/dev/null



if [ $? -eq 0 ]; then
    echo "Zabbix agent installed successfully."
else
    echo "Failed to install Zabbix agent."
    exit 1
fi




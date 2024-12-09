#!/bin/bash
<<'###DEPLOY-COMMENT'


	bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/refs/heads/main/dotfiles/grant-ssh.sh)"


###DEPLOY-COMMENT

set -e
#	Exit immediately if a command exits with a non-zero status.

set -u
#	Treat unset variables as an error and exit immediately.

set -x
#	Print each command to the terminal before executing it (debugging).

set -v 
#	Print each line of the script as it's read (verbose).

        if [[ ${EUID} -ne 0 ]]; then
                echo "[ERROR] This script must be run as root."
                exit 1
        fi

# Placeholder for the URL of the text file containing the SSH keys
SSH_KEY_URL="<PLACEHOLDER_FOR_URL>"

# Config file paths
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_SUFFIX="_$(date +"%Y%m%d-%H%M")"

# Step 1: Copy SSH Keys
SSH_DIR="${HOME}/.ssh"
AUTHORIZED_KEYS="${SSH_DIR}/authorized_keys"
TMP_KEYS="/tmp/tmp_authorized_keys"
echo "" > ${TMP_KEYS}


mkdir -p ${SSH_DIR}
chmod 700 ${SSH_DIR}
curl -s ${SSH_KEYS_URL} -o ${TMP_KEYS}
        if [[ $? -ne 0 ]]; then
                echo "[ERROR] Failed to fetch SSH keys from ${SSH_KEY_URL}."
                exit 1
        fi

        if [[ -f ${AUTHORIZED_KEYS} ]]; then
                grep -Fxf ${TMP_KEYS} ${AUTHORIZED_KEYS} > /dev/null || cat ${TMP_KEYS} >> ${AUTHORIZED_KEYS}
        else
                mv ${TMP_KEYS} ${AUTHORIZED_KEYS}
        fi
        chmod 600 ${AUTHORIZED_KEYS}


echo "Public SSH keys copied to ${AUTHORIZED_KEYS}."

# Step 2: Permit Root SSH Login
CONFIG_CHANGED=0

# Check if any changes are needed
if ! grep -q '^Subsystem\s\+sftp\s\+internal-sftp' ${SSH_CONFIG_FILE} || \
	grep -q "#PermitRootLogin prohibit-password" ${SSH_CONFIG_FILE} || \
	grep -q "#PubkeyAuthentication yes" ${SSH_CONFIG_FILE} || \
	grep -q "#AuthorizedKeysFile" ${SSH_CONFIG_FILE}; then
        CONFIG_BACKUP="${SSH_CONFIG_FILE}_${BACKUP_SUFFIX}"
        cp ${SSH_CONFIG_FILE} ${CONFIG_BACKUP}
        echo "Backup created for SSH configuration: ${CONFIG_BACKUP}."
fi


# Check and insert internal-sftp configuration
if ! grep -q '^Subsystem\s\+sftp\s\+internal-sftp' ${SSH_CONFIG_FILE}; then
        sed -i '/^Subsystem  sftp    \/usr\/lib\/openssh\/sftp-server$/i Subsystem   sftp    internal-sftp' ${SSH_CONFIG_FILE}
        CONFIG_CHANGED=1
fi

# Update PermitRootLogin to "yes"
if grep -q "#PermitRootLogin prohibit-password" ${SSH_CONFIG_FILE}; then
        sed -i "/#PermitRootLogin prohibit-password/ s//PermitRootLogin yes/g" ${SSH_CONFIG_FILE}
        CONFIG_CHANGED=1
fi

# Ensure PubkeyAuthentication is enabled
if grep -q "#PubkeyAuthentication yes" ${SSH_CONFIG_FILE}; then
        sed -i "/#PubkeyAuthentication yes/ s//PubkeyAuthentication yes/g" ${SSH_CONFIG_FILE}
        CONFIG_CHANGED=1
fi

# Ensure AuthorizedKeysFile is uncommented
if grep -q "#AuthorizedKeysFile" ${SSH_CONFIG_FILE}; then
        sed -i "/#AuthorizedKeysFile/ s//AuthorizedKeysFile/g" ${SSH_CONFIG_FILE}
        CONFIG_CHANGED=1
fi

if [[ ${CONFIG_CHANGED} -eq 1 ]]; then
        systemctl reload sshd
        echo "SSH configuration updated and service reloaded."
else
        echo "No changes made to SSH configuration."
fi

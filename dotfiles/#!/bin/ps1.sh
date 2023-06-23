#!/bin/bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/ps1.sh)"

# Set the path to the .bashrc file
bashrc_file="/root/.bashrc"

# Create a backup of the original .bashrc file
cp "$bashrc_file" "$bashrc_file.backup"

# Comment out lines starting with "PS1=" or "export PS1="
sed -i.bak '/^PS1=/s/^/#/' "$bashrc_file"
sed -i.bak '/^export PS1=/s/^/#/' "$bashrc_file"

# Add a new prompt
new_prompt='export PS1="\[\e]0;\u@\H: \w\a\]\t ${debian_chroot:+($debian_chroot)}\033[00m\]\u\[\033[01;30m\]@\[\033[01;32m\]\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ " '
echo -e "\n$new_prompt" >> "$bashrc_file"

# Source the modified .bashrc file to apply changes immediately
source "$bashrc_file"

echo "Done! The changes have been applied to .bashrc."

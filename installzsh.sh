sudo apt update
sudo apt install zsh -y
apt install git -y
chsh -s $(which zsh)
cd $HOME
mkdir .dotfiles
cd $HOME/.dotfiles
touch .aliases .functions .exports
cd
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
apt install fonts-powerline -y
apt install pip -y
pip install powerline-shell 
mkdir -p ~/.config/powerline-shell 
powerline-shell --generate-config > ~/.config/powerline-shell/config.json
cd
echo " " > .zshrc
curl https://raw.githubusercontent.com/pvscvl/linux/main/zshrc > .zshrc


source ~/.zshrc

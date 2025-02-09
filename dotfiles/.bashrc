<<'###DEPLOY-COMMENT'

	cp /root/.bashrc /root/.bashrc_$(date +"%Y-%m-%d_%H%M").txt && \
	curl -o /root/.bashrc https://raw.githubusercontent.com/pvscvl/linux/refs/heads/main/dotfiles/.bashrc


###DEPLOY-COMMENT

export PS1="\[\e]0;\u@\H: \w\a\]\t ${debian_chroot:+($debian_chroot)}\033[00m\]\u\[\033[01;30m\]@\[\033[01;32m\]\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "
export LS_COLORS="no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"
export LSCOLORS="BxBxhxDxfxhxhxhxhxcxcx"
export colorflag="-G"

alias ..="cd .."
alias ....="cd ../.."
alias _ls="ls -alhFXp --color=always --group-directories-first" 
alias ll="ls -alhFXp --color=always --group-directories-first" 
alias _update="apt-get update && apt-get upgrade -y"
alias _updatedist="apt-get update && apt-get dist-upgrade -y"


alias show-externalip="dig +short myip.opendns.com @resolver1.opendns.com"
alias show-ip='hostname -I | tr " " "\n"'

cp_p (){
        rsync -WavP --human-readable --progress $1 $2
}
export PS1="\[\e]0;\u@\H: \w\a\]\t ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\H\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] " 
export LS_COLORS="no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"
export LSCOLORS="BxBxhxDxfxhxhxhxhxcxcx"
export colorflag="-G"

alias ..="cd .."
#alias ls="ls -alhFX --color=always" 
alias _update="apt-get update && apt-get upgrade -y"
alias _updatedist="apt-get update && apt-get dist-upgrade -y"
#alias _update-dotfiles="wget -O $HOME/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc && wget -O $HOME/.dotfiles/.exports https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.exports && wget -O $HOME/.dotfiles/.functions https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.functions && wget -O $HOME/.dotfiles/.aliases https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.aliases"
#alias _update-dotfiles2="curl https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc > $HOME/.bashrc && curl https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.exports > $HOME/.dotfiles/.exports && curl https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.functions > $HOME/.dotfiles/.functions  && curl https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.aliases > $HOME/.dotfiles/.aliases"

alias show-externalip="dig +short myip.opendns.com @resolver1.opendns.com"
alias show-internalip="hostname -I"
alias pwgen="generate-password"
alias repeatscript="rm postinstallv3-wip.sh; wget https://raw.githubusercontent.com/pvscvl/linux/main/postinstallv3-wip.sh; chmod +x postinstallv3-wip.sh; ./postinstallv3-wip.sh"


# Copy w/ progress
cp_p (){
        rsync -WavP --human-readable --progress $1 $2
}


function update-dotfiles () {
    local DOTFILESHOME=$HOME
    local DOTFILESFOLDER=$HOME/.dotfiles/
    wget -q -O $DOTFILESHOME/.bashrc https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.bashrc
    wget -q -O $DOTFILESFOLDER/.exports https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.exports
    wget -q -O $DOTFILESFOLDER/.functions https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.functions
    wget -q -O $DOTFILESFOLDER/.aliases https://raw.githubusercontent.com/pvscvl/linux/main/dotfiles/.aliases
}


function generate-mac() {
    local INFO="[i]  "   
    local COL_BOLD='\e[1m' #bold
    local COL_NC='\e[0m' # No Color
    local COL_GREEN='\e[1;32m'
    local TICK="[${COL_GREEN}✓${COL_NC}]  "
    local GEN_MAC=$(echo '00 13 37'$(od -An -N3 -t xC /dev/urandom) | sed -e 's/ /:/g' | tr '[:lower:]' '[:upper:]')
    printf "%b Generating MAC-Address...\\n" "${INFO}"
    echo ""
    printf "%b ${GEN_MAC}" "${TICK}"
    echo ""
    echo ""
}


function generate-mac2() {
    local COL_NC='\e[0m' # No Color
    local COL_YELLOW='\e[0;33m'
    local WARN="[${COL_YELLOW}⚠${COL_NC}]  "
    local GEN_MAC=$(echo '00 13 37'$(od -An -N3 -t xC /dev/urandom) | sed -e 's/ /:/g' | tr '[:lower:]' '[:upper:]')
    printf "%b ${GEN_MAC}\\n" "${WARN}"
    echo ""
}


function generate-password() {
    local pwup="`env LC_CTYPE=C tr -dc "ABCDEFGHKLMNPRQSTUVWXYZ" < /dev/urandom | head -c 4`"
    local pwdown1="`env LC_CTYPE=C tr -dc "abcdefghikmnoprstuvwxyz" < /dev/urandom | head -c 4`"
    local pwdown2="`env LC_CTYPE=C tr -dc "abcdefghikmnoprstuvwxyz" < /dev/urandom | head -c 4`"
    local pwdigits="`env LC_CTYPE=C tr -dc "0123456789" < /dev/urandom | head -c 4` "
    echo ""
    printf "${pwup}-${pwdown1}-${pwdown2}-${pwdigits}"
    echo ""
    echo ""
}



  function gdl-cmplete3() {
      local ccdir=`echo "${PWD##*/}"`
      mkdir "$ccdir pics"
      mkdir "$ccdir vids"
      local cdir="${PWD##*/}"
      local pics_dir="$cdir pics"
      local vids_dir="$cdir vids"
  
      setopt null_glob
      for ext in jpg jpeg gif png bmp svg; do
          mv -- *."${(U)ext}" *."${ext}" ./"$pics_dir" 2>/dev/null
      done
      
      for ext in mp4; do
          mv -- *."${(U)ext}" *."${ext}" ./"$vids_dir" 2>/dev/null
      done
  
      cd ./$pics_dir
      
      for f in ./*.*; do
          fn=$(basename "$f")
          mv "$fn" "$(gdate -r "$f" +"%Y.Q%q-%m%d_%H%M").$fn"
      done
  
      for year in {2014..2023}; do
          for quarter in Q1 Q2 Q3 Q4; do
              mkdir -p $year/$quarter
              mv ./$year*.$quarter* ./$year/$quarter/ 2>/dev/null
          done
      done
        
      find ./{2014..2023} -type d -empty -delete

function rename-timestamp-prefix() {
    for f in ./*.*; do   fn=$(basename "$f");   mv "$fn" "$(date -r "$f" +"%Y.Q%q-%m%d_%H%M").$fn" -v; done
}



#source /root/.dotfiles/.exports
#source /root/.dotfiles/.aliases
#source /root/.dotfiles/.functions
#alias _update2="sudo apt-get update && sudo apt-get upgrade -y"

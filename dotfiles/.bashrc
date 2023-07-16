export BASHRCVERSION=2
export PS1="\[\e]0;\u@\H: \w\a\]\t ${debian_chroot:+($debian_chroot)}\033[00m\]\u\[\033[01;30m\]@\[\033[01;32m\]\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "
export LS_COLORS="no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"
export LSCOLORS="BxBxhxDxfxhxhxhxhxcxcx"
export colorflag="-G"

alias ..="cd .."
alias _ls="ls -alhFXp --color=always --group-directories-first" 
alias ll="ls -alhFXp --color=always --group-directories-first" 
alias _update="apt-get update && apt-get upgrade -y"
alias _updatedist="apt-get update && apt-get dist-upgrade -y"


alias show-externalip="dig +short myip.opendns.com @resolver1.opendns.com"
alias show-ip='hostname -I | tr " " "\n"'
#alias show-internalip="hostname -I"
alias pwgen="generate-password"

# Copy w/ progress
cp_p (){
        rsync -WavP --human-readable --progress $1 $2
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
}
function rename-timestamp-prefix() {
    for f in ./*.*; do   fn=$(basename "$f");   mv "$fn" "$(date -r "$f" +"%Y.Q%q-%m%d_%H%M").$fn" -v; done
}

move2extension() {
    if [ $# -lt 1 ]; then
        echo "Usage: move_files_by_extension <extension>"
        return 1
    fi

    extension=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    directory=`echo "${PWD##*/}"`

    # Get the parent folder name
    parent_folder=$(basename "$directory")

    # Create the target directory with the parent folder name and extension
    target_directory="${parent_folder} ${extension}"
    mkdir -p "$target_directory"

    # Move files with the specified extension from the current directory to the target directory
    find . -maxdepth 1 -type f -iname "*.$extension" -exec gmv -t "$target_directory" {} +
}

mv2ext() {
    if [ $# -lt 1 ]; then
        echo "Usage: move_files_by_extension <extension>"
        return 1
    fi

    extension=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    directory=`echo "${PWD##*/}"`

    # Get the parent folder name
    parent_folder=$(basename "$directory")

    # Create the target directory with the parent folder name and extension
    target_directory="${parent_folder} ${extension}"
    mkdir -p "$target_directory"

    # Move files with the specified extension from the current directory to the target directory
    find . -maxdepth 1 -type f -iname "*.$extension" -exec gmv -t "$target_directory" {} +
}


get_macaddress() {
    ip=$1
    arp -a | grep "$ip" | grep -oE '([0-9A-Fa-f]{1,2}:){5}([0-9A-Fa-f]{1,2})' | head -n 1
}




clear
pfetch

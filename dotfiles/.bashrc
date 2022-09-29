DOTFILESHOME=$HOME
source $DOTFILESHOME/.dotfiles/.exports
source $DOTFILESHOME/.dotfiles/.aliases
#source $DOTFILESHOME/.dotfiles/.functions


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

neofetch

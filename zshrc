export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
CASE_SENSITIVE="false"
zstyle ':omz:update' mode auto
#DISABLE_AUTO_TITLE="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

pfetch

DOTFILESHOME=$HOME
source $DOTFILESHOME/.dotfiles/.exports
source $DOTFILESHOME/.dotfiles/.aliases
source $DOTFILESHOME/.dotfiles/.functions

alias ..="cd .."
alias ....="cd ../.."
alias _ls="ls -alhFXp --color=always --group-directories-first" 
alias ll="ls -alhFXp --color=always --group-directories-first" 

export LANG=en_US.UTF-8 

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" -a -x "$(command -v powerline-shell)" ]; then
    install_powerline_precmd
fi

#setopt prompt_subst

function preexec() {
  cmdstart=$(($(print -P %D{%s%6.})/1000))
}

function precmd() {
        if [ $cmdstart ]; then
                now=$(($(print -P %D{%s%6.})/1000))
                elapsed=$(($now-$cmdstart))
                hours=$(printf "%02d" $((elapsed / 3600000)))
                minutes=$(printf "%02d" $(( (elapsed / 60000) % 60)))
                seconds=$(printf "%02d" $(( (elapsed / 1000) % 60)))
                milliseconds=$((elapsed % 1000))
                formatted_time=""
                [ $hours -gt 0 ] && formatted_time="${hours}h "
                [ $minutes -gt 0 ] && formatted_time+="${minutes}m "
                formatted_time+="${seconds}s ${milliseconds}ms"
                export RPROMPT="%F{cyan}${formatted_time}%{$reset_color%}"
                unset cmdstart
        else 
                unset cmdstart
                RPROMPT=%D{%H:%M:%S}
        fi
}

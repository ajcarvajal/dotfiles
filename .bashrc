# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

[[ $TERM != "screen-256color" ]] && exec tmux

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export READER="zathura"
export EDITOR="vim"
export PAGER="less"

man() {
    LESS_TERMCAP_md=$'\e[01;34m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;08;08m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;36m' \
    command man "$@"
}

alias vim="/usr/bin/vim"

alias ls='ls --color=auto --file-type'
export LS_COLORS='ex=35;01:ow=34;01'

# confirm deletion of 3 or more files
alias rm='rm -I'

# Tree color
alias tree='tree -C'

# C drive alias for WSL
alias cdc='cd /mnt/c/Users/alcarvaj'

alias fd=fdfind

export VISUAL=vim
export EDITOR="$VISUAL"

# prevent tmux timout
unset TMOUT

# Disable ctrl-s / ctrl-q
stty -ixon

export PATH=$PATH:~/bin
export PS1="\[\033[38;5;175m\][\[$(tput sgr0)\]\[\033[38;5;181m\]\u@\h\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\[\033[38;5;181m\]\[$(tput sgr0)\]\[\033[38;5;175m\]]\[$(tput sgr0)\]\[\033[38;5;15m\][\j]$\[$(tput sgr0)\] "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias fzf="fzf --preview '/usr/bin/bat --color=always --theme=OneHalfDark {}'"
export BAT_THEME='DarkNeon'
export FZF_DEFAULT_COMMAND='fdfind -H --exclude=*/env/** --exclude=**/.*/*'
export FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'

_fzf_compgen_path() {
    fd --hidden --exclude="*/env/*"  --exclude="*/.*/*" . "$1"
}

_fzf_compgen_dir() {
    fd --hidden --exclude="*/env/*"  --exclude="*/.*/*" . "$1"
}

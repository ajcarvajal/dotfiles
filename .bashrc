#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


PATH=~/bin:~/.cargo/bin:$PATH
export READER="zathura"
export EDITOR="vim"

alias ls='ls --color=auto --file-type'
PS1='[\u@\h \W]\$ '

#for dotfile repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias audio='pavucontrol'
alias mutt='neomutt'

export VISUAL=vim
export EDITOR="$VISUAL"

#Disable ctrl-s / ctrl-q
stty -ixon

export PS1="\[\033[38;5;175m\][\[$(tput sgr0)\]\[\033[38;5;181m\]\u@\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;181m\]\W\[$(tput sgr0)\]\[\033[38;5;175m\]]\[$(tput sgr0)\]\[\033[38;5;15m\]\\$\[$(tput sgr0)\] "

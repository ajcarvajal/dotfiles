#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=~/bin:~/.emacs.d/bin:$PATH

alias ls='ls --color=auto --file-type'
PS1='[\u@\h \W]\$ '

#for dotfile repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#for bad programs that put config in ~
alias calcurse='calcurse -D ~/.config/.calcurse'

export VISUAL=vim
export EDITOR="$VISUAL"

# Map Ctrl-S to sth usefull other than XOFF (interrupt data flow).
stty -ixon

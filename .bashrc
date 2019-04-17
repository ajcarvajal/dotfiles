#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=~/bin:$PATH

alias ls='ls --color=auto --file-type'
PS1='[\u@\h \W]\$ '

alias vim='echo -ne "\033]0;VIM\007" && vim'

#for dotfile repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#for bad programs that put config in ~
alias calcurse='calcurse -D ~/.config/.calcurse'

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto --file-type'
PS1='[\u@\h \W]\$ '

alias vim='echo -ne "\033]0;VIM\007" && vim'

#for bad programs that put config in ~
alias calcurse='calcurse -D ~/.config/.calcurse'

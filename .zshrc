setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt no_share_history
unsetopt share_history
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000000
SAVEHIST=100000000
setopt beep nomatch
unsetopt autocd extendedglob notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aaron/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit
PROMPT='%F{208}%n%f in %F{226}%~%f -> '
bindkey -v '^?' backward-delete-char

export CC=clang
export CXX=clang++

# vim
alias vim='nvim'
export EDITOR=nvim
# dotnet
export PATH="${PATH}:/home/aaron/.dotnet/tools/"
# gotop
alias gotop="gotop -c monokai"
# fix tmux 
alias tmux='TERM=xterm-256color tmux'

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh


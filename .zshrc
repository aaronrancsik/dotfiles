setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt no_share_history
unsetopt share_history

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
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

# Custom propmt
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '- %F{5}[%f%F{2}'$branch'%f%F{5}]%f '
  fi
}
autoload -Uz promptinit
promptinit
setopt prompt_subst
prompt_mytheme_setup() {
  PS1='%F{2}%f %F{7}%c%f $(git_branch_name)%F{2}≫  %f'
}
# Add the theme to promptsys
prompt_themes+=( mytheme )

# Load the theme
prompt mytheme


# ls color
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;40:ow=34;40:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

echo -e -n "\x1b[\x33 q"
if [ "$TERM" = "alacritty" ]; then

        if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
    		# if not inside a tmux session, and if no session is started, start a new session
    		current_dir=$(pwd)
    		#[ -z "${TMUX}" ] && (tmux attach \; new-window -c $current_dir\;|| tmux)
    		[ -z "${TMUX}" ] && (tmux attach||tmux)
    
        fi

fi


export CC=clang
export CXX=clang++

# Aliases
# General
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
alias ll='ls -lah'
alias ta='tmux attach'
# vim
alias vim='nvim'
export EDITOR=nvim
# dotnet
export PATH="${PATH}:/home/aaron/.dotnet/tools/"
export PATH="${PATH}:/home/aaron/bin/"

# gotop
alias gotop="gotop -c monokai"
# fix tmux 
alias tmux='TERM=xterm-256color tmux'

# bookmarks
alias pro='cd ~/Documents/Proj'
alias the='cd ~/Documents/Proj/BSC_THESIS'

# vim cursor
# Remove mode switching delay.
KEYTIMEOUT=1

# OLD CURSOR CHANGE
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[3 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
 _fix_cursor() {
    echo -ne '\e[5 q'
 }
 precmd_functions+=(_fix_cursor)
# ZVM_CURSOR_STYLE_ENABLED=false

# Plugins order is matter
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2> /dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null

# zsh-vi-mode
##############################################
# pre settigns
function zvm_config() {
 ZVM_INIT_MODE=sourcing
}
# zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# post settings
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
##############################################

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

bindkey -M vicmd '^R' fzf-history-widget

# Created by `userpath` on 2021-10-27 22:18:56
export PATH="$PATH:/home/aaron/.local/bin"

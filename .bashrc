#
# ~/.bashrc
#

alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
bind -m vi-insert "\C-l":clear-screen

export CC=clang
export CXX=clang++

#nnn
export PAGER='bat'
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;d:diffs;t:preview-tabbed;i:imgview;v:vidthumb;d:drag;u:pdfview'
export NNN_FIFO='/tmp/nnn.fifo'
alias nnn="nnn -a"
# vi mode in bash 
# set -o vi

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

source /usr/share/clang/bash-autocomplete.sh

alias ffsend="ffsend upload"
alias tmux='TERM=xterm-256color tmux'

[[ $- != *i* ]] && return
# killall xcape 2>/dev/null ; xcape -e 'ISO_Level3_Shift=Multi_key'
echo -e -n "\x1b[\x33 q"
if [ "$TERM" = "alacritty" ]; then

        if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
    		# if not inside a tmux session, and if no session is started, start a new session
    		current_dir=$(pwd)
    		#[ -z "${TMUX}" ] && (tmux attach \; new-window -c $current_dir\;|| tmux)
    		[ -z "${TMUX}" ] && (tmux attach||tmux)
    
        fi

fi
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;37m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		# PS1='\[\e[01;37m\]\W\[\e[01;39m\] $\[\033[00m\] '
                PS1="\[$(tput bold)\]\[\033[38;5;12m\]\W\[$(tput sgr0)\] \[$(tput bold)\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
	fi
	alias less='less -r'
	alias ls='ls --color=always'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less
alias pig='du -cks * | sort -rn | head -11'

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s histappend

shopt -s expand_aliases

# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups 

export HISTSIZE=999999999                   # big big history
export HISTFILESIZE=999999999               # big big history

function custom_prompt() {
  __git_ps1 "\[\033[0;31m\]\u \[\033[0;36m\]\h:\w\[\033[00m\]" " \n\[\033[0;31m\]>\[\033[00m\] " " %s"
  VTE_PWD_THING="$(__vte_osc7)"
  PS1="$PS1$VTE_PWD_THING"
}

export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

alias gotop="gotop -c monokai"

# vim
alias vim='nvim'
export EDITOR=nvim
export PATH="${PATH}:/home/aaron/.dotnet/tools/"

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash


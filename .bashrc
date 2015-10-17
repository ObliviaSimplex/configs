# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

function makeprompt {
    EXITSTATUS="$?"
    JOBS="$(jobs | wc -l)"
    TIME="$(date +%R)"
    # set prompt
    # define some colours


    DARKGREEN="\[\033[00;32m\]"
    GREEN="\[\033[01;32m\]"
    TEAL="\[\033[00;36m\]"
    DARKGREY="\[\033[01;30m\]"
    CYAN="\[\033[01;36m\]"
    LIGHTGREY="\[\033[00;37m\]"
    RED="\[\033[00;31m\]" #?
    PINK="\[\033[01;31m\]" #?
    BLACK="\[\033[00;30m\]"
    BLUE="\[\033[01;34m\]"
    DARKBLUE="\[\033[00;34m\]"
    WHITE="\[\033[01;38m\]"
    OFF="\[\033[m\]"

    NAMECOLOR=$DARKBLUE
    HICOLOR=$BLUE

    PS1="${HICOLOR}-=oO( ${NAMECOLOR}${JOBS}${HICOLOR} )( $NAMECOLOR$TIME$HICOLOR )(${NAMECOLOR} \u@\h${HICOLOR} \W${HICOLOR} )Oo=-${NAMECOLOR}\n"

    ## flag if error
    if (( $EXITSTATUS == 0 )); then
        PS1="${PS1}${BLUE}* ${OFF}"
    else
        PS1="${PS1}${RED}* ${OFF}"
    fi

    PS2="${RED}| ${OFF}"
}

PROMPT_COMMAND=makeprompt


# Two useful functions: package count (pc) and package list (pl):

pc(){ local i=0; while read; do ((i++)); done < <(printf "%s\n" /var/db/pkg/*/*/); echo "$i"; } 
pl(){ local i; for i in /var/db/pkg/*/*; do i="${i#/*/*/*/}"; echo "${i%-[0-9]*}"; done; }


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_envvars ]; then
    . ~/.bash_envvars
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Start the emacs daemon if not already running.
# daemon_running=`ps ux | grep "[e]macs --daemon"`
# if [[ $daemon_running ]]; then
#     echo "Emacs daemon already running."
# else
#     echo "Emacs daemon not running. Starting it."
#     emacs --daemon
# fi

# Check whether we're graphical or not.
#if [[ $DISPLAY ]]; then
#    emacsclient -c -n -e "(shell \"@login\")"
#else
#    emacsclient -t -n -e "(shell \"@login\")"
#fi
#emacsclient -t -n -e "(eshell)"


# Set default application

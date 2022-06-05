#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Bash shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s dotglob

# Bash variables see bash(1) for more details on configuration
HISTSIZE=20000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
TERM=xterm-256color

set_ps1 () {
    local __PREVIOUS_EXIT_CODE="$?"

    # Colors
    local __GREEN="\\[\\033[01;32m\\]"
    local __BLUE="\\[\\033[01;34m\\]"
    local __RED="\\[\\033[01;31m\\]"
    local __RESET="\\[\\033[0m\\]"

    # Prompt Components
    local __USER_AND_HOST="$__GREEN\\u@\\h$__RESET"
    local __WORKING_DIRECTORY="$__BLUE\\w$__RESET"
    local __EXIT_CODE=""
    local __GIT_BRANCH=""

    # Set color based on exit code status
    if [ $__PREVIOUS_EXIT_CODE -eq 0 ]; then
        __EXIT_CODE="($__GREEN$__PREVIOUS_EXIT_CODE$__RESET)"
    else
        __EXIT_CODE="($__RED$__PREVIOUS_EXIT_CODE$__RESET)"
    fi

    # Source git-prompt bash completion if it hasn't already been
    __CURENT_BRANCH="$(__git_ps1)"
    __GIT_PS1_EXIT_CODE="$?"

    if [ "$__GIT_PS1_EXIT_CODE" -gt 0 ]; then
        . /etc/bash_completion.d/git-prompt
        __CURENT_BRANCH="$(__git_ps1)"
    fi

    # Set color of git branch
    if [[ $__CURENT_BRANCH =~ "master" ]]; then
        __GIT_BRANCH="$__RED$__CURENT_BRANCH$__RESET"
    else
        __GIT_BRANCH="$__GREEN$__CURENT_BRANCH$__RESET"
    fi

    PS1="$__EXIT_CODE$__GIT_BRANCH $__USER_AND_HOST:$__WORKING_DIRECTORY\n$ "

}

PROMPT_COMMAND=set_ps1

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.
[ -f "$HOME"/.bash_aliases ] && . "$HOME"/.bash_aliases
[ -f "$HOME"/.local/bin ] && . export $PATH=$PATH:$HOME/.local/bin

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

# Google cloud bashrc, including updating path for SDK and for shell completion
[ -f '/home/owen/google-cloud-sdk/path.bash.inc' ] && . '/home/owen/google-cloud-sdk/path.bash.inc'
[ -f '/home/owen/google-cloud-sdk/completion.bash.inc' ] && . '/home/owen/google-cloud-sdk/completion.bash.inc'

# Xterm display
if [ -z $WSLENV ]; then
    if [ -n $SSH_TTY ]; then
        export DISPLAY=:0
        xrdb -merge .Xresources
        # Turn off Xorg bell notification sound
        # Set repeat rate, xset r rate <delay> <persec>
        xset b off
        xset r rate 400 60
    fi
fi

# Set umask, {owner,group,others}
# 022 = rwx, rx, rx
umask 022

# Add custom go location to path
export PATH=~/.local/bin/go/bin:$PATH

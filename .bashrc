#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


###
# Bash shell options
###

shopt -s histappend
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s dotglob

###
# Bash variables see bash(1) for more details on configuration
###

HISTSIZE=2000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
TERM=xterm-256color

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

set_ps1 () {
    local __PREVIOUS_EXIT_CODE="$?"

    # Colors
    local __GREEN="\\[\\033[01;32m\\]"
    local __BLUE="\\[\\033[01;34m\\]"
    local __RED="\\e[0;31m"
    local __RESET="\\e[0m"

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
    fi

    # Set color of git branch
    if [[ $__CURENT_BRANCH =~ "master" ]]; then
        __GIT_BRANCH="$__RED$__CURENT_BRANCH$__RESET"
    else
        __GIT_BRANCH="$__GREEN$__CURENT_BRANCH$__RESET"
    fi

    PS1="$__EXIT_CODE$__GIT_BRANCH $__USER_AND_HOST:$__WORKING_DIRECTORY$ "

}

PROMPT_COMMAND=set_ps1

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . "$HOME"/.bash_aliases
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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/owen/google-cloud-sdk/path.bash.inc' ]; then . '/home/owen/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/owen/google-cloud-sdk/completion.bash.inc' ]; then . '/home/owen/google-cloud-sdk/completion.bash.inc'; fi

# WSL Display
if [ $SHLVL -eq 1 ] && [ -n "$WSL_DISTRO_NAME" ]; then
    if [ -z "$SSH_TTY" ]; then
        export DISPLAY=:0
        xrdb -merge .Xresources
    fi
fi

# Turn off Xorg bell notification sound
# Set repeat rate, xset r rate <delay> <persec>
if [ -n "$DISPLAY" ]; then
    xset b off
    xset r rate 400 60
fi

# Set umask, {owner,group,others}
# 022 = rwx, rx, rx
umask 022

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
TERM=tmux-256color

set_ps1 () {
    local __PREVIOUS_EXIT_CODE="$?"

    # Colors
    local __GREEN="\\[\\033[01;32m\\]"
    local __BLUE="\\[\\033[01;34m\\]"
    local __RED="\\[\\033[01;31m\\]"
    local __RESET="\\[\\033[0m\\]"

    # Prompt Components
    local __USER="$__GREEN\\u$__RESET"
    local __HOST="$__GREEN\\h$__RESET"
    local __WORKING_DIRECTORY="$__BLUE\\w$__RESET"
    local __EXIT_CODE=""
    local __GIT_BRANCH=""
    local __CURRENT_BRANCH=$(__git_ps1)
    local __VITRUAL_ENV_PROMPT=""
    local __TIME_NOW=$__GREEN$(date +'%H:%M:%S')$__RESET

    if [ ! -z $VIRTUAL_ENV_PROMPT ]; then
        __VITRUAL_ENV_PROMPT="$__GREEN$VIRTUAL_ENV_PROMPT$__RESET"
    fi

    # Set color based on exit code status
    if [ $__PREVIOUS_EXIT_CODE -eq 0 ]; then
        __EXIT_CODE="$__GREEN($__PREVIOUS_EXIT_CODE)$__RESET"
    else
        __EXIT_CODE="$__RED($__PREVIOUS_EXIT_CODE)$__RESET"
    fi

    if ! command -v __git_ps1 &> /dev/null ; then
        . /etc/bash_completion.d/git-prompt
    fi

    # Strip leading/trailing spaces
    if [ ! -z $__CURRENT_BRANCH ]; then
        __CURRENT_BRANCH=$(printf $__CURRENT_BRANCH)
    fi

    # Set color of git branch
    if [[ $__CURRENT_BRANCH =~ (master|main|develop) ]]; then
        __GIT_BRANCH="$__RED$__CURRENT_BRANCH$__RESET"
    else
        __GIT_BRANCH="$__GREEN$__CURRENT_BRANCH$__RESET"
    fi

    PS1="user=${__USER} host=${__HOST} time=${__TIME_NOW} rc=${__EXIT_CODE} branch=${__GIT_BRANCH:=no_git} venv=${__VITRUAL_ENV_PROMPT} pwd=${__WORKING_DIRECTORY}\n$ "

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

# Set umask, {owner,group,others}
# 022 = rwx, rx, rx
umask 022

# Add custom go location to path
export PATH=~/.local/bin/go/bin:$PATH

# Start tmux if not already
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	if ! tmux ls | grep "(attached)"; then
		if ! tmux attach; then
		  tmux new-session -s dev -n shell -d
		  tmux new-window -n vim -c ${HOME}/repos
		  tmux attach -t dev
		fi
	fi
fi

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

if [ "$color_prompt" = yes ]; then
    # Setup PS1 variable
    PS1=''
    # Print last exit status code
    PS1+='($?) '
    # Green user@home
    PS1+='\[\033[01;32m\]\u@\h'
    # White :
    PS1+='\[\033[00m\]:'
    # Blue working directory
    PS1+='\[\033[01;34m\]\w'
    # White $
    PS1+='\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/owen/google-cloud-sdk/path.bash.inc' ]; then . '/home/owen/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/owen/google-cloud-sdk/completion.bash.inc' ]; then . '/home/owen/google-cloud-sdk/completion.bash.inc'; fi

# WSL Display
if [ $SHLVL -eq 1 ]; then
    export DISPLAY=:0
    xrdb -merge .Xresources
fi

# Turn off Xorg bell notification sound
# Set repeat rate, xset r rate <delay> <persec>
if [ -n "$DISPLAY" ]; then
    xset b off
    xset r rate 400 60
fi

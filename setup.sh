#!/bin/bash

# Globals
GIT_DIRECTORY=~/repos/dotfiles
VIMGO_DIR=~/.vim/pack/plugins/start/vim-go
VIMGO_GIT_REPO=https://github.com/fatih/vim-go.git

log () {
    echo "$(date -u) - $1"
}

# Check if git exists
if [ -d "$GIT_DIRECTORY" ]; then
    log "Git repo is present, continuing setup"
else 
    log "Git repo is not present. The dotfiles repo should be cloned to ~/repos/, exiting..."
    exit 1
fi

create_dotfile () {
    local DOTFILE="$HOME/${1}"
    local GIT_DOTFILE=$1

    if [ -L "$DOTFILE" ]; then
        log "$DOTFILE symlink already exists moving on..."
    else
        if [ -f "$DOTFILE" ]; then
            log "removing $DOTFILE"
            rm $DOTFILE
            log "creating symlink for $DOTFILE in git repo"    
            ln -s ${GIT_DIRECTORY}/${GIT_DOTFILE} $DOTFILE 
        elif [ ! -L "$DOTFILE" ]; then
            log "creating symlink for $DOTFILE in git repo"    
            ln -s ${GIT_DIRECTORY}/${GIT_DOTFILE} $DOTFILE 
        fi
    fi

}


# Setup symlinks into home folder

DOTFILES=".bashrc .vimrc .profile .tmux.conf"

for DOTFILE in $DOTFILES; do
    create_dotfile $DOTFILE
done

# Make sure vim plugins are downloaded
if [ -d "$VIMGO_DIR" ]; then
    log "vim-go already exists checking its up-to date"
    git pull $VIMGO_DIR
else
    git clone $VIMGO_GIT_REPO $VIMGO_DIR
    RESULT=$?
    if [ "$RESULT" -gt 0 ]; then
        log "Cloning $VIMGO_GIT_REPO failed. Exiting..."
        exit 1
    else
        log "vim-go cloned successfully from $VIMGO_GIT_REPO"
    fi
fi

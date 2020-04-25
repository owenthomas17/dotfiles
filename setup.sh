#!/bin/bash

# Helper functions

log () {
    echo "$(date -u) - $1"
}

# Globals
GIT_DIRECTORY=~/repos/dotfiles
VIMGO_DIR=~/.vim/pack/plugins/start/vim-go
VIMGO_GIT_REPO=https://github.com/fatih/vim-go.git

# Check if git exists
if [ -d "$GIT_DIRECTORY" ]; then
    log "Git repo is present, continuing setup"
else 
    log "Git repo is not present. The dotfiles repo should be cloned to ~/repos/, exiting..."
    exit 1
fi

# Setup symlinks into home folder

if [ -L ~/.bashrc ]; then
    log "~/.bashrc symlink already exists moving on..."
else
    if [ -f ~/.bashrc ]; then
        log "removing ~/.bashrc"
        rm ~/.bashrc
        log "creating symlink for ~/.bashrc in git repo"    
        ln -s ${GIT_DIRECTORY}/.bashrc ~/.bashrc 
    elif [ ! -L ~/.bashrc ]; then
        log "creating symlink for ~/.bashrc in git repo"    
        ln -s ${GIT_DIRECTORY}/.bashrc ~/.bashrc 
    fi
fi

if [ -L ~/.vimrc ]; then
    log "~/.vimrc symlink already exists moving on..."
else
    if [ -f ~/.vimrc ]; then
        log "removing ~/.vimrc"
        rm ~/.vimrc
        log "creating symlink for ~/.vimrc in git repo"    
        ln -s ${GIT_DIRECTORY}/.vimrc ~/.vimrc 
    elif [ ! -L ~/.vimrc ]; then
        log "creating symlink for ~/.vimrc in git repo"    
        ln -s ${GIT_DIRECTORY}/.vimrc ~/.vimrc
    fi
fi

# Install .profile
if [ -L ~/.profile ]; then
    log "~/.profile symlink already exists moving on..."
else
    if [ -f ~/.profile ]; then
        log "removing ~/.profile"
        rm ~/.profile
        log "creating symlink for ~/.profile in git repo"    
        ln -s ${GIT_DIRECTORY}/.profile ~/.profile 
    elif [ ! -L ~/.profile ]; then
        log "creating symlink for ~/.profile in git repo"    
        ln -s ${GIT_DIRECTORY}/.profile ~/.profile
    fi
fi

# Install .tmux
if [ -L ~/.tmux ]; then
    log "~/.tmux symlink already exists moving on..."
else
    if [ -f ~/.tmux ]; then
        log "removing ~/.tmux"
        rm ~/.tmux
        log "creating symlink for ~/.tmux in git repo"
        ln -s ${GIT_DIRECTORY}/.tmux ~/.tmux
    elif [ ! -L ~/.tmux ]; then
        log "creating symlink for ~/.tmux in git repo"
        ln -s ${GIT_DIRECTORY}/.tmux ~/.tmux
    fi
fi

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


#!/bin/bash

# Helper functions

log () {
    echo "$(date -u) - $1"
}

# Globals
GIT_DIRECTORY=~/repos/dotfiles

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


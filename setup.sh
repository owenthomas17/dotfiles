#!/bin/bash

# Globals
# Directories
GIT_DIRECTORY="${HOME}/repos/dotfiles"

# Git URLs

log () {
    echo "$(date -u) - $1"
}

createDotfile () {
    local DOTFILE="$HOME/${1}"
    local GIT_DOTFILE=$1

    if [ -L "$DOTFILE" ]; then
        log "$DOTFILE symlink already exists moving on..."
    else
        if [ -f "$DOTFILE" ]; then
            log "removing $DOTFILE"
            rm "$DOTFILE"
            log "creating symlink for $DOTFILE in git repo"
            ln -s "${GIT_DIRECTORY}"/"${GIT_DOTFILE}" "$DOTFILE"
        elif [ ! -L "$DOTFILE" ]; then
            log "creating symlink for $DOTFILE in git repo"
            ln -s "${GIT_DIRECTORY}"/"${GIT_DOTFILE}" "$DOTFILE"
        fi
    fi

}


gitDirExists () {
    # Check if git exists
    if [ -d "$GIT_DIRECTORY" ]; then
        log "Git repo is present, continuing setup"
    else
        log "Git repo is not present. The dotfiles repo should be cloned to ~/repos/, exiting..."
        exit 1
    fi
}

createDotfiles () {

    # Setup symlinks into home folder
    DOTFILES=".bashrc .vimrc .profile .tmux.conf .Xresources .dircolors tmux-start.sh"

    for DOTFILE in $DOTFILES; do
       createDotfile "$DOTFILE"
    done

}

installSystemDependencies () {
    sudo apt install python3-pip
}


main () {
    source setup-vim.sh
    installSystemDependencies
    gitDirExists
    createDotfiles
    installLanguageServers
    installVimPlugins
    mkdir -p "$HOME"/.local/bin
}

main

#!/bin/bash

# Globals
# Directories
# Small trick to always resolve the path to where the setup.sh script lives
SOURCE=${BASH_SOURCE[0]}
GIT_DIRECTORY=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
MANAGED_DOTFILES=".bashrc .vimrc .profile .tmux.conf .Xresources .dircolors tmux-start.sh"

# Git URLs

log () {
    echo "$(date -u) - $1"
}

createDotfile () {
    local DOTFILE="$HOME/${1}"
    local GIT_DOTFILE=$1

    # Already a symlink?
    if [ -L "$DOTFILE" ]; then
        log "$DOTFILE symlink already exists moving on..."
	return
    fi

    # Already a regular unmanaged file
    if [ -f "$DOTFILE" ]; then
        log "removing $DOTFILE"
        rm "$DOTFILE"
        log "creating symlink for $DOTFILE in git repo"
        ln -s "${GIT_DIRECTORY}"/"${GIT_DOTFILE}" "$DOTFILE"
	return
    fi

    log "creating symlink for $DOTFILE in git repo"
    ln -s "${GIT_DIRECTORY}"/"${GIT_DOTFILE}" "$DOTFILE"

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
    for DOTFILE in $MANAGED_DOTFILES; do
       createDotfile "$DOTFILE"
    done

}

installSystemDependencies () {
    log "Installing missing system dependencies..."
    if ! command -v pip3 > /dev/null; then
        log "Installing python3-pip because it hasn't been found..."
        sudo apt install python3-pip -y
    fi
    log "pip3 exists, moving on..."

    if [ ! -f /usr/share/bash-completion/bash_completion ]; then
        log "Installing bash-completion because it hasn't been found..."
        sudo apt install bash-completion -y
    fi
    log "bash-completion exists, moving on..."
}

usage () {

    cat <<USAGE

Usage: $0 [-e, --setup-editor Text editor] [-h, --help This menu]

Options:
    -e, --setup-editor:   Valid options: vim,nvim,none. If not specified an interactive menu will be presented to make the choice.
    -h, --help:  This help menu
USAGE
    exit 0
}

processFlags () {
    while [ "$1" != "" ]; do
        case $1 in
        -e | --setup-editor)
            shift
            SETUP_EDITOR=$1
            ;;
        -h | --help)
            usage
        esac
        shift
    done
}

setupEditor() {
    log "Setting up the editor"

    if [[ $SETUP_EDITOR == "vim" ]]; then
        log "Installing $SETUP_EDITOR ..."
        bash setup-vim.sh
        return
    fi

    if [[ $SETUP_EDITOR == "nvim" ]]; then
        log "Installing $SETUP_EDITOR ..."
        bash setup-nvim.sh
        return
    fi

    if [[ $SETUP_EDITOR == "none" ]]; then
        log "Not configuring any editor..."
        return
    fi

    title="Select an editor to configure: "
    prompt="Enter the number of name of editor you'd like to configure: "
    options=("vim" "nvim" "none")

    echo "$title"
    PS3="$prompt "
    select opt in "${options[@]}"; do
        case "$REPLY" in
        1) echo "Installing $opt...";bash setup-vim.sh; break;;
        vim) echo "Installing $opt...";bash setup-vim.sh; break;;
        2) echo "Installing $opt...";bash setup-nvim.sh; break;;
        nvim) echo "Installing $opt...";bash setup-nvim.sh; break;;
        3) echo "Not configuring an editor...";break;;
        none) echo "Not configuring an editor...";break;;
        *) echo "Invalid option. Try another one.";continue;;
        esac
    done

}

main () {
    processFlags $ARGS
    installSystemDependencies
    gitDirExists
    createDotfiles
    setupEditor
    log "Creating local bin directory $HOME/.local/bin"
    mkdir -p "$HOME"/.local/bin
    log "Setup is complete"
}

ARGS=$@
main

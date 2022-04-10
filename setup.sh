#!/bin/bash

# Globals
# Directories
GIT_DIRECTORY="${HOME}/repos/dotfiles"
MANAGED_DOTFILES=".bashrc .vimrc .profile .tmux.conf .Xresources .dircolors tmux-start.sh"

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

setupEditor() {
    log "Setting up the editor"

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
    installSystemDependencies
    gitDirExists
    createDotfiles
    setupEditor
    mkdir -p "$HOME"/.local/bin
    log "Setup is complete"
}

main

#!/bin/bash

# Globals
# Directories
# Small trick to always resolve the path to where the setup.sh script lives
SOURCE=${BASH_SOURCE[0]}
GIT_DIRECTORY=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
declare -A MANAGED_DOTFILES
MANAGED_DOTFILES=(
    [".bashrc"]="$HOME/.bashrc"
    [".vimrc"]="$HOME/.vimrc"
    [".profile"]="$HOME/.profile"
    [".tmux.conf"]="$HOME/.tmux.conf"
    [".Xresources"]="$HOME/.Xresources"
    [".dircolors"]="$HOME/.dircolors"
    ["tmux-start.sh"]="$HOME/tmux-start.sh"
    ["htoprc"]="$HOME/.config/htop/htoprc"
)


# Git URLs

log () {
    echo "$(date -u) - $1"
}

createDotfile () {
    local DOTFILE=$1
    local DOTFILE_PATH=$2
    local DOTFILE_DIR=${DOTFILE_PATH%/*}

    if [ ! -d $DOTFILE_DIR ]; then
        log "Creating dotfile directory $DOTFILE_DIR"
        mkdir -p $DOTFILE_DIR
    fi

    # Already a symlink?
    if [ -L "${DOTFILE_PATH}" ]; then
        log "${DOTFILE_PATH} symlink already exists, moving on..."
	      return
    fi

    # Already a regular unmanaged file
    if [ -f "$DOTFILE_PATH" ]; then
        log "Found an unmanaged dotfile, removing $DOTFILE_PATH"
        rm "$DOTFILE_PATH"
    fi

    log "creating symlink for $DOTFILE in git repo"
    ln -s "${GIT_DIRECTORY}"/"${DOTFILE}" "$DOTFILE_PATH"

}

createDotfiles () {
    # Setup symlinks into home folder
    for d in "${!MANAGED_DOTFILES[@]}"; do
       createDotfile $d ${MANAGED_DOTFILES[$d]}
    done
}

installSystemDependencies () {
    log "Installing missing system dependencies..."
    if ! command -v pip3 > /dev/null; then
        log "Installing python3-pip because it hasn't been found..."
        sudo apt install python3-pip -y
    else
        log "pip3 exists, moving on..."
    fi

    if [ ! -f /usr/share/bash-completion/bash_completion ]; then
        log "Installing bash-completion because it hasn't been found..."
        sudo apt install bash-completion -y
    else
        log "bash-completion exists, moving on..."
    fi

    if ! command -v tmux -V > /dev/null; then
        log "Installing tmux because it hasn't been found..."
        sudo apt install tmux
    else
        log "tmux exists, moving on..."
    fi

    source setup-golang.sh
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

setupLocalBin() {
    local BIN_DIR="${HOME}/.local/bin"
    
    if [[ -d ${BIN_DIR} ]]; then
        log "${BIN_DIR} already exists, moving on..."
        return
    fi 

    log "Creating local bin directory ${BIN_DIR}"
    mkdir -p "${BIN_DIR}"
}

installTerraform() {
    source ./install-terraform.sh
}

main () {
    processFlags $ARGS
    installSystemDependencies
    createDotfiles
    setupEditor
    setupLocalBin
    installTerraform
    log "Setup is complete"
}

ARGS=$@
main

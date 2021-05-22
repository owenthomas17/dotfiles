#!/bin/bash

# Globals
GIT_DIRECTORY="${HOME}/repos/dotfiles"
VIMGO_DIR="${HOME}/.vim/pack/plugins/start/vim-go"
VIMGO_GIT_REPO="git@github.com:fatih/vim-go.git"
VIM_POLYGLOT_DIR="${HOME}/.vim/pack/plugins/start/vim-polyglot"
VIM_POLYGLOT_REPO="https://github.com/sheerun/vim-polyglot"
VIM_ALE_REPO="https://github.com/dense-analysis/ale.git"
VIM_ALE_DIR="${HOME}/.vim/pack/plugins/start/ale"
VIM_GRUVBOX_DIR_REPO="https://github.com/morhetz/gruvbox.git"
VIM_GRUVBOX_DIR="${HOME}/.vim/pack/default/start/gruvbox"

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
            rm $DOTFILE
            log "creating symlink for $DOTFILE in git repo"    
            ln -s ${GIT_DIRECTORY}/${GIT_DOTFILE} $DOTFILE 
        elif [ ! -L "$DOTFILE" ]; then
            log "creating symlink for $DOTFILE in git repo"    
            ln -s ${GIT_DIRECTORY}/${GIT_DOTFILE} $DOTFILE 
        fi
    fi

}

installLanguageServers () {

    which pyls > /dev/null
    PYLS_INSTALLED=$?
    if [ $PYLS_INSTALLED -eq 1 ]; then
        log "Installing python language server"
        pip3 install python-language-server
    else
        log "Python language server already installed"
    fi

    local TMP_TF_DIR=/tmp/terraform-lsp
    which terraform-lsp > /dev/null
    TERRAFORM_LSP_INSTALLED=$?
    if [ $TERRAFORM_LSP_INSTALLED -eq 1 ]; then
        log "Installing Terraform language server"
        mkdir $TMP_TF_DIR
        wget --quiet --directory-prefix $TMP_TF_DIR https://github.com/juliosueiras/terraform-lsp/releases/download/v0.0.12/terraform-lsp_0.0.12_linux_amd64.tar.gz
        tar xfv $TMP_TF_DIR/terraform-lsp_0.0.12_linux_amd64.tar.gz --directory $TMP_TF_DIR
        cp $TMP_TF_DIR/terraform-lsp $HOME/.local/bin
        rm -rf $TMP_TF_DIR
    else
        log "Terraform language server already installed"
    fi

}

installVimPlugins () {
    # Create .vim dir if it doesn't exist
    if [ ! -d ${HOME}/.vim ]; then
        log "${HOME}/.vim directory doesn't exist. Creating it"
        mkdir -p ${HOME}/.vim
    fi

    # Install color scheme
    if [ ! -d ${VIM_GRUVBOX_DIR} ]; then
        log "Installing gruvbox"
        git clone ${VIM_GRUVBOX_DIR_REPO} ${VIM_GRUVBOX_DIR}
    else
        log "gruvbox already installed at ${VIM_GRUVBOX_DIR}"
    fi


    # Install Syntax highlighting
    if [ ! -d ${VIM_POLYGLOT_DIR} ]; then
        log "Installing vim-polyglot"
        git clone --depth 1 ${VIM_POLYGLOT_REPO} ${VIM_POLYGLOT_DIR}
    else
        log "vim-polyglot already installed at ${VIM_POLYGLOT_DIR}"
    fi

    if [ ! -d ${VIM_ALE_DIR} ]; then
        log "Installing vim ale"
        git clone --depth 1 ${VIM_ALE_REPO} ${VIM_ALE_DIR}
    else
        log "Ale already installed at ${VIM_ALE_DIR}"
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
       createDotfile $DOTFILE
    done

}


main () {
    gitDirExists
    createDotfiles
    installLanguageServers
    installVimPlugins
}

main

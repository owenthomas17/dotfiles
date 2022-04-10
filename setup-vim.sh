#!/bin/bash

VIM_POLYGLOT_DIR="${HOME}/.vim/pack/plugins/start/vim-polyglot"
VIM_ALE_DIR="${HOME}/.vim/pack/plugins/start/ale"
VIM_GRUVBOX_DIR="${HOME}/.vim/pack/default/start/gruvbox"

# Git URLs
VIM_POLYGLOT_REPO="https://github.com/sheerun/vim-polyglot"
VIM_ALE_REPO="https://github.com/dense-analysis/ale.git"
VIM_GRUVBOX_DIR_REPO="https://github.com/morhetz/gruvbox.git"

log () {
    echo "$(date -u) - $1"
}

installLanguageServers () {

    command -v pyls > /dev/null
    PYLS_INSTALLED=$?
    if [ $PYLS_INSTALLED -eq 1 ]; then
        log "Installing python language server"
        pip3 install python-language-server
    else
        log "Python language server already installed"
    fi

    local TMP_TF_DIR=/tmp/terraform-lsp
    command -v terraform-lsp > /dev/null
    TERRAFORM_LSP_INSTALLED=$?
    if [ $TERRAFORM_LSP_INSTALLED -eq 1 ]; then
        log "Installing Terraform language server"
        mkdir $TMP_TF_DIR
        wget --quiet --directory-prefix $TMP_TF_DIR https://github.com/juliosueiras/terraform-lsp/releases/download/v0.0.12/terraform-lsp_0.0.12_linux_amd64.tar.gz
        tar xfv $TMP_TF_DIR/terraform-lsp_0.0.12_linux_amd64.tar.gz --directory $TMP_TF_DIR
        cp "$TMP_TF_DIR"/terraform-lsp "$HOME"/.local/bin
        rm -rf $TMP_TF_DIR
    else
        log "Terraform language server already installed"
    fi

}

installVimPlugins () {
    # Create .vim dir if it doesn't exist
    if [ ! -d "${HOME}"/.vim ]; then
        log "${HOME}/.vim directory doesn't exist. Creating it"
        mkdir -p "${HOME}"/.vim
    fi

    # Install color scheme
    if [ ! -d "${VIM_GRUVBOX_DIR}" ]; then
        log "Installing gruvbox"
        git clone "${VIM_GRUVBOX_DIR_REPO}" "${VIM_GRUVBOX_DIR}"
    else
        log "gruvbox already installed at ${VIM_GRUVBOX_DIR}"
    fi


    # Install Syntax highlighting
    if [ ! -d "${VIM_POLYGLOT_DIR}" ]; then
        log "Installing vim-polyglot"
        git clone --depth 1 "${VIM_POLYGLOT_REPO}" "${VIM_POLYGLOT_DIR}"
    else
        log "vim-polyglot already installed at ${VIM_POLYGLOT_DIR}"
    fi

    if [ ! -d "${VIM_ALE_DIR}" ]; then
        log "Installing vim ale"
        git clone --depth 1 "${VIM_ALE_REPO}" "${VIM_ALE_DIR}"
    else
        log "Ale already installed at ${VIM_ALE_DIR}"
    fi

}

main () {
    installLanguageServers
    installVimPlugins
}

main

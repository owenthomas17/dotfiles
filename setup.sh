#!/bin/bash

# Globals
GIT_DIRECTORY="${HOME}/repos/dotfiles"
VIMGO_DIR="${HOME}/.vim/pack/plugins/start/vim-go"
COC_DIR="${HOME}/.vim/pack/coc/start/coc.nvim-release"
COC_RELEASE_REPO="https://github.com/neoclide/coc.nvim/archive/release.tar.gz"

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

installVimPlugins () {

    # Make sure vim plugins are downloaded
    if [ -d "$VIMGO_DIR" ]; then
        log "vim-go already exists checking it's up to date in dir: ${VIMGO_DIR}"
        git -C ${VIMGO_DIR} pull --allow-unrelated-histories --quiet
    else
        log "vim-go doesn't exist in '${VIMGO_DIR}', git cloning"
        git clone ${VIMGO_GIT_REPO} ${VIMGO_DIR} --quiet
        RESULT=$?
        if [ "$RESULT" -gt 0 ]; then
            log "Cloning $VIMGO_GIT_REPO failed. Exiting..."
            exit 1
        else
            log "vim-go cloned successfully from $VIMGO_GIT_REPO"
        fi
    fi

    if [ -d "$COC_DIR" ]; then
        log "coc vim directory already exists, checking it's up to date in dir: ${COC_DIR}"
        cd $COC_DIR
        curl --fail -L ${COC_RELEASE_REPO} | tar xzfv -
        cd ${GIT_DIRECTORY}
    else
        log "coc vim doesn't exist in '${COC_DIR}', git cloning"
        cd $COC_DIR
        curl --fail -L ${COC_RELEASE_REPO} | tar xzfv -
        RESULT=$?
        if [ "$RESULT" -gt 0 ]; then
            log "Downloading $COC_RELEASE_REPO failed. Exiting..."
            exit 1
        else
            log "coc downloaded successfully from $COC_RELEASE_REPO"
        fi
        cd ${GIT_DIRECTORY}
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
    DOTFILES=".bashrc .vimrc .profile .tmux.conf .Xresources .dircolors"

    for DOTFILE in $DOTFILES; do
       createDotfile $DOTFILE
    done

}


main () {
    gitDirExists
    createDotfiles
    installVimPlugins
}

main

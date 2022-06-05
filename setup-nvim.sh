#!/bin/bash

NVIM_VERSION="v0.7.0"
NVIM_DEBIAN_PACKAGE_LINK="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.deb"
NVIM_DEBIAN_PACKAGE_SHA_LINK="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.deb.sha256sum"
NVIM_DEBIAN_PACKAGE_FILEPATH="/tmp/nvim-linux64.deb"
NVIM_DEBIAN_PACKAGE_SHA_FILEPATH="/tmp/nvim-linux64.deb.sha256sum"
NVIM_CONFIG_DIRECTORY="${HOME}/.config/nvim"
NVIM_CONFIG_FILE_PATH="${HOME}/.config/nvim/init.lua"

log () {
    echo "$(date -u) - $1"
}

downloadNvim() {
	local WORKDIR=$(pwd)
	log "Downloading nvim debian package..."
	wget -O "${NVIM_DEBIAN_PACKAGE_FILEPATH}" --quiet "${NVIM_DEBIAN_PACKAGE_LINK}"

	log "Downloading nvim debian package sha256..."
	wget -O "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}" --quiet "${NVIM_DEBIAN_PACKAGE_SHA_LINK}"

	log "Validating sha256..."
	cd /tmp
	sha256sum -c "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}" || log "Checksum failed, please try re-downloading the file"; exit 1
	cd "${WORKDIR}"
	log "sha256 validated and correct..."
}

cleanupFiles() {
    log "Removing all temporary files"
    for file in "${NVIM_DEBIAN_PACKAGE_FILEPATH}" "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}"; do
	    log "Removing ${file}"
	    rm -rf "${file}"
    done
}

installNvim() {
    log "Installing nvim from debian package"
    sudo apt-get -qq install "${NVIM_DEBIAN_PACKAGE_FILEPATH}"
    log "Installed nvim correctly"
    cleanupFiles
}

installDotfile() {
    local DOTFILE="$HOME/.config/nvim/init.lua"
    local GIT_DOTFILE="init.lua"
    local GIT_DIRECTORY=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

    log "Creating symlink for dotfile if needed"

    # Already a symlink?
    if [ -L "$DOTFILE" ]; then
        log "$DOTFILE symlink already exists, moving on..."
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

detectPreviousInstall() {
    local CURRENT_NVIM_VERSION=$(nvim -v | head -n1 | awk '{print $2}')

    if [[ $? -gt 0 ]]; then
	log "Nvim installation not found. Proceeding to install..."
	return 1
    fi

    if [[ $CURRENT_NVIM_VERSION != $NVIM_VERSION ]]; then
	log "Nvim doesn't match desired version"
	return 1
    fi

    log "Skipping new nvim installation because nvim has been detected as already installed, and at the desired version: ${NVIM_VERSION}"
    return 0
}

main () {
    if ! detectPreviousInstall; then
	downloadNvim
	installNvim
    fi

    installDotfile
}

main

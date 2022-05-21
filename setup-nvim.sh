#!/bin/bash

NVIM_DEBIAN_PACKAGE_LINK="https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb"
NVIM_DEBIAN_PACKAGE_SHA_LINK="https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb.sha256sum"
NVIM_DEBIAN_PACKAGE_FILEPATH="/tmp/nvim-linux64.deb"
NVIM_DEBIAN_PACKAGE_SHA_FILEPATH="/tmp/nvim-linux64.deb.sha256sum"

log () {
    echo "$(date -u) - $1"
}

downloadNvim() {
	log "Downloading nvim debian package..."
	wget -O "${NVIM_DEBIAN_PACKAGE_FILEPATH}" --quiet "${NVIM_DEBIAN_PACKAGE_LINK}"

	log "Downloading nvim debian package sha256..."
	wget -O "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}" --quiet "${NVIM_DEBIAN_PACKAGE_SHA_LINK}"

	log "Validating sha256..."
	cd /tmp
	sha256sum -c "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}"
	if [[ $? -gt 0 ]]; then
	    log "Checksum failed, please try re-downloading the file"
	    exit 1
	fi
	cd -
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
}

main () {
    downloadNvim
    installNvim
    cleanupFiles
}

main

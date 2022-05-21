#!/bin/bash


NVIM_DEBIAN_PACKAGE_LINK="https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb"
NVIM_DEBIAN_PACKAGE_SHA_LINK="https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb.sha256sum"

log () {
    echo "$(date -u) - $1"
}

downloadNvim() {
	log "Downloading nvim debian package..."
	wget -O /tmp/nvim-linux64.deb --quiet "${NVIM_DEBIAN_PACKAGE_LINK}"

	log "Downloading nvim debian package sha256..."
	wget -O /tmp/nvim-linux64.deb.sha256sum --quiet "${NVIM_DEBIAN_PACKAGE_SHA_LINK}"

	log "Validating sha256..."
	cd /tmp
	sha256sum -c /tmp/nvim-linux64.deb.sha256sum
	if [[ $? -gt 0 ]]; then
	    log "Checksum failed, please try re-downloading the file"
	    exit 1
	fi
	cd -
	log "sha256 validated and correct..."
}

main () {
    downloadNvim
}

main

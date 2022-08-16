#!/bin/bash

NVIM_VERSION="v0.7.2"
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
	sha256sum -c "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}"

        if [[ $? -gt 0 ]]; then
            log "Checksum failed, please try re-downloading the file..."
            exit 1
        fi

	cd "${WORKDIR}"
	log "sha256 validated and correct..."
}

cleanupFiles() {
    log "Removing all temporary files"
    for file in "${NVIM_DEBIAN_PACKAGE_FILEPATH}" "${NVIM_DEBIAN_PACKAGE_SHA_FILEPATH}"; do
	    log "Removing ${file} ..."
	    rm -rf "${file}"
    done
}

installNvim() {
    log "Installing nvim from debian package..."
    sudo apt-get -qq install "${NVIM_DEBIAN_PACKAGE_FILEPATH}"
    log "Installed nvim correctly"
    cleanupFiles
}

installDotfile() {
    local DOTFILE="$HOME/.config/nvim/init.lua"
    local GIT_DOTFILE="init.lua"
    local GIT_DIRECTORY=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

    log "Making nvim config directory if it doesn't already exist: ${HOME}/.config/nvim..."

    mkdir -p "${HOME}/.config/nvim"

    log "Creating symlink for dotfile if needed..."

    # Already a symlink?
    if [ -L "${DOTFILE}" ]; then
        log "${DOTFILE} symlink already exists, moving on..."
	return
    fi

    # Already a regular unmanaged file
    if [ -f "${DOTFILE}" ]; then
        log "removing $DOTFILE ..."
        rm "${DOTFILE}"
        log "Creating symlink for $DOTFILE in git repo..."
        ln -s "${GIT_DIRECTORY}/${GIT_DOTFILE}" "$DOTFILE"
	return
    fi

    log "Creating symlink for $DOTFILE in git repo..."
    ln -s "${GIT_DIRECTORY}"/"${GIT_DOTFILE}" "$DOTFILE"

    log "Copying lua modules directory..."
    cp -rf lua/ "${HOME}/.config/nvim"
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

installWin32Yank() {
	mkdir /tmp/win32yank-dl
	log "Downloading and unzipping win32yank to /tmp/win32yank-dl ..."
	curl --silent -fLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
	unzip -d /tmp/win32yank-dl /tmp/win32yank.zip
	chmod +x /tmp/win32yank-dl/win32yank.exe

	log "Copying win32yank.exe to ${HOME}/.local/bin/win32yank.exe..."
	cp -f /tmp/win32yank-dl/win32yank.exe "${HOME}/.local/bin/win32yank.exe"

	log "Cleaning up /tmp/win32yank-dl"
	rm -rf /tmp/win32yank-dl
}

installPlugins() {
	log "Downloading vim-plug..."
	curl --silent -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	if grep WSL2 /proc/version; then
		log "Detected running in WSL2..."
		installWin32Yank
	fi

	log "Installing plugins..."
	# Go dependency required for nvim-dap, install go's debugger: Delve
	go install github.com/go-delve/delve/cmd/dlv@latest

	# Get nvim to install all of its plugins
	# sourced from: https://github.com/junegunn/vim-plug/issues/675
	nvim --headless --noplugin -u lua/plugins/init.lua +PlugInstall +qa
}

main () {
    if ! detectPreviousInstall; then
        downloadNvim
        installNvim
    fi

    installDotfile
    installPlugins

    log "Installation complete..."
}

main

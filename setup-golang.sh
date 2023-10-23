#!/bin/bash

GO_VERSION=1.21.3
GO_VERSION_CHECKSUM="1241381b2843fae5a9707eec1f8fb2ef94d827990582c7c7c32f5bdfbfd420c8"

GO_VERSION_EXPECTED="go${GO_VERSION}"

log () {
    echo "$(date -u) - $1"
}

downloadGolang() {
	local attempt=${1:-1}

	if [[ attempt -gt 3 ]]; then
		log "Failed download 3 times, aborting install.."
		exit 1
	fi

	log "Attempting to download golang tarball. Attempt number: ${attempt}"

	wget "https://go.dev/dl/${GO_VERSION_EXPECTED}.linux-amd64.tar.gz"
	echo "${GO_VERSION_CHECKSUM} /tmp/${GO_VERSION_EXPECTED}.linux-amd64.tar.gz" | sha256sum --check --status

	if [[ $? -gt 0 ]]; then
		log "Checksums didn't match retrying download"
		rm -v "/tmp/${GO_VERSION_EXPECTED}.linux-amd64.tar.gz"
		attempt=$((attempt+1))
		downloadGolang $attempt
	fi

}

installGolang() {
	cd /tmp

	downloadGolang

	tar xfv "${GO_VERSION_EXPECTED}.linux-amd64.tar.gz"

	sudo chown -R root:root go/
	sudo mv go /usr/local

	cd -

}

	

detectPreviousInstall() {
	local current_version=$(go version | awk '{print $3}')

	if [[ $? -gt 0 ]]; then
		log "No previous golang install detected"
		return 0
	fi

	if [[ $current_version != $GO_VERSION_EXPECTED ]]; then
		log "Detected a previous install, but expected version is different from installed version, attempting re-install"
		sudo rm -rfv /usr/local/go
		return 1
	fi

	log "Found an installed version and is at the version expected (${GO_VERSION})"
	return 0

}

main() {
	if ! detectPreviousInstall; then
		installGolang
		return
	fi

	log "Finished $0"

}

main

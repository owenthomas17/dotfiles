#!/bin/bash
set -e 

TERRAFORM_VERSION=1.6.2

echo ########
echo Installing terraform
echo ########

cd /tmp

if ! wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"; then
	echo "Failed to download terraform"
	exit 1
fi

unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform ~/.local/bin/
chmod +x  ~/.local/bin/terraform
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

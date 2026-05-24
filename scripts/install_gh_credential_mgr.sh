#!/usr/bin/env bash
set -Eeuo pipefail

# https://github.com/git-ecosystem/git-credential-manager/releases
VERSION="2.8.0"
PACKAGE="gcm-linux-x64-${VERSION}.deb"
URL="https://github.com/git-ecosystem/git-credential-manager/releases/download/v${VERSION}/${PACKAGE}"

if [ $# -eq 1 ] && [ "$1" = "delete" ]; then
    sudo apt-get remove -y gcm
    rm -f "/tmp/${PACKAGE}"
    exit 0
fi

# Check if already installed
if command -v git-credential-manager &> /dev/null; then
    echo "Git Credential Manager already installed"
    exit 0
fi

# Download and install
curl -sSLo "/tmp/${PACKAGE}" "${URL}"
sudo dpkg -i "/tmp/${PACKAGE}"
rm -f "/tmp/${PACKAGE}"

# Configure git to use GCM
git-credential-manager configure

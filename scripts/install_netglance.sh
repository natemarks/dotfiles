#!/usr/bin/env bash
set -Eeuo pipefail

# https://github.com/natemarks/netglance/releases/download/v0.0.5/netglance-0.0.5-linux-x86_64
VERSION="0.0.5"
EXECUTABLE="netglance"
BINARY="${EXECUTABLE}-${VERSION}-linux-x86_64"
URL="https://github.com/natemarks/netglance/releases/download/v${VERSION}/${BINARY}"

INSTALL_DIR="${HOME}/bin"
INSTALL_PATH="${INSTALL_DIR}/${EXECUTABLE}"

mkdir -p "${INSTALL_DIR}"

# Always overwrite with latest version
echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${INSTALL_PATH}"
chmod +x "${INSTALL_PATH}"

echo "Installed ${EXECUTABLE} ${VERSION} to ${INSTALL_PATH}"

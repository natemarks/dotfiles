#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="1.0.1"
TARBALL="secret-hoard_v${VERSION}_linux_amd64.tar.gz"
URL="https://github.com/natemarks/secret-hoard/releases/download/v${VERSION}/${TARBALL}"
DOWNLOAD_DIR="$(mktemp -d -t secret-hoard.XXXXXX)"
TARBALL_PATH="${DOWNLOAD_DIR}/${TARBALL}"

# Download the tarball
curl -sSLo "${TARBALL_PATH}" "${URL}"

# Extract to temporary directory
tar -xzf "${TARBALL_PATH}" -C "${DOWNLOAD_DIR}"

# Run the install script from the extracted directory
"${DOWNLOAD_DIR}/install.sh"

# Cleanup
rm -rf "${DOWNLOAD_DIR}"

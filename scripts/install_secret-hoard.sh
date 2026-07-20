#!/usr/bin/env bash
set -Eeuo pipefail

# Get the latest version from GitHub API (e.g., "v1.1.3")
TAG=$(curl -sSL --http1.1 https://api.github.com/repos/natemarks/secret-hoard/releases/latest | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name"[^"]*"(v[0-9.]+)".*/\1/')

if [[ -z "${TAG}" ]]; then
    echo "Error: Failed to fetch latest version from GitHub"
    exit 1
fi

echo "Installing secret-hoard version ${TAG}..."

TARBALL="secret-hoard_${TAG}_linux_amd64.tar.gz"
URL="https://github.com/natemarks/secret-hoard/releases/download/${TAG}/${TARBALL}"
DOWNLOAD_DIR="$(mktemp -d -t secret-hoard.XXXXXX)"
TARBALL_PATH="${DOWNLOAD_DIR}/${TARBALL}"
INSTALL_DIR="${HOME}/bin"

# Create bin directory if it doesn't exist
mkdir -p "${INSTALL_DIR}"

# Download the tarball
curl -sSLo "${TARBALL_PATH}" --http1.1 "${URL}"

# Extract to temporary directory
tar -xzf "${TARBALL_PATH}" -C "${DOWNLOAD_DIR}"

# Install all sh-* binaries to $HOME/bin (overwrite if exists)
BINARIES=(sh-contents sh-push sh-generate sh-pull)
INSTALLED_COUNT=0

for binary in "${BINARIES[@]}"; do
    if [[ -f "${DOWNLOAD_DIR}/${binary}" ]]; then
        cp -f "${DOWNLOAD_DIR}/${binary}" "${INSTALL_DIR}/${binary}"
        chmod +x "${INSTALL_DIR}/${binary}"
        echo "Installed ${binary} to ${INSTALL_DIR}/${binary}"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    fi
done

if [[ ${INSTALLED_COUNT} -eq 0 ]]; then
    echo "Error: No secret-hoard binaries found in tarball"
    rm -rf "${DOWNLOAD_DIR}"
    exit 1
fi

# Cleanup
rm -rf "${DOWNLOAD_DIR}"

echo "Installation complete!"

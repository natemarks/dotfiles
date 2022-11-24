#!/usr/bin/env bash
set -Eeuo pipefail

if command -v nvim; then
  exit 0
fi

NVIM_VERSION=0.7.2
NVIM_INSTALLER=nvim-linux64.deb
NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_INSTALLER}"

curl -o "${NVIM_INSTALLER}" -L "${NVIM_URL}" && sudo dpkg -i "${NVIM_INSTALLER}"
rm "${NVIM_INSTALLER}"

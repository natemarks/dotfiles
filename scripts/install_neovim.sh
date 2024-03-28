#!/usr/bin/env bash
set -Eeuo pipefail

if command -v nvim &> /dev/null; then
  echo "Neovim is already installed"
  exit 0
fi
NVIM_VERSION=0.9.5
NVIM_TARBALL="nvim-linux64.tar.gz"

# https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
TARBALL_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_TARBALL}"
SHA256SUM_URL="${TARBALL_URL}.sha256sum"

curl -JLO "${SHA256SUM_URL}"
curl -JLO "${TARBALL_URL}"

if sha256sum -c "${NVIM_TARBALL}.sha256sum"; then
  tar xzvf "${NVIM_TARBALL}"
  sudo cp -r nvim-linux64/bin/* /usr/local/bin/
  sudo cp -r nvim-linux64/lib/* /usr/local/lib/
  sudo cp -r nvim-linux64/lib/* /usr/local/lib/
  sudo cp -r nvim-linux64/man/* /usr/local/share/man/
  sudo ln -s /usr/local/bin/nvim /usr/local/bin/vim
  rm -rf nvim-linux64 "${NVIM_TARBALL}" "${NVIM_TARBALL}.sha256sum"
else
  echo "Checksum failed"
  exit 1
fi
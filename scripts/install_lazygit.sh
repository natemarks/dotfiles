#!/usr/bin/env bash
set -Eeuo pipefail
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-35.]+')

if [ ! -f "${HOME}/bin/lazygit" ] ; then


  curl -Lo "${HOME}/bin/${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
  "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

  tar xf "${HOME}/bin/${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -C "${HOME}/bin" lazygit
fi

#!/usr/bin/env bash
set -Eeuo pipefail

curl -fsSL https://raw.githubusercontent.com/natemarks/secret-hoard/main/scripts/install.sh \
  | bash -s -- v1.1.5 "$HOME/bin"

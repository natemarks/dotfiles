#!/usr/bin/env bash
export PATH="${HOME}/.local/bin":$PATH
powerline-daemon -q
# shellcheck disable=SC2034
POWERLINE_BASH_CONTINUATION=1
# shellcheck disable=SC2034
POWERLINE_BASH_SELECT=1

# locate the powerline bash source file with this
# find ~ -type f -name powerline.sh | grep 'bash/powerline.sh'
# shellcheck disable=SC1091
. "${HOME}/.local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh"
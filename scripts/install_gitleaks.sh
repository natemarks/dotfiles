#!/usr/bin/env bash
set -Eeuo pipefail

# https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz
VERSION="8.30.1"
EXECUTABLE="gitleaks"
TARBALL="${EXECUTABLE}_${VERSION}_linux_x64.tar.gz"
URL="https://github.com/gitleaks/gitleaks/releases/download/v${VERSION}/${TARBALL}"

if [ $# -eq 1 ] && [ "$1" = "delete" ]; then
    rm -f "${HOME}/bin/${EXECUTABLE}"
fi

# Always overwrite - remove existing binary first
rm -f "${HOME}/bin/${EXECUTABLE}"

curl -sSLo "${HOME}/bin/${TARBALL}" "${URL}"

tar xf "${HOME}/bin/${TARBALL}" -C "${HOME}/bin" "${EXECUTABLE}"
rm -f "${HOME}/bin/${TARBALL}"

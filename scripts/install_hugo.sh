#!/usr/bin/env bash
set -Eeuo pipefail
# https://github.com/gohugoio/hugo/releases/download/v0.157.0/hugo_0.157.0_linux-amd64.tar.gz
HUGO_VERSION="0.157.0"
TARBALL="hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${TARBALL}"
echo "URL: ${URL}"
curl -JLO "${URL}"
tar -xvf "${TARBALL}" -C "${HOME}/bin" hugo
rm -r "${TARBALL}"

#!/usr/bin/env bash
set -Eeuo pipefail

# Always installs the latest release, overwriting any existing binary.
# https://github.com/betterleaks/betterleaks/releases/download/v1.9.0/betterleaks_1.9.0_linux_x64.tar.gz
REPO="betterleaks/betterleaks"
EXECUTABLE="betterleaks"
BIN_DIR="${HOME}/bin"

if [ $# -eq 1 ] && [ "$1" = "delete" ]; then
    rm -f "${BIN_DIR}/${EXECUTABLE}"
    exit 0
fi

# /releases/latest redirects to /releases/tag/vX.Y.Z
LATEST_URL="$(curl -sSLo /dev/null -w '%{url_effective}' "https://github.com/${REPO}/releases/latest")"
TAG="${LATEST_URL##*/}"
VERSION="${TAG#v}"
TARBALL="${EXECUTABLE}_${VERSION}_linux_x64.tar.gz"
URL="https://github.com/${REPO}/releases/download/${TAG}/${TARBALL}"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

curl -sSLo "${TMPDIR}/${TARBALL}" "${URL}"
curl -sSLo "${TMPDIR}/checksums.txt" "https://github.com/${REPO}/releases/download/${TAG}/checksums.txt"
(cd "${TMPDIR}" && grep -F " ${TARBALL}" checksums.txt | sha256sum -c -)

mkdir -p "${BIN_DIR}"
tar xf "${TMPDIR}/${TARBALL}" -C "${TMPDIR}" "${EXECUTABLE}"
install -m 0755 "${TMPDIR}/${EXECUTABLE}" "${BIN_DIR}/${EXECUTABLE}"
echo "Installed ${EXECUTABLE} ${VERSION} to ${BIN_DIR}/${EXECUTABLE}"

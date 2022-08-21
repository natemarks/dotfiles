#!/usr.bin/env bash
set -Eeuo pipefail

GO_VERSION="1.18.5"

mkdir -p ~/bin/go/"${GO_VERSION}"
curl -L  "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
--output ~/bin/go/${GO_VERSION}/go${GO_VERSION}.linux-amd64.tar.gz

tar -xzvf ~/bin/go/${GO_VERSION}/go${GO_VERSION}.linux-amd64.tar.gz \
--directory ~/bin/go/"${GO_VERSION}"
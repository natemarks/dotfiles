#!/usr.bin/env bash
set -xv
INSTALLER=~/Downloads/vscode.deb
rm -f "$INSTALLER"
# curl -o "$INSTALLER" -L http://go.microsoft.com/fwlink/?LinkID=760868 && sudo dpkg -i "$INSTALLER"
curl -o "$INSTALLER" -L http://go.microsoft.com/fwlink/?LinkID=760868

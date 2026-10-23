#!/usr/bin/env bash
set -Eeuo pipefail

# Define the source and destination paths
SRC_DIR="${HOME}"
BACKUP_DIR="${HOME}/backup_dir"
BACKUP_DEST="${BACKUP_DIR}/backup.tar.gz"

# Skip any single file larger than this (find -size syntax)
MAX_FILE_SIZE="1G"

# NOTE: ~/.claude is intentionally NOT excluded - it must be backed up.
# Directories to exclude (relative to SRC_DIR). Add or remove lines to manage.
EXCLUDES=(
    "./backup_dir"
    "./.cache"
    "./Desktop"
    "./Downloads"
    "./tmp"
    "./.zoom"              # 31G - Zoom recordings/cache
    "./bashrc.d"           # dotfiles - managed in git
    "./bin"                # symlinks to dotfiles repo + reinstallable binaries
    "./.npm"               # 2.3G - npm cache (regenerable)
    "./.npm-global"        # 4.2G - global npm packages (reinstallable)
    "./.pyenv"             # 1.8G - Python versions (reinstallable)
    "./.rustup"            # 1.5G - Rust toolchains (reinstallable)
    "./.vscode"            # 1.3G - VS Code cache/extensions (restorable)
    "./snap"               # 271M - snap packages (reinstallable)
    "./.cargo"             # 51M - Cargo cache (regenerable)
    "./.fonts"             # 205M - fonts (reinstallable)
    "./.opencode"          # 197M - OpenCode cache
    "./.snowsql"           # 70M - SnowSQL cache
    "./.anyconnect_downloads"  # 90M - Cisco downloads
    "./.onguard_downloads"     # 72M - OnGuard downloads
    "./.clearpass-onguard"     # 50M - ClearPass cache
    "./.lansweeper_downloads"  # 32M - Lansweeper downloads
    "./.crowdstrike_downloads" # 27M - CrowdStrike downloads
    "./.cisco"             # 97M - Cisco cache
    "./.bun"               # 35M - Bun runtime (reinstallable)
    "./go"                 # 11G - Go packages/cache (regenerable with go.mod)
    "./.idea"              # 36K - IntelliJ IDEA cache (regenerated)
    "./.copilot"           # 8.0K - GitHub Copilot cache (regenerated)
    "./.ipython"           # 84K - IPython cache (regenerated)
    "./.nv"                # 704K - NVIDIA cache (regenerated)
    "./.java"              # 1.1M - Java cache (regenerated)
    "./.cookiecutters"     # 2.5M - Cookiecutter templates (reinstallable)
    "./.cookiecutter_replay" # 24K - Cookiecutter replay files
    "./.ansible"           # 1.8M - Ansible cache (regenerated)
    "./.terraform.d"       # 24K - Terraform plugins (reinstallable)
    "./.android"           # 4.0K - Android SDK cache (regenerated)
    "./.augmentcode"       # 4.0K - Augment Code cache (regenerated)
    "./.augment"           # 12K - Augment cache (regenerated)
    "./.idlerc"            # 4.0K - Python IDLE config (regenerated)
    "./.dbus"              # 16K - D-Bus cache (regenerated)
    "./.gphoto"            # 4.0K - gPhoto cache (regenerated)
    "./.redhat"            # 8.0K - Red Hat cache (regenerated)
    "./.dotnet"            # 252K - .NET cache (regenerated)
    "./.cdk"               # 312K - AWS CDK cache (regenerated)
    "./.confluent"         # 20K - Confluent cache (regenerated)
    "./.obsidian"          # 1.7M - Obsidian cache (regenerated)
    "./.gnome"             # 28K - GNOME cache (regenerated)
    "./.lacework"          # 8.0K - Lacework cache (regenerated)
    "./.IdentityService"   # 4.0K - Identity Service cache (regenerated)
    "./.keras"             # 8.0K - Keras cache (regenerated)
    "./.stayback"          # 4.0K - Stayback cache (regenerated)
    "./.gk"                # 192K - GitKraken cache (regenerated)
    # Regenerable/huge parts of .config and .local (the rest is kept)
    "./.config/google-chrome"   # 2.7G - Chrome profile/cache
    "./.config/Code"            # 837M - VS Code cache/state
    "./.config/JetBrains"       # 938M - JetBrains IDE config/cache
    "./.config/Slack"           # 155M - Slack cache
    "./.local/share/JetBrains"  # 21G - JetBrains caches
    "./.local/share/mise"       # 1.5G - mise-managed toolchains (reinstallable)
    "./.local/share/pyppeteer"  # 300M - downloaded Chromium
    "./.local/share/pyapp"      # 295M - pyapp installs (reinstallable)
    "./.local/share/uv"         # 91M - uv cache/pythons
    "./.local/share/virtualenv" # 16M - virtualenv seed cache
    "./.local/share/nvim.backup" # 490M - old neovim data
    "./.local/share/Trash"      # trash
    "./.local/state/nvim"       # 102G - neovim logs/swap/undo
    "./.local/lib"              # 45M - reinstallable
    "./.local/bin"              # 87M - reinstallable binaries
)

# -------------------------------------------------------------
# Script Logic (Do not modify below this line)
# -------------------------------------------------------------

mkdir -p "$BACKUP_DIR"
cd "$SRC_DIR"

# Write to a temp file so a failed run never clobbers the previous backup
TMP_DEST="$(mktemp "${BACKUP_DEST}.XXXXXX")"
SKIP_LIST="$(mktemp)"
trap 'rm -f "$TMP_DEST" "$SKIP_LIST"' EXIT

# Build tar exclude args and the matching find prune expression
TAR_ARGS=(--no-wildcards)
FIND_PRUNE=()
for item in "${EXCLUDES[@]}"; do
    TAR_ARGS+=("--exclude=${item}")
    FIND_PRUNE+=(-path "$item" -o)
done
unset 'FIND_PRUNE[-1]'

# Find individual files over MAX_FILE_SIZE (outside the excluded dirs) and skip them too
find . -xdev \( "${FIND_PRUNE[@]}" \) -prune -o -type f -size "+${MAX_FILE_SIZE}" -print > "$SKIP_LIST"
if [ -s "$SKIP_LIST" ]; then
    echo "Skipping files larger than ${MAX_FILE_SIZE}:" >&2
    sed 's/^/  /' "$SKIP_LIST" >&2
fi
TAR_ARGS+=("--exclude-from=${SKIP_LIST}")

# tar exits 1 when files change while being read (normal for a live home dir)
rc=0
tar "${TAR_ARGS[@]}" -czf "$TMP_DEST" -C "$SRC_DIR" . || rc=$?
if [ "$rc" -gt 1 ]; then
    echo "ERROR: tar failed with exit code ${rc}; previous backup left untouched" >&2
    exit "$rc"
fi
[ "$rc" -eq 1 ] && echo "WARNING: some files changed while being archived" >&2

mv -f "$TMP_DEST" "$BACKUP_DEST"
echo "Backup written to ${BACKUP_DEST} ($(du -h "$BACKUP_DEST" | cut -f1))"

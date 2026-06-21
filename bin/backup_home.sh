#!/usr/bin/env bash

# Define the source and destination paths
SRC_DIR="/home/nmarks"
BACKUP_DEST="/home/nmarks/backup_dir/backup.tar.gz"

# List directories to exclude (relative to the SRC_DIR)
# Simply add or remove lines here to manage exclusions
EXCLUDES=(
    "./backup_dir"
    "./.cache"
    "./.local"             # 95G - Application data (mostly JetBrains cache, regenerable)
    "./.config"            # 5.6G - Application configs (regenerable)
    "./Desktop"
    "./Downloads"
    "./tmp"
    "./.zoom"              # 31G - Zoom recordings/cache
    "./bashrc.d"           # dotfiles - managed in git
    "./bin"                # 6.1G - managed in dotfiles project
    "./.npm"               # 2.3G - npm cache (regenerable)
    "./.npm-global"        # 4.2G - global npm packages (reinstallable)
    "./.pyenv"             # 1.8G - Python versions (reinstallable)
    "./.rustup"            # 1.5G - Rust toolchains (reinstallable)
    "./.mozilla"           # 1.2G - Firefox cache/profiles
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
    "./.docker"            # 2.5M - Docker config (regenerated)
    "./.azure"             # 176K - Azure CLI cache (regenerated)
    "./.cookiecutters"     # 2.5M - Cookiecutter templates (reinstallable)
    "./.cookiecutter_replay" # 24K - Cookiecutter replay files
    "./.ansible"           # 1.8M - Ansible cache (regenerated)
    "./.terraform.d"       # 24K - Terraform plugins (reinstallable)
    "./.thunderbird"       # 16M - Thunderbird cache (regenerated)
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
    "./.pki"               # 76K - PKI certificates (regenerated)
    "./.lacework"          # 8.0K - Lacework cache (regenerated)
    "./.IdentityService"   # 4.0K - Identity Service cache (regenerated)
    "./.1password"         # 4.0K - 1Password cache (regenerated)
    "./.vpn"               # 8.0K - VPN cache (regenerated)
    "./.keras"             # 8.0K - Keras cache (regenerated)
    "./.stayback"          # 4.0K - Stayback cache (regenerated)
    "./.gk"                # 192K - GitKraken cache (regenerated)
)

# -------------------------------------------------------------
# Script Logic (Do not modify below this line)
# -------------------------------------------------------------

# Initialize an empty array for tar arguments
TAR_ARGS=()

# Loop through and dynamically format each exclude item
for item in "${EXCLUDES[@]}"; do
    TAR_ARGS+=(--exclude="$item")
done

# Execute the compressed tar command
tar "${TAR_ARGS[@]}" -czvf "$BACKUP_DEST" -C "$SRC_DIR" .


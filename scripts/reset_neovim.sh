#!/usr/bin/env bash
# delete all configurations and replace with the config in the dotfiles project
# run this script from make 'reset_neovim'
SOURCE_DIR="$(pwd)/neovim"
CONFIG_DIR="$HOME/.config/nvim"

mkdir -p "$CONFIG_DIR"
cp -r "$SOURCE_DIR"/* "$CONFIG_DIR"

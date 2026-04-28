# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for configuring Ubuntu 20.04 bash environment. Uses GNU Make to symlink configuration files from this repo into `$HOME` and `$HOME/bashrc.d`. The Makefile targets are **not idempotent** - they will fail if target files/symlinks already exist.

## Key Commands

### Initial Setup
```bash
# First time setup (creates symlinks, requires files don't exist)
make all

# Remove all symlinks before re-running
make remove-all

# View all available targets
make help
```

### Common Make Targets
```bash
make packages         # Install all required apt packages
make bash            # Configure bash environment (links bashrc.d/*.sh)
make gitconfig       # Link gitconfig
make ssh-config      # Link ssh config
make powerline       # Install and configure powerline
make neovim          # Install neovim and copy config
make docker          # Install Docker
make pyenv           # Clone pyenv repository
make awscli_v2       # Install AWS CLI v2
```

### Testing
```bash
make shellcheck      # Run shellcheck on all .sh files and bin scripts
```

## Architecture

### Bash Configuration Loading
The build process modifies `$HOME/.bashrc` to source `$HOME/.bashrc.local`, which iterates through all `*.sh` files in `$HOME/bashrc.d/` and sources them. This modular approach separates concerns (git aliases, AWS functions, SSH config, etc.) into individual files.

Source files: `bashrc.d/*.sh` (20+ files)
- Symlinked to: `$HOME/bashrc.d/*.sh`
- Loaded by: `$HOME/.bashrc.local` (symlinked from `bashrc.local`)

### Installation Scripts
`scripts/install_*.sh` files handle package installations for tools like Docker, AWS CLI, neovim, fzf, lazygit, etc. (32+ scripts total). These are called by Make targets or can be run independently.

### Utility Scripts
`bin/` contains GPG wrapper scripts (encrypt/decrypt), AWS helper scripts, and git utilities that get symlinked to `$HOME/bin`.

### Configuration Files
- **tmux**: Custom config with CTRL-] prefix, split keybindings, TPM plugin manager, session persistence with tmux-resurrect and tmux-continuum
- **sesh**: Session manager config in `sesh/sesh.toml`
- **powerline**: Custom colorschemes and themes
- **neovim**: Config copied (not symlinked) to `$HOME/.config/nvim/`

## Important Notes

- Makefile **directly edits** `$HOME/.bashrc` (backs up to `.bashrc.$EPOCH` first)
- The `bin/encrypt` and `bin/decrypt` scripts are **always overwritten** (removed and re-symlinked)
- To reset changes: `make undo_edits` (runs `git reset --hard` and `git clean -f`)
- Most targets create symlinks using `ln -vs` so the actual files remain in this repo
- Exception: neovim config is **copied** not symlinked (`reset_neovim_config` target)

## tmux Keybindings

Prefix: `CTRL-]`
- `C-] |` - split vertically
- `C-] -` - split horizontally  
- `C-] s` - list sessions
- `C-] t` - interactive sesh session selector (fzf with filters: ^a all, ^t tmux, ^g configs, ^x zoxide, ^d kill, ^f find)
- `C-] m` - toggle maximize pane
- `C-] j/k/h/l` - expand pane down/up/left/right
- `C-] r` - reload tmux.conf
- `C-] I` - install TPM plugins
- `C-] U` - update TPM plugins
- `C-] C-s` - save session (tmux-resurrect)
- `C-] C-r` - restore session (tmux-resurrect)

### Session Persistence
- **tmux-resurrect**: Manual save/restore with `C-] C-s` and `C-] C-r`
- **tmux-continuum**: Automatic saves every 15 minutes, auto-restore on tmux start
- Captures pane contents and neovim sessions

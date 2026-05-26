# Backport Plan: ubuntu2404_dotfiles → dotfiles

This document describes changes from the last 7 commits in `~/projects/ubuntu2404_dotfiles/` (excluding ff0b71c) and provides a plan to implement and test them in this project.

## Commits to Backport

### 1. Commit 318ad30: "simplify"
**Changes:**
- Simplified tmux keybinding `C-] T` to just call `sesh connect` with project finder
- Updated `t()` bash function to use `sesh list` with fzf filtering for different modes (all, tmux, configs, zoxide, projects)
- Removed complex multi-line tmux binding that manually created editor/claude windows

**Impact:** Simplifies project session management by relying on sesh's native capabilities

### 2. Commit 13421be: "simplify tmux and auto renumber"
**Changes:**
- Added `set -g renumber-windows on` to tmux.conf
- Removed `dev_setup()` function from bashrc.d/tmux_aliases.sh (24 lines)

**Impact:** Enables automatic window renumbering when windows are closed; removes unused bash function

### 3. Commit dfa0cb0: "tmux session control aliases"
**Changes:**
- Added new bash alias: `alias ts='tmux display-message -p "#S"'` (shows current tmux session name)
- Created new script: `bin/t-kill` (interactive tmux session killer using fzf)
- Updated Makefile to symlink t-kill to ~/bin/t-kill

**Impact:** Improves tmux session management with ability to view current session and interactively kill sessions

### 4. Commit b949e03: "install whisper-stream"
**Changes:**
- Created `scripts/install_whisper.sh` (94 lines) - builds whisper.cpp from source
- Added whisper-stream binary to bin/ (binary file, 2707160 bytes)
- Added `cmake` and `libsdl2-dev` to packages target in Makefile
- Created `./bin/whisper-stream` target in Makefile (depends on packages)
- Added `whisper-clean` target to Makefile
- Added `bin/whisper-stream` to .gitignore
- Updated `bin` target to symlink whisper-stream if it exists

**Impact:** Adds voice transcription capability using whisper.cpp

### 5. Commit 36e1d35: "cleanup apt"
**Changes:**
- Made whisper-stream a conditional symlink in bin target (only if file exists)
- Changed `./bin/whisper-stream` to `bin/whisper-stream` (removed leading ./)
- Added `.PHONY` declarations for whisper and whisper-clean targets
- Created convenience target `whisper: bin/whisper-stream`
- Enhanced `whisper-clean` to also remove `bin/whisper-stream` file

**Impact:** Cleaner Makefile organization and better whisper installation handling

### 6. Commit 31cdbbc: "install whisper stream" (refinement)
**Changes:**
- Renamed binary from `bin/whisper-stream` to `bin/whisper-stream-bin`
- Created wrapper script `bin/whisper-stream-wrapper.sh` (41 lines)
- Updated .gitignore: changed `bin/whisper-stream` to `bin/whisper-stream-bin` and added `bin/models/`
- Modified Makefile to symlink wrapper instead of binary
- Added model directory symlinking to bin target
- Enhanced install_whisper.sh to:
  - Copy model file to `bin/models/ggml-base.en.bin`
  - Generate the wrapper script during installation
  - Better cleanup (removes bin, wrapper, and models)

**Impact:** Makes whisper-stream portable by bundling the model and using a wrapper that auto-specifies model path

## Implementation Plan

### Phase 1: tmux Simplification (Commits 318ad30, 13421be)

**Files to modify:**
- `tmux/tmux.conf`
- `bashrc.d/tmux_aliases.sh`

**Steps:**
1. Add `set -g renumber-windows on` to tmux.conf (after line 5)
2. Simplify the `C-] T` keybinding in tmux.conf (replace lines 86-103)
3. Update the `t()` function in tmux_aliases.sh to use enhanced fzf with ctrl-f binding
4. Remove `dev_setup()` function from tmux_aliases.sh (lines 28-46)

**Testing:**
- Verify tmux windows renumber after closing middle windows
- Test `t()` function with ctrl-a, ctrl-t, ctrl-g, ctrl-x, ctrl-f bindings
- Test `C-] T` keybinding to select project and create/switch session
- Confirm dev_setup is no longer available (expected)

### Phase 2: tmux Session Management (Commit dfa0cb0)

**Files to create/modify:**
- `bashrc.d/tmux_aliases.sh` (add alias)
- `bin/t-kill` (new file)
- `Makefile` (add symlink)

**Steps:**
1. Add `alias ts='tmux display-message -p "#S"'` to tmux_aliases.sh
2. Create `bin/t-kill` script with fzf-based session killer
3. Update Makefile bin target to include t-kill symlink

**Testing:**
- Test `ts` alias shows current session name
- Test `t-kill` or `~/bin/t-kill` interactively selects and kills sessions
- Verify cancellation (no selection) doesn't kill anything
- Test error handling when no tmux sessions exist

### Phase 3: Whisper Installation Infrastructure (Commits b949e03, 36e1d35, 31cdbbc)

**Files to create/modify:**
- `scripts/install_whisper.sh` (new file)
- `bin/whisper-stream-wrapper.sh` (new file)
- `Makefile` (add targets and update bin, packages)
- `.gitignore` (add whisper entries)

**Steps:**
1. Add `bin/whisper-stream-bin` and `bin/models/` to .gitignore
2. Add `cmake` and `libsdl2-dev` to packages target
3. Create `scripts/install_whisper.sh` with full installation logic
4. Create `bin/whisper-stream-wrapper.sh` (initially as template, will be generated)
5. Add whisper-related targets to Makefile:
   - `bin/whisper-stream-bin` target
   - `whisper` convenience target
   - `whisper-clean` target
6. Update `bin` target to conditionally symlink whisper-stream wrapper and models directory
7. Add `.PHONY` declarations for whisper targets

**Testing:**
- Test `make whisper` to build and install whisper-stream
- Verify binary created at `bin/whisper-stream-bin`
- Verify wrapper created at `bin/whisper-stream-wrapper.sh`
- Verify model downloaded to `bin/models/ggml-base.en.bin`
- Test `make bin` symlinks wrapper to ~/bin/whisper-stream
- Test `~/bin/whisper-stream` works (resolves symlinks, finds binary and model)
- Test whisper-stream from arbitrary directory (model path should work)
- Test `make whisper-clean` removes all whisper files
- Test re-installation after clean

## Testing Checklist

### Prerequisites
- [ ] Ensure fzf is installed
- [ ] Ensure sesh is installed
- [ ] Ensure tmux is running
- [ ] Have multiple tmux sessions for testing

### tmux Tests
- [ ] Window renumbering works after closing windows
- [ ] `t()` function shows filtered results with ctrl-a/t/g/x/f
- [ ] `C-] t` keybinding launches sesh session selector
- [ ] `C-] T` keybinding creates/switches to project session
- [ ] `ts` alias displays current session name
- [ ] `t-kill` script lists sessions in fzf
- [ ] `t-kill` kills selected session
- [ ] `t-kill` cancellation works without killing

### Whisper Tests
- [ ] `make packages` installs cmake and libsdl2-dev
- [ ] `make whisper` downloads, builds, and installs whisper.cpp
- [ ] Binary exists at `bin/whisper-stream-bin`
- [ ] Wrapper exists at `bin/whisper-stream-wrapper.sh`
- [ ] Model exists at `bin/models/ggml-base.en.bin`
- [ ] `make bin` creates symlink at ~/bin/whisper-stream
- [ ] `~/bin/whisper-stream` executes successfully
- [ ] Wrapper resolves symlinks correctly
- [ ] Wrapper finds binary (whisper-stream-bin)
- [ ] Wrapper auto-specifies model path
- [ ] Can override model with `-m` or `--model` flag
- [ ] `make whisper-clean` removes all whisper artifacts
- [ ] Re-installation works after clean

## Key Differences from ubuntu2404_dotfiles

1. **Ubuntu 20.04 vs 24.04**: This repo targets Ubuntu 20.04, may have different package versions
2. **Existing tmux.conf structure**: Need to carefully integrate changes without breaking existing keybindings
3. **Makefile differences**: bin target has different scripts, need to add t-kill and whisper conditionally
4. **Package installation**: May need to verify cmake/libsdl2-dev package names for Ubuntu 20.04

## Rollback Plan

If issues arise:
1. **tmux changes**: `git checkout tmux/tmux.conf bashrc.d/tmux_aliases.sh`
2. **t-kill**: Remove symlink `rm ~/bin/t-kill` and `rm bin/t-kill`
3. **whisper**: Run `make whisper-clean`, then remove install script and Makefile changes

## Notes

- The whisper binary is ~2.7MB and will be gitignored
- The wrapper script enables calling whisper-stream from any directory (e.g., neovim)
- The t() function enhancement provides better filtering but maintains backward compatibility
- Window auto-renumbering is a quality-of-life improvement with no breaking changes
- The simplified C-] T binding relies on sesh's native session creation

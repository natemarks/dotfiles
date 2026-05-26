# Quick Testing Guide - 5 Minutes

Fast way to verify all backported changes work correctly.

## Prerequisites Check
```bash
# Must have these installed
command -v tmux && echo "✓ tmux" || echo "✗ tmux missing"
command -v fzf && echo "✓ fzf" || echo "✗ fzf missing"
command -v sesh && echo "✓ sesh" || echo "✗ sesh missing"
```

## 1. Test tmux Changes (2 minutes)

```bash
# Step 1: Reload tmux config
tmux source-file ~/.tmux.conf
# Or inside tmux: Ctrl-] then r

# Step 2: Test window renumbering
tmux new-window    # Creates window 1
tmux new-window    # Creates window 2
tmux list-windows  # Note the window numbers
tmux kill-window -t 1  # Kill middle window
tmux list-windows  # Should renumber: 0, 1 (no gap at 2)
# ✓ PASS if windows renumbered automatically

# Step 3: Test project selector
# Inside tmux, press: Ctrl-] then T
# ✓ PASS if fzf shows ~/projects directories
# Select one and verify session created/switched
```

## 2. Test bash Functions (1 minute)

```bash
# Reload bash functions
source ~/bashrc.d/tmux_aliases.sh

# Test 1: Current session name
ts
# ✓ PASS if it shows your current tmux session name

# Test 2: Enhanced session selector
t
# Try these keyboard shortcuts in the fzf picker:
# - Ctrl-a (all sessions)
# - Ctrl-t (tmux only)
# - Ctrl-f (projects)
# ✓ PASS if each shortcut changes the list
# Press Escape to exit
```

## 3. Test Session Killer (30 seconds)

```bash
# Create test session
tmux new-session -d -s test_session

# Create symlink if not done
cd ~/projects/dotfiles && make bin

# Run t-kill
t-kill
# ✓ PASS if fzf shows sessions including test_session
# Select test_session and press Enter
# ✓ PASS if you see: "Killed session: test_session"

# Verify it's gone
tmux list-sessions | grep test_session
# ✓ PASS if no output (session deleted)
```

## 4. Test Whisper (Optional - 10 minutes)

Only if you want voice transcription capability.

```bash
cd ~/projects/dotfiles

# Check dependencies
dpkg -l | grep -E "cmake|libsdl2-dev" || make packages

# Install whisper (~5-10 minutes, downloads ~142 MB)
make whisper

# Create symlinks
make bin

# Quick test
whisper-stream --help
# ✓ PASS if help text appears (not error)

# Test from different directory
cd /tmp && whisper-stream --help
# ✓ PASS if still works (proves wrapper resolves paths)

# Cleanup (if you don't want it)
cd ~/projects/dotfiles && make whisper-clean
```

## Pass/Fail Summary

| Test | Expected Result | Status |
|------|----------------|--------|
| Window renumbering | Windows renumber after kill | ⬜ |
| C-] T keybinding | Shows project selector | ⬜ |
| `ts` alias | Shows session name | ⬜ |
| `t` function | Shows fzf with filters | ⬜ |
| Ctrl-f in `t` | Shows projects list | ⬜ |
| t-kill | Lists & kills sessions | ⬜ |
| whisper install | Completes without error | ⬜ |
| whisper execution | Runs from any directory | ⬜ |

## Troubleshooting

### tmux changes not working
```bash
# Hard reset
tmux kill-server
tmux
```

### bash functions not working
```bash
# Start new shell
exec bash
```

### t-kill not found
```bash
cd ~/projects/dotfiles
make bin
```

### whisper build fails
```bash
# Check log
cat ~/tmp/whisper-install.log

# Reinstall dependencies
sudo apt-get install -y build-essential cmake git libsdl2-dev
```

## Full Testing

For comprehensive testing with detailed steps:
- See `TESTING.md` for complete guide
- See `CHANGES_SUMMARY.md` for what changed
- See `BACKPORT.md` for implementation details

## One-Line Rollback

If something breaks:
```bash
cd ~/projects/dotfiles && git checkout . && rm -f bin/t-kill bin/whisper-stream-wrapper.sh scripts/install_whisper.sh && tmux source-file ~/.tmux.conf
```

## Success?

If all tests pass:
1. Commit your changes: `git add . && git commit -m "backport tmux and whisper changes from ubuntu2404"`
2. Start using the new features in your workflow
3. Remove whisper if you tested but don't need it: `make whisper-clean`

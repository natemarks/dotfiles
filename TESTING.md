# Testing Guide for Backported Changes

This guide explains how to test all the changes backported from ubuntu2404_dotfiles.

## Prerequisites

Before testing, ensure you have:
- tmux installed and running
- fzf installed
- sesh installed
- Multiple tmux sessions created for testing
- Access to ~/projects directory with some project folders

## Phase 1: tmux Configuration Changes

### Test 1: Window Auto-Renumbering

**What changed:** Added `set -g renumber-windows on` to tmux.conf

**How to test:**
1. Reload tmux configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```
   Or use the keybinding: `Ctrl-]` then `r`

2. Create a few windows in tmux:
   ```bash
   tmux new-window  # Creates window 1
   tmux new-window  # Creates window 2
   tmux new-window  # Creates window 3
   ```

3. List windows to see their numbers:
   ```bash
   tmux list-windows
   ```
   You should see windows numbered 0, 1, 2, 3

4. Kill the middle window (e.g., window 1):
   ```bash
   tmux kill-window -t 1
   ```

5. List windows again:
   ```bash
   tmux list-windows
   ```
   **Expected:** Windows automatically renumber to 0, 1, 2 (no gap)

### Test 2: Simplified Project Selector (C-] T)

**What changed:** Simplified keybinding to use sesh for session creation

**How to test:**
1. Inside tmux, press: `Ctrl-]` then `T`
2. **Expected:** fzf picker appears showing your ~/projects directories
3. Select a project (use arrow keys, press Enter)
4. **Expected:** 
   - If session doesn't exist: sesh creates new session in that directory
   - If session exists: switches to existing session
   - Session name matches project directory name

**Comparison to old behavior:**
- Old: Manually created editor/claude windows
- New: Uses sesh's native session creation (simpler, more flexible)

### Test 3: Enhanced t() Function

**What changed:** Added fzf filtering modes with keyboard shortcuts

**How to test:**
1. Source the updated bashrc:
   ```bash
   source ~/bashrc.d/tmux_aliases.sh
   ```

2. From any bash shell, type: `t` and press Enter

3. **Expected:** fzf picker appears with header:
   ```
   ^a all ^t tmux ^g configs ^x zoxide ^f projects
   ```

4. Test each filter mode:
   - Press `Ctrl-a`: Shows all sessions (default)
   - Press `Ctrl-t`: Shows only tmux sessions
   - Press `Ctrl-g`: Shows config directories
   - Press `Ctrl-x`: Shows zoxide directories (most visited)
   - Press `Ctrl-f`: Shows ~/projects subdirectories

5. **Expected:** Each filter changes the prompt emoji and reloads filtered results

6. Select a session and press Enter
7. **Expected:** Connects to the selected session

**What's improved:**
- Old: Only showed combined list from `sesh list -t -c -z`
- New: Interactive filtering with keyboard shortcuts for different sources

## Phase 2: Session Management Tools

### Test 4: ts Alias (Show Current Session)

**What changed:** Added alias to display current tmux session name

**How to test:**
1. Make sure you're inside a tmux session
2. Source the updated aliases:
   ```bash
   source ~/bashrc.d/tmux_aliases.sh
   ```

3. Run the alias:
   ```bash
   ts
   ```

4. **Expected:** Displays the current session name (e.g., "dotfiles" or "main")

5. Switch to a different session and run `ts` again
6. **Expected:** Shows the new session name

**Use case:** Quick way to check which session you're in without looking at status bar

### Test 5: t-kill Script (Interactive Session Killer)

**What changed:** Added new script to interactively kill tmux sessions

**How to test:**
1. Create multiple tmux sessions for testing:
   ```bash
   tmux new-session -d -s test1
   tmux new-session -d -s test2
   tmux new-session -d -s test3
   ```

2. Verify they exist:
   ```bash
   tmux list-sessions
   ```

3. Run t-kill:
   ```bash
   ~/bin/t-kill
   ```
   Or if you've run `make bin`:
   ```bash
   t-kill
   ```

4. **Expected:** fzf picker appears showing all session names

5. Select a session (e.g., test1) and press Enter

6. **Expected:** 
   - Message: "Killed session: test1"
   - Session is removed

7. Verify session was killed:
   ```bash
   tmux list-sessions
   ```
   test1 should be gone

8. Test cancellation:
   ```bash
   t-kill
   ```
   Press `Esc` or `Ctrl-C` without selecting

9. **Expected:** 
   - Message: "No session selected"
   - No sessions killed

10. Test error handling (no sessions):
    ```bash
    # Kill all sessions first
    tmux kill-server
    # Try to run t-kill
    t-kill
    ```
    **Expected:** Error message: "Error: No tmux sessions found"

## Phase 3: Whisper Voice Transcription

### Test 6: Whisper Installation

**What changed:** Added complete whisper.cpp installation system

**How to test:**

#### Step 1: Install dependencies
```bash
make packages
```
**Expected:** cmake and libsdl2-dev are installed (among others)

Verify:
```bash
dpkg -l | grep cmake
dpkg -l | grep libsdl2-dev
```

#### Step 2: Build and install whisper
```bash
make whisper
```

**Expected output:**
- Clones whisper.cpp repository
- Downloads base.en model (~142 MB)
- Builds with cmake
- Copies binary to `bin/whisper-stream-bin`
- Copies model to `bin/models/ggml-base.en.bin`
- Creates wrapper script at `bin/whisper-stream-wrapper.sh`

**Verify files exist:**
```bash
ls -lh bin/whisper-stream-bin
ls -lh bin/whisper-stream-wrapper.sh
ls -lh bin/models/ggml-base.en.bin
```

**Check log:**
```bash
cat ~/tmp/whisper-install.log
```

#### Step 3: Create symlinks
```bash
make bin
```

**Expected:**
- Creates symlink: ~/bin/whisper-stream → bin/whisper-stream-wrapper.sh
- Creates symlink: ~/bin/models → bin/models/

**Verify:**
```bash
ls -la ~/bin/whisper-stream
ls -la ~/bin/models
```

#### Step 4: Test whisper-stream execution

**Test from bin directory:**
```bash
cd ~/bin
./whisper-stream
```
**Expected:** Shows whisper-stream help/usage (proves binary works)

**Test from arbitrary directory:**
```bash
cd /tmp
whisper-stream
```
**Expected:** Still works (proves wrapper resolves symlinks correctly)

**Test model auto-specification:**
The wrapper should automatically add the model path. You can verify by checking the wrapper finds the model:
```bash
# This would normally require -m flag, but wrapper adds it
# Just verify it doesn't error about missing model
whisper-stream --help
```

**Test custom model override:**
```bash
# Wrapper should respect explicit -m flag
whisper-stream -m /some/other/model.bin --help
```
**Expected:** Doesn't error about the flag (proves wrapper detects existing -m flag)

#### Step 5: Test actual transcription (optional)

If you have a microphone:
```bash
whisper-stream
```
**Expected:** 
- Starts capturing audio
- Displays transcribed text in real-time
- Press Ctrl-C to exit

#### Step 6: Test cleanup
```bash
make whisper-clean
```

**Expected:**
- Removes `bin/whisper-stream-bin`
- Removes `bin/whisper-stream-wrapper.sh`
- Removes `bin/models/` directory
- Removes `~/bin/whisper-stream` symlink

**Verify:**
```bash
ls bin/whisper-stream-bin 2>&1  # Should error: No such file
ls bin/models 2>&1              # Should error: No such file
ls ~/bin/whisper-stream 2>&1    # Should error: No such file
```

#### Step 7: Test re-installation
```bash
make whisper
make bin
```
**Expected:** Installs successfully again

## Complete Testing Checklist

Use this checklist to track your testing progress:

### tmux Configuration
- [ ] Window renumbering works after closing middle windows
- [ ] Window numbers remain sequential (no gaps)
- [ ] C-] r reloads tmux config successfully

### tmux Keybindings
- [ ] C-] T opens project selector
- [ ] C-] T creates new session for selected project
- [ ] C-] T switches to existing session if already created

### bash t() Function
- [ ] `t` command opens fzf picker
- [ ] Header shows keyboard shortcuts
- [ ] Ctrl-a shows all sessions
- [ ] Ctrl-t shows tmux sessions only
- [ ] Ctrl-g shows config directories
- [ ] Ctrl-x shows zoxide directories
- [ ] Ctrl-f shows ~/projects subdirectories
- [ ] Selecting session connects successfully
- [ ] Works both inside and outside tmux

### Session Management
- [ ] `ts` alias shows current session name
- [ ] `ts` updates when switching sessions
- [ ] `t-kill` lists sessions in fzf
- [ ] `t-kill` successfully kills selected session
- [ ] `t-kill` shows "No session selected" on cancel
- [ ] `t-kill` shows error when no sessions exist
- [ ] `~/bin/t-kill` symlink works

### Whisper Installation
- [ ] `make packages` installs cmake and libsdl2-dev
- [ ] `make whisper` completes without errors
- [ ] Binary created at `bin/whisper-stream-bin`
- [ ] Wrapper created at `bin/whisper-stream-wrapper.sh`
- [ ] Model downloaded to `bin/models/ggml-base.en.bin`
- [ ] Installation log created at ~/tmp/whisper-install.log
- [ ] Files are executable (chmod +x)

### Whisper Symlinks
- [ ] `make bin` creates ~/bin/whisper-stream symlink
- [ ] `make bin` creates ~/bin/models symlink
- [ ] Symlinks point to correct locations

### Whisper Execution
- [ ] `~/bin/whisper-stream` runs without errors
- [ ] `whisper-stream` works from any directory
- [ ] Wrapper resolves symlinks correctly
- [ ] Wrapper finds binary (whisper-stream-bin)
- [ ] Wrapper auto-specifies model path
- [ ] Manual -m flag overrides auto model path
- [ ] Actual transcription works (if microphone available)

### Whisper Cleanup
- [ ] `make whisper-clean` removes binary
- [ ] `make whisper-clean` removes wrapper
- [ ] `make whisper-clean` removes models directory
- [ ] `make whisper-clean` removes ~/bin/whisper-stream symlink
- [ ] Re-installation works after cleanup

## Troubleshooting

### tmux changes not taking effect
**Solution:** Reload tmux config
```bash
tmux source-file ~/.tmux.conf
```
Or restart tmux server (exits all sessions):
```bash
tmux kill-server
tmux
```

### bash functions not updated
**Solution:** Re-source the file
```bash
source ~/bashrc.d/tmux_aliases.sh
```
Or start a new bash shell:
```bash
exec bash
```

### t-kill not found
**Solution:** Run make bin to create symlinks
```bash
cd ~/projects/dotfiles
make bin
```

### Whisper build fails
**Solution:** Check dependencies
```bash
# Verify packages installed
dpkg -l | grep -E "cmake|libsdl2-dev|build-essential|git"

# Check build log
cat ~/tmp/whisper-install.log

# Try manual install
sudo apt-get update
sudo apt-get install -y build-essential cmake git libsdl2-dev
```

### Whisper wrapper can't find binary
**Solution:** Verify files exist and symlinks are correct
```bash
# Check binary exists
ls -lh ~/projects/dotfiles/bin/whisper-stream-bin

# Check wrapper exists
ls -lh ~/projects/dotfiles/bin/whisper-stream-wrapper.sh

# Check symlink
ls -la ~/bin/whisper-stream

# Recreate symlinks
cd ~/projects/dotfiles
make bin
```

### Model not found error
**Solution:** Verify model directory and file
```bash
# Check model file
ls -lh ~/projects/dotfiles/bin/models/ggml-base.en.bin

# Re-download if missing
cd ~/projects/dotfiles
make whisper-clean
make whisper
```

## Performance Notes

- **Whisper build time:** ~5-10 minutes depending on system
- **Model download:** ~142 MB, takes 1-5 minutes depending on connection
- **Disk space:** ~150 MB for binary + model
- **Runtime:** Real-time transcription with minimal latency

## Next Steps

After testing is complete:
1. Remove test tmux sessions: `tmux kill-session -t test1` (etc.)
2. Keep or remove whisper based on your needs
3. Consider adding tmux session management to your workflow
4. Explore using whisper-stream with neovim plugins

## Rollback Instructions

If you need to revert changes:

```bash
cd ~/projects/dotfiles

# Rollback all changes
git checkout .

# Remove new files
rm -f bin/t-kill
rm -f bin/whisper-stream-wrapper.sh
rm -f scripts/install_whisper.sh

# Remove symlinks
rm -f ~/bin/t-kill
rm -f ~/bin/whisper-stream

# Clean whisper artifacts
make whisper-clean

# Reload tmux
tmux source-file ~/.tmux.conf

# Reload bash
source ~/.bashrc
```

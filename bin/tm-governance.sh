#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="opencode"

# Desired windows: index|name|directory|command
WINDOWS=(
  "0|gov-oc|$HOME/projects/aws-governance/|"
  "1|gov-nv|$HOME/projects/aws-governance/|nv"
  "2|nplza-oc|$HOME/projects/non-prod-aws-accelerator-config/|"
  "3|nplza-nv|$HOME/projects/non-prod-aws-accelerator-config/|nv"
  "4|lza-oc|$HOME/projects/prod-ImprLza01-config/|"
  "5|lza-nv|$HOME/projects/prod-ImprLza01-config/|nv"
)

session_exists() {
  tmux has-session -t "$SESSION_NAME" >/dev/null 2>&1
}

window_exists() {
  local idx="$1"
  local name="$2"
  tmux list-windows -t "$SESSION_NAME" -F '#{window_index}:#{window_name}' 2>/dev/null \
    | grep -q "^${idx}:${name}$"
}

create_window() {
  local idx="$1"
  local name="$2"
  local dir="$3"
  local cmd="$4"

  if [ -n "$cmd" ]; then
    tmux new-window -t "${SESSION_NAME}:${idx}" -n "$name" -c "$dir" "$cmd"
  else
    tmux new-window -t "${SESSION_NAME}:${idx}" -n "$name" -c "$dir"
  fi
}

# Create the session if needed
if ! session_exists; then
  IFS='|' read -r idx name dir cmd <<< "${WINDOWS[0]}"
  create_window "$idx" "$name" "$dir" "$cmd"
fi

# Repair any missing windows
for spec in "${WINDOWS[@]}"; do
  IFS='|' read -r idx name dir cmd <<< "$spec"

  if ! window_exists "$idx" "$name"; then
    create_window "$idx" "$name" "$dir" "$cmd"
  fi
done

# Re-enter the session appropriately
if [ -z "${TMUX-}" ]; then
  tmux attach-session -t "$SESSION_NAME"
else
  current_session="$(tmux display-message -p '#S')"
  if [ "$current_session" != "$SESSION_NAME" ]; then
    tmux switch-client -t "$SESSION_NAME"
  fi
fi

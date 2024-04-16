#!/usr/bin/env bash

SESSION_NAME="daily"

# Check if the tmux session exists
if ! tmux has-session -t $SESSION_NAME >/dev/null 2>&1; then
  # If session doesn't exist, create a new one
  tmux new-session -d -s $SESSION_NAME
  tmux new-window -t $SESSION_NAME -n dotfiles
  tmux new-window -t $SESSION_NAME -n todo
  tmux kill-window -t $SESSION_NAME:0
  tmux send-keys -t $SESSION_NAME:todo 'vim ~/todo.txt' C-m
  tmux send-keys -t $SESSION_NAME:dotfiles 'cd ~/projects/dotfiles' C-m
fi

# Attach to the session
tmux attach-session -t $SESSION_NAME


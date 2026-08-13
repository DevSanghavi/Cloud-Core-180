#!/usr/bin/env bash
set -eu

SESSION="monitor_prod"

# If session exists, kill it first for a clean start
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux kill-session -t "$SESSION"
fi

# Create detached session
tmux new -s "$SESSION" -d

# Create a second window for commands
tmux new-window -t "$SESSION" -n commands

# Window 0: split into 3 panes (top, bottom-left, bottom-right)
# First split: horizontal (top/bottom)
tmux split-window -v -t "$SESSION:0"

# Now split the bottom pane vertically (left/right)
tmux split-window -h -t "$SESSION:0.1"

# Pane 0.0 : htop
tmux send-keys -t "$SESSION:0.0" 'htop' Enter

# Pane 0.1 : log directory and tail
tmux send-keys -t "$SESSION:0.1" 'mkdir -p ~/cloud-practice/day41/tmux-layouts/logs' Enter
tmux send-keys -t "$SESSION:0.1" 'echo "App booting..." >> ~/cloud-practice/day41/tmux-layouts/logs/app.log' Enter
tmux send-keys -t "$SESSION:0.1" 'tail -f ~/cloud-practice/day41/tmux-layouts/logs/app.log' Enter

# Pane 0.2 : command area
tmux send-keys -t "$SESSION:0.2" 'cd ~/cloud-practice/day41 && echo "Ready for commands in pane 0.2"' Enter

# Force tmux to switch back to Window 0 so you see the splits immediately
tmux select-window -t "$SESSION:0"

# Attach to the session
tmux attach -t "$SESSION"

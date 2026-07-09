#!/bin/bash

SESSION_NAME="claude-agent"

if [ "$1" = "--discord" ]; then
    CLAUDE_CMD="claude --channels plugin:discord@claude-plugins-official --dangerously-skip-permissions"
else
    CLAUDE_CMD="claude --dangerously-skip-permissions"
fi

tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? = 0 ]; then
    echo "Existing session '$SESSION_NAME' found. Terminating..."
    tmux kill-session -t "$SESSION_NAME"
    echo "Existing session terminated successfully."
fi

echo "Creating a new tmux session '$SESSION_NAME' and running Claude in the background..."
tmux new-session -d -s "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME" "$CLAUDE_CMD" C-m
echo "Deployment successful! (tmux attach -t $SESSION_NAME)"

#!/bin/bash

# Check if a window with title "scratchpadterminal" exists
WINDOW_ID=$(xdotool search --name scratchpadterminal | head -1)

# If the window exists
if [ "$WINDOW_ID" ]; then
    i3-msg '[title="^scratchpadterminal$"] scratchpad show; move position center'
else
    xfce4-terminal --title=scratchpadterminal
fi

#!/bin/bash

DISPLAY_NAME="DisplayPort-2" # Replace with your display name
STEP=0.1

CURRENT_BRIGHTNESS=$(xrandr --verbose | grep -i "Brightness" | awk '{print $2}')
NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS - $STEP" | bc)

if (( $(echo "$NEW_BRIGHTNESS < 0" | bc -l) )); then
  NEW_BRIGHTNESS=0
fi

xrandr --output $DISPLAY_NAME --brightness $NEW_BRIGHTNESS

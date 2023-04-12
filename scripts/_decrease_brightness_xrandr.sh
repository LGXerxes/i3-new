#!/bin/bash

STEP=0.1

for DISPLAY_NAME in $(xrandr | grep " connected" | awk '{print $1}'); do
  CURRENT_BRIGHTNESS=$(xrandr --verbose | grep -i "${DISPLAY_NAME} connected" -A5 | grep -i "Brightness" | awk '{print $2}')
  NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS - $STEP" | bc)

  if (( $(echo "$NEW_BRIGHTNESS <0 " | bc -l) )); then
    NEW_BRIGHTNESS=0
  fi

  xrandr --output $DISPLAY_NAME --brightness $NEW_BRIGHTNESS
done

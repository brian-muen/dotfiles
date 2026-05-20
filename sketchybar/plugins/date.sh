#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --animate tanh 10 --set "$NAME" \
    drawing=on \
    label="$(date +'%a %d %b  %I:%M %p')" \
    label.color="$COLOR_IRIS" \
    background.drawing=on \
    background.color="$COLOR_BG"

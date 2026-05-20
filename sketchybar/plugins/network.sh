#!/bin/sh

source "$CONFIG_DIR/colors.sh"

IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"
if [ -n "$IP" ]; then
  LABEL="$IP"
else
  LABEL="offline"
fi

sketchybar --animate tanh 10 --set "$NAME" \
  label="$LABEL" \
  icon.color="$COLOR_ROSE" \
  label.color="$COLOR_ROSE" \
  background.drawing=on \
  background.color="$COLOR_BG"

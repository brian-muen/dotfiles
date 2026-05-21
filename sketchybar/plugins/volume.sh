#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

case "$VOLUME" in
  [6-9][0-9]|100) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-9]|[1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

sketchybar --animate tanh 10 --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR_IRIS" \
  label="$VOLUME%" \
  label.color="$COLOR_IRIS"

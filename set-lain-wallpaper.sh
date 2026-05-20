#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "${HOME}/.config/assets/lain" ]; then
    WALLPAPER_DIR="${HOME}/.config/assets/lain"
else
    WALLPAPER_DIR="${SCRIPT_DIR}/assets/lain"
fi
DEFAULT_WALLPAPER="mysterious-Lain.png"
WALLPAPER="${1:-$DEFAULT_WALLPAPER}"

case "$WALLPAPER" in
    random)
        WALLPAPER_PATH="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | sort | awk 'BEGIN { srand() } { files[++n] = $0 } END { if (n > 0) print files[int(rand() * n) + 1] }')"
        ;;
    /*)
        WALLPAPER_PATH="$WALLPAPER"
        ;;
    *)
        WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER"
        ;;
esac

if [ -z "${WALLPAPER_PATH:-}" ] || [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper not found: $WALLPAPER" >&2
    echo "Available wallpapers:" >&2
    find "$WALLPAPER_DIR" -maxdepth 1 -type f -exec basename {} \; | sort >&2
    exit 1
fi

osascript <<OSA
tell application "System Events"
    repeat with desktopRef in desktops
        set picture of desktopRef to POSIX file "$WALLPAPER_PATH"
    end repeat
end tell

tell application "Finder"
    set desktop picture to POSIX file "$WALLPAPER_PATH"
end tell
OSA

echo "$WALLPAPER_PATH"

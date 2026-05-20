#!/bin/bash
# switch-theme.sh — called by dark-notify on appearance change, or manually with "dark"/"light"

CONFIG="$HOME/.config"
STARSHIP_CONFIG="$CONFIG/starship.toml"
if [ -L "$STARSHIP_CONFIG" ]; then
    STARSHIP_CONFIG="$(readlink "$STARSHIP_CONFIG")"
fi
FISH_FROZEN_THEME="$HOME/.config/fish/conf.d/fish_frozen_theme.fish"

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

MODE="${1:-}"
if [ -z "$MODE" ]; then
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark; then
        MODE="dark"
    else
        MODE="light"
    fi
fi

case "$MODE" in
    dark)
        # Sketchybar
        cp "$CONFIG/sketchybar/colors-dark.sh" "$CONFIG/sketchybar/colors.sh"
        sketchybar --reload

        # Starship
        sed -i '' 's/^palette = .*/palette = "rose-pine"/' "$STARSHIP_CONFIG"

        # Terminal apps
        [ -f "$CONFIG/btop/btop.conf" ] && sed -i '' 's/^color_theme = .*/color_theme = "rose-pine"/' "$CONFIG/btop/btop.conf"
        [ -f "$CONFIG/fastfetch/rose-pine.jsonc" ] && cp "$CONFIG/fastfetch/rose-pine.jsonc" "$CONFIG/fastfetch/config.jsonc"

        # Fish
        fish -c 'fish_config theme choose "Rosé Pine"' 2>/dev/null
        [ -f "$FISH_FROZEN_THEME" ] && sed -i '' 's/^set --global fish_color_command .*/set --global fish_color_command c4a7e7/' "$FISH_FROZEN_THEME"

        # JankyBorders
        sed -i '' 's/^borders active_color=.*/borders active_color=0xffc4a7e7 inactive_color=0xff6e6a86 width=5.0 hidpi=on/' "$CONFIG/yabai/yabairc"
        pkill -x borders 2>/dev/null; sleep 0.2
        nohup /opt/homebrew/bin/borders active_color=0xffc4a7e7 inactive_color=0xff6e6a86 width=5.0 hidpi=on >/dev/null 2>&1 &
        ;;

    light)
        # Sketchybar
        cp "$CONFIG/sketchybar/colors-dawn.sh" "$CONFIG/sketchybar/colors.sh"
        sketchybar --reload

        # Starship
        sed -i '' 's/^palette = .*/palette = "rose-pine-dawn"/' "$STARSHIP_CONFIG"

        # Terminal apps
        [ -f "$CONFIG/btop/btop.conf" ] && sed -i '' 's/^color_theme = .*/color_theme = "rose-pine-dawn"/' "$CONFIG/btop/btop.conf"
        [ -f "$CONFIG/fastfetch/rose-pine-dawn.jsonc" ] && cp "$CONFIG/fastfetch/rose-pine-dawn.jsonc" "$CONFIG/fastfetch/config.jsonc"

        # Fish
        fish -c 'fish_config theme choose "Rosé Pine Dawn"' 2>/dev/null
        [ -f "$FISH_FROZEN_THEME" ] && sed -i '' 's/^set --global fish_color_command .*/set --global fish_color_command 907aa9/' "$FISH_FROZEN_THEME"

        # JankyBorders
        sed -i '' 's/^borders active_color=.*/borders active_color=0xff575279 inactive_color=0xff9893a5 width=5.0 hidpi=on/' "$CONFIG/yabai/yabairc"
        pkill -x borders 2>/dev/null; sleep 0.2
        nohup /opt/homebrew/bin/borders active_color=0xff575279 inactive_color=0xff9893a5 width=5.0 hidpi=on >/dev/null 2>&1 &
        ;;
esac

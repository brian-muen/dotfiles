#!/bin/bash
# setup.sh - sets up the system with the rice
# Assumes this repo is linked into ~/.config from ~/.dotfiles.
# Run: bash ~/.dotfiles/setup.sh

set -e

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ── Homebrew ──────────────────────────────────────────────────────────────────
echo "--- Homebrew ---"
if ! command -v brew &>/dev/null; then
    echo "Please install Homebrew first! https://brew.sh/"
    exit 1
fi

# ── Taps ──────────────────────────────────────────────────────────────────────
echo "--- Taps ---"
brew tap cormacrelf/tap
brew tap FelixKratz/formulae

# ── Packages ──────────────────────────────────────────────────────────────────
echo "--- Packages ---"
brew install \
    borders \
    btop \
    cmatrix \
    dark-notify \
    fastfetch \
    fish \
    fisher \
    helix \
    browsh \
    openjdk@21 \
    sketchybar \
    starship \
    tmux \
    yabai

echo "--- Casks ---"
[ -d /Applications/Ghostty.app ] || brew install --cask ghostty
[ -d /Applications/Raycast.app ] || brew install --cask raycast
brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 || brew install --cask font-jetbrains-mono-nerd-font

# ── Fish shell ────────────────────────────────────────────────────────────────
echo "--- Fish shell ---"
echo "Fish is installed and configured, but the login shell is left unchanged."

# ── Fisher plugins (reads from fish/fish_plugins) ─────────────────────────────
echo "--- Fisher plugins ---"
fish -c "fisher update"

# ── Script permissions ────────────────────────────────────────────────────────
echo "--- Script permissions ---"
chmod +x "$HOME/.config/switch-theme.sh"
[ -f "$HOME/.dotfiles/set-lain-wallpaper.sh" ] && chmod +x "$HOME/.dotfiles/set-lain-wallpaper.sh"
find "$HOME/.config/sketchybar/plugins" -type f -name "*.sh" -exec chmod +x {} \;

if [ ! -e "$HOME/.config/assets" ]; then
    ln -s "$HOME/.dotfiles/assets" "$HOME/.config/assets"
fi

# ── Yabai scripting addition sudoers entry ────────────────────────────────────
echo "--- Yabai scripting addition ---"
YABAI_PATH="$(brew --prefix)/bin/yabai"
SUDOERS_FILE="/private/etc/sudoers.d/yabai"
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 "$YABAI_PATH" | cut -d ' ' -f 1) $YABAI_PATH --load-sa" \
    | sudo tee "$SUDOERS_FILE" >/dev/null
sudo chmod 440 "$SUDOERS_FILE"

# ── Dark-notify LaunchAgent ───────────────────────────────────────────────────
echo "--- Automatic theme switching ---"
PLIST="$HOME/Library/LaunchAgents/com.user.dark-notify.plist"
launchctl unload "$PLIST" 2>/dev/null || true

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.dark-notify</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/dark-notify</string>
        <string>-c</string>
        <string>$HOME/.config/switch-theme.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/dark-notify.err</string>
</dict>
</plist>
EOF

launchctl load "$PLIST"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "Done! Restart for the changes to take effect, then run:"
echo ""
echo "  yabai --start-service"
echo "  brew services start sketchybar"
echo ""
echo "A few things to note:"
echo ""
echo "1. SIP must be partially disabled for yabai's scripting addition: https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection"
echo "   After each 'brew upgrade yabai', re-run the sudoers block in this script"
echo ""
echo "2. The automatic theme switcher follows your system appearance. To set a Lain wallpaper, run ~/.dotfiles/set-lain-wallpaper.sh"
echo ""
echo "3. Uninstalling the rice is a manual process. You will need to remove the installed packages, the LaunchAgent, and any configuration files you no longer want."
echo ""
echo "Hope you enjoy your new setup! I encourage you to explore the configuration files and customize them to your liking. The true power of a rice is in its customizability, so make it your own!"

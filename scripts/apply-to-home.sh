#!/usr/bin/env bash
# Install configs from this repo into the usual macOS locations.
# Run from anywhere: bash /path/to/dev-env/scripts/apply-to-home.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup() {
  local f="$1"
  [[ -e "$f" && ! -L "$f" ]] || return 0
  local b="${f}.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up $f -> $b"
  cp -p "$f" "$b"
}

echo "ROOT=$ROOT"

backup "${HOME}/.zshrc"
ln -sf "${ROOT}/shell/zshrc" "${HOME}/.zshrc"
echo "Linked ~/.zshrc -> shell/zshrc"

mkdir -p "${HOME}/.config/ghostty"
backup "${HOME}/.config/ghostty/config"
ln -sf "${ROOT}/ghostty/config" "${HOME}/.config/ghostty/config"
echo "Linked ~/.config/ghostty/config -> ghostty/config"

mkdir -p "${HOME}/.warp"
backup "${HOME}/.warp/settings.toml"
ln -sf "${ROOT}/warp/settings.toml" "${HOME}/.warp/settings.toml"
echo "Linked ~/.warp/settings.toml -> warp/settings.toml"

ITP="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
ITPRIV="${HOME}/Library/Preferences/com.googlecode.iterm2.private.plist"
backup "$ITP"
backup "$ITPRIV"
plutil -convert binary1 "${ROOT}/iterm2/com.googlecode.iterm2.plist.xml" -o "$ITP"
plutil -convert binary1 "${ROOT}/iterm2/com.googlecode.iterm2.private.plist.xml" -o "$ITPRIV"
echo "Wrote iTerm2 plists from iterm2/*.plist.xml (quit iTerm2 first if settings do not stick)"

echo "Done."

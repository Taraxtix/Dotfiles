#!/bin/sh
set -eu

# Repo updates (pacman)
repo=0
if command -v checkupdates >/dev/null 2>&1; then
  repo="$(checkupdates 2>/dev/null | wc -l | tr -d ' ')"
fi

# AUR updates (yay)
aur=0
if command -v yay >/dev/null 2>&1; then
  aur="$(yay -Qua 2>/dev/null | wc -l | tr -d ' ')"
fi

total=$((repo + aur))

# Choose icon + class
if [ "$total" -eq 0 ]; then
  icon="󰏗"     # up-to-date
  class="ok"
else
  icon="󰚰"     # updates
  class="pending"
fi

# JSON output for Waybar
printf '{"text":"%s %s","class":"%s","tooltip":"Repo: %s\\nAUR: %s\\nTotal: %s\\n\\nClick: update now"}\n' \
  "$icon" "$total" "$class" "$repo" "$aur" "$total"


#!/bin/sh
set -eu

dir="${1:-}"
step="${2:-20}"

# 1 if floating, 0 if tiled
floating="$(hyprctl activewindow -j | jq -r '.floating')"

if [ "$floating" = "true" ]; then
  case "$dir" in
    l) hyprctl dispatch moveactive -- "-$step 0" ;;
    r) hyprctl dispatch moveactive  "$step 0" ;;
    u) hyprctl dispatch moveactive  "0 -$step" ;;
    d) hyprctl dispatch moveactive  "0 $step" ;;
    *) exit 1 ;;
  esac
else
  # tiled: move/swap in layout
  hyprctl dispatch movewindow "$dir"
fi


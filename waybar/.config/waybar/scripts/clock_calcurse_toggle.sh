#!/bin/sh
set -eu

state="$HOME/.cache/waybar/clockcal.mode"
mkdir -p "$(dirname "$state")"

mode="month"
[ -f "$state" ] && mode="$(cat "$state" 2>/dev/null || echo month)"

if [ "$mode" = "month" ]; then
  echo "year" >"$state"
else
  echo "month" >"$state"
fi

# Reload Waybar so the tooltip refreshes instantly
killall -RTMIN+8 waybar


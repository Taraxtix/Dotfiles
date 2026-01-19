#!/bin/sh
set -eu

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-zoom-still.pid"

if [ -f "$PIDFILE" ]; then
  pid="$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  kill "$pid" 2>/dev/null || true
fi

# Exit submap
hyprctl dispatch submap reset >/dev/null
hyprctl -q keyword cursor:zoom_factor 1

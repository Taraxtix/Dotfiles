#!/bin/sh
set -eu

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-zoom-still.pid"

# If already running, don't start another
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  exit 0
fi

# Start a freeze that stays alive until we kill it.
# still freezes until the provided command exits. :contentReference[oaicite:2]{index=2}
still -p -c 'sh -c "trap : TERM INT; while :; do sleep 3600; done"' &
echo $! >"$PIDFILE"

# Enter hyprland zoom submap
hyprctl dispatch submap zoom >/dev/null


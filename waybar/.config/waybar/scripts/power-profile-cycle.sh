#!/bin/sh
set -eu

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-powerprofile"
OVERRIDE_FILE="$CACHE_DIR/override_profile"
OVERRIDE_AC_FILE="$CACHE_DIR/override_ac"
LAST_AC_FILE="$CACHE_DIR/last_ac"

mkdir -p "$CACHE_DIR"

# Your machine uses this exact sysfs path:
AC_FILE="/sys/class/power_supply/AC/online"
ac="$(cat "$AC_FILE" 2>/dev/null || echo 0)"

cur="$(powerprofilesctl get 2>/dev/null || echo balanced)"

# Cycle order (keep power-saver if you want it)
case "$cur" in
  power-saver) next="balanced" ;;
  balanced)    next="performance" ;;
  performance) next="power-saver" ;;
  *)           next="balanced" ;;
esac

# Apply
if [ "$cur" != "$next" ]; then
  powerprofilesctl set "$next"
fi

# Sticky override until next AC transition
printf '%s' "$next" > "$OVERRIDE_FILE"
printf '%s' "$ac"   > "$OVERRIDE_AC_FILE"
printf '%s' "$ac"   > "$LAST_AC_FILE"

# Instant Waybar refresh
pkill -RTMIN+9 waybar 2>/dev/null || true


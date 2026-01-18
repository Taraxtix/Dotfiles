#!/bin/sh
set -eu

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-powerprofile"
OVERRIDE_FILE="$CACHE_DIR/override_profile"
OVERRIDE_AC_FILE="$CACHE_DIR/override_ac"
LAST_AC_FILE="$CACHE_DIR/last_ac"

mkdir -p "$CACHE_DIR"

AC_FILE="/sys/class/power_supply/AC/online"
ac="$(cat "$AC_FILE" 2>/dev/null || echo 0)"

# Default target based on AC
if [ "$ac" = "1" ]; then
  default="performance"
else
  default="balanced"
fi

# Detect AC transition (for clearing override)
last_ac=""
if [ -f "$LAST_AC_FILE" ]; then
  last_ac="$(cat "$LAST_AC_FILE" 2>/dev/null || echo "")"
fi

ac_changed=0
if [ "$last_ac" != "" ] && [ "$last_ac" != "$ac" ]; then
  ac_changed=1
fi

# If AC state changed, clear override
if [ "$ac_changed" -eq 1 ]; then
  rm -f "$OVERRIDE_FILE" "$OVERRIDE_AC_FILE"
fi

# Decide target
target="$default"
if [ -f "$OVERRIDE_FILE" ] && [ -f "$OVERRIDE_AC_FILE" ]; then
  override_ac="$(cat "$OVERRIDE_AC_FILE" 2>/dev/null || echo "")"
  # Only honor override if it was set in the same AC state
  if [ "$override_ac" = "$ac" ]; then
    target="$(cat "$OVERRIDE_FILE" 2>/dev/null || echo "$default")"
  else
    # AC changed since override set -> clear it
    rm -f "$OVERRIDE_FILE" "$OVERRIDE_AC_FILE"
    target="$default"
  fi
fi

# Apply only if needed
current="$(powerprofilesctl get 2>/dev/null || echo "")"
if [ "$current" != "$target" ]; then
  powerprofilesctl set "$target"
  pkill -RTMIN+9 waybar 2>/dev/null || true
fi

# Update last AC state
printf '%s' "$ac" > "$LAST_AC_FILE"


#!/bin/bash

CACHE_FILE="$HOME/.config/hypr/custom_script/laptop_keyboard_disabled.cache"
DEVICE="at-translated-set-2-keyboard"

if [ -f "$CACHE_FILE" ]; then
  rm "$CACHE_FILE"
  hyprctl keyword "device[$DEVICE]:enabled" 1
else
  touch "$CACHE_FILE"
  hyprctl keyword "device[$DEVICE]:enabled" 0
fi

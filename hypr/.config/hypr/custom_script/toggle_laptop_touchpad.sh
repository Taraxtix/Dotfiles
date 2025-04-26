#!/bin/bash

CACHE_FILE="$HOME/.config/hypr/custom_script/laptop_touchpad_disabled.cache"
DEVICE="synps/2-synaptics-touchpad"

if [ -f "$CACHE_FILE" ]; then
  rm "$CACHE_FILE"
  hyprctl keyword "device[$DEVICE]:enabled" 1
else
  touch "$CACHE_FILE"
  hyprctl keyword "device[$DEVICE]:enabled" 0
fi

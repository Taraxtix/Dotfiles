#!/bin/sh

set -e

TEMP_PATH="/tmp/current_screenshot_in_progress.png"
OUTPUT="~/Pictures/Screenshot/$(date '+%d-%m-%y_%H:%M:%S').png"


mkdir -p ~/Pictures/Screenshot/

if [ -z $1 ]; then
    REGION="$(slurp || true)"
    if [ -z $REGION ]; then
	sleep 0.1 && grim -c $TEMP_PATH
    else
	grim -c -g "$REGION" $TEMP_PATH 
    fi
else # Assume `instant`
    grim -c $TEMP_PATH
fi

satty --filename $TEMP_PATH --output-filename $OUTPUT

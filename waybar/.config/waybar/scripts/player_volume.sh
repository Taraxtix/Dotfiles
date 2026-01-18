#!/bin/sh

set -e

VOLUME=$(playerctl volume)

if [ $1 = "up" ]; then
    if [ "$(echo "$VOLUME <= 0.9" | bc)" = "1" ]; then
        playerctl volume 0.1+ && sleep 0.5 && pkill -SIGRTMIN+10 waybar
    else
	playerctl volume 1 && sleep 0.5 && pkill -SIGRTMIN+10 waybar
    fi
else
    if [ "$(echo "$VOLUME >= 0.1" | bc)" = "1" ]; then
	playerctl volume 0.1- && sleep 0.5 && pkill -SIGRTMIN+10 waybar
    else
	playerctl volume 0 && sleep 0.5 && pkill -SIGRTMIN+10 waybar
    fi
fi


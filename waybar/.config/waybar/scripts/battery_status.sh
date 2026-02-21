#!/bin/sh

LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
LEVEL_IDX=$(echo "$LEVEL / 10" | bc)

PLUGGED=$(cat /sys/class/power_supply/AC/online)

# Read previous level from cache
PREVIOUS_LEVEL=$(cat ~/.config/waybar/scripts/cache/battery_level.cache)
# Write current level to cache 
echo "$LEVEL" > ~/.config/waybar/scripts/cache/battery_level.cache

if [ $(echo "$LEVEL < 50 && $PREVIOUS_LEVEL >= 50" | bc) = "1" ]; then
	~/.config/mako/scripts/notify.sh "Battery level bellow 50%" "" warning "/usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg" -a ""
fi

if [ $(echo "$LEVEL < 30 && $PREVIOUS_LEVEL >= 30" | bc) = "1" ]; then
	~/.config/mako/scripts/notify.sh "Battery level bellow 30%" "" warning "/usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg" -a ""
fi

if [ $(echo "$LEVEL < 10 && $PREVIOUS_LEVEL >= 10" | bc) = "1" ]; then
	~/.config/mako/scripts/notify.sh "Battery level bellow 10%" "" critical "/usr/share/icons/Adwaita/symbolic/status/battery-action-symbolic.svg" -a ""
fi

if [ $PLUGGED = "0" ]; then
	ICONS=("󰂎 " "󰁺 " "󰁻 " "󰁼 " "󰁽 " "󰁾 " "󰁿 " "󰂀 " "󰂁 " "󰂂 " "󰁹 ")
else
	ICONS=("󰢟 " "󰢜 " "󰂆 " "󰂇 " "󰂈 " "󰢝 " "󰂉 " "󰢞 " "󰂊 " "󰂋 " "󰂅 ")
fi

TEXT="${ICONS[$LEVEL_IDX]}$LEVEL%"

printf '{"text":"%s"}' "$TEXT"

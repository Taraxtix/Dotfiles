#!/bin/sh

choice=$(printf "⏻ Shutdown\n󰜉 Reboot\n󰐥 Logout" | wofi --dmenu --prompt "Power")

case "$choice" in
  *Shutdown*)
    systemctl poweroff
    ;;
  *Reboot*)
    systemctl reboot
    ;;
  *Logout*)
    hyprctl dispatch exit
    ;;
esac


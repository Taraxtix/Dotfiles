#!/bin/sh

# Usage: notify.sh LEVEL MESSAGE OVERRIDE_ICON

case "$2" in
    log)
	    CATEGORY=log
	    URGENCY=low
	    ICON=${3:-""};;
    info)
	    CATEGORY=info
	    URGENCY=low
	    ICON=${3:-"/usr/share/icons/hicolor/scalable/status/info-circle-solid.svg"};;
    warning)
	    CATEGORY=warning
	    URGENCY=normal
	    ICON=${3:-"/usr/share/icons/hicolor/scalable/status/warning-triangle-solid.svg"};;
    error) 
	    CATEGORY=error
	    URGENCY=critical
	    ICON=${3:-"/usr/share/icons/hicolor/scalable/status/xmark-circle-solid.svg"};;
    critical)
	    CATEGORY=critical
	    URGENCY=critical
	    ICON=${3:-"/usr/share/icons/hicolor/scalable/status/warning-circle-solid.svg"};;
    *)
	    CATEGORY=neutral
	    URGENCY=normal
	    ICON=${3:-""};;
esac

MESSAGE="$1"
shift 3

echo $@

notify-send -c $CATEGORY -u $URGENCY "$MESSAGE" -i "$ICON" "$@"

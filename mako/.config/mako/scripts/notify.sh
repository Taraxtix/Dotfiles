#!/bin/sh

# Usage: notify.sh TITLE BODY LEVEL OVERRIDE_ICON

case "$3" in
    log)
	    CATEGORY=log
	    URGENCY=low
	    ICON=${4:-""};;
    info)
	    CATEGORY=info
	    URGENCY=low
	    ICON=${4:-"/usr/share/icons/hicolor/scalable/status/info-circle-solid.svg"};;
    warning)
	    CATEGORY=warning
	    URGENCY=normal
	    ICON=${4:-"/usr/share/icons/hicolor/scalable/status/warning-triangle-solid.svg"};;
    error) 
	    CATEGORY=error
	    URGENCY=critical
	    ICON=${4:-"/usr/share/icons/hicolor/scalable/status/xmark-circle-solid.svg"};;
    critical)
	    CATEGORY=critical
	    URGENCY=critical
	    ICON=${4:-"/usr/share/icons/hicolor/scalable/status/warning-circle-solid.svg"};;
    *)
	    CATEGORY=neutral
	    URGENCY=normal
	    ICON=${4:-""};;
esac

TITLE="$1"
BODY="$2"
shift 4

notify-send -c $CATEGORY -u $URGENCY "$TITLE" "$BODY" -i "$ICON" "$@"

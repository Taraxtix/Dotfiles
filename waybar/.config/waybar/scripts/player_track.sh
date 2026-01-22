#!/bin/sh

set -e

trim() { # trim "<string>" <maxlen>
  s=$1
  max=$2
  [ "${#s}" -le "$max" ] && {
    printf '%s' "$s"
    return
  }
  printf '%s…' "$(printf '%s' "$s" | cut -c "1-$max")"
}

json_escape() {
  # shellcheck disable=SC2001
  printf %s "$1" |
    sed 's/\\/\\\\/g; s/"/\\"/g; s/&/\&amp;/g' |
    sed ':a;N;$!ba;s/\n/\\n/g'
}

STATUS=$(playerctl status)
TITLE_RAW=$(playerctl metadata title)
TITLE=$(json_escape "$(trim "$TITLE_RAW" 30)")
ARTIST_RAW=$(playerctl metadata artist)
ARTIST=$(json_escape "$(trim "$ARTIST_RAW" 30)")
VOLUME_FLOAT=$(echo "$(playerctl volume) * 100" | bc)
VOLUME=$(printf "%.0f" "$VOLUME_FLOAT")

if [ "$STATUS" = "Playing" ]; then
  ICON=" "
else
  ICON=" "
fi

printf '{"text":"  %s%% %s%s - %s",}' "$VOLUME" "$ICON" "$TITLE" "$ARTIST"

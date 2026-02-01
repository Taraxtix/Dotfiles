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
TITLE_STRIPPED=$(echo "$TITLE_RAW" | sed 's/[[:space:]]*(.*)$//')
TITLE=$(json_escape "$(trim "$TITLE_STRIPPED" 30)")
ARTIST_RAW=$(playerctl metadata artist)
ARTIST=$(json_escape "$(trim "$ARTIST_RAW" 30)")

if [ "$STATUS" = "Playing" ]; then
  ICON=" "
else
  ICON=" "
fi

printf '{"text":"%s%s - %s","tooltip":"%s - %s"}' "$ICON" "$TITLE" "$ARTIST" "$(json_escape "$TITLE_RAW")" "$(json_escape "$ARTIST_RAW")"

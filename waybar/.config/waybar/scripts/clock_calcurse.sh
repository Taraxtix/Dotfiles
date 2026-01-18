#!/bin/sh
set -eu

state="$HOME/.cache/waybar/clockcal.mode"
mode="month"
[ -f "$state" ] && mode="$(cat "$state" 2>/dev/null || echo month)"

# --- what to show in the bar itself
TEXT="$(date '+%d/%m/%y - %H:%M')"

# --- build a month calendar tooltip and highlight days with calcurse items
YEAR="$(date +%Y)"
MONTH="$(date +%m)"
TODAY="$(date +%-d)"

FIRST="$(date +%Y-%m-01)"
LAST="$(date -d "$FIRST +1 month -1 day" +%Y-%m-%d)"

HLDAYS="$(
calcurse -Q \
  --input-datefmt 4 \
  --from "$FIRST" --to "$LAST" \
  --filter-type cal \
  --format-apt '%(start:%-d)\n' \
  --format-recur-apt '%(start:%-d)\n' \
  --format-event '%(start:%-d)\n' \
  --format-recur-event '%(start:%-d)\n' \
| grep -E '^[0-9]{1,2}$' \
| sort -n -u
)"

if [ "$mode" = "year" ]; then
  # Year view (lightweight; no per-day highlight)
  CALENDAR="$(cal -m -y --color)"
else
  # Month view (with calcurse highlights + today underline)
  CALENDAR="$(
    cal -m "$MONTH" "$YEAR" | awk -v hl="$HLDAYS" -v today="$TODAY" '
      BEGIN{
        split(hl, a, " ");
        for (i in a) if (a[i] != "") h[a[i]] = 1;
      }
      {
        if (NR <= 2) { print; next; }

        out="";
        for (i=1; i<=NF; i++) {
          tok=$i;
          if (tok ~ /^[0-9]+$/) {
            d = tok + 0;
            if (d == today && h[d]) {
              tok = sprintf("<span foreground=\"#7aa2f7\" underline=\"single\"><b>%2d</b></span>", d);
            } else if (d == today) {
              tok = sprintf("<span underline=\"single\"><b>%2d</b></span>", d);
            } else if (h[d]) {
              tok = sprintf("<span foreground=\"#7aa2f7\"><b>%2d</b></span>", d);
            } else {
              tok = sprintf("%2d", d);
            }
          }
          out = out (i==1 ? "" : " ") tok;
        }
        print out;
      }
    '
  )"
fi

TOOLTIP="<tt><big>${CALENDAR}</big></tt>"

# Escape for JSON (\, ", newlines)
json_escape() {
  # shellcheck disable=SC2001
  printf %s "$1" \
    | sed 's/\\/\\\\/g; s/"/\\"/g' \
    | sed ':a;N;$!ba;s/\n/\\n/g'
}

printf '{ "text": "%s", "tooltip": "%s" }\n' \
  "$(json_escape "$TEXT")" \
  "$(json_escape "$TOOLTIP")"


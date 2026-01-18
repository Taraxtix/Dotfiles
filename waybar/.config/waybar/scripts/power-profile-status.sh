#!/bin/sh

set -euo pipefail

profile="$(powerprofilesctl get)"

case "$profile" in
  power-saver)
    icon="󰾆 "
    class="power-saver"
    ;;
  balanced)
    icon="󰾅 "
    class="balanced"
    ;;
  performance)
    icon="󰓅 "
    class="performance"
    ;;
  *)
    icon="?"
    class="unknown"
    ;;
esac

printf '{"text":"%s","class":"%s","tooltip":"Power profile: %s"}\n' \
  "$icon" "$class" "$profile"


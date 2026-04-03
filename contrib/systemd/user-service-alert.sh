#!/bin/sh

set -e
eval "$(systemctl --user show "$1" --property=InvocationID)"
# shellcheck disable=SC2154
LOG_PREVIEW=$(journalctl --user --invocation="${InvocationID}" -l --no-pager --output=cat)
case $(notify-send \
    --urgency=critical \
    --icon=dialog-error \
    --action="show=Show Full Logs" \
    "Service Failed: $1" \
    "$LOG_PREVIEW") in
  show)
    TMP=$(mktemp -t service-alert-XXXXXXXXXXXXXXXX.log);
    journalctl --user --invocation="${InvocationID}" > "$TMP";
    xdg-open "$TMP";
    ;;
esac

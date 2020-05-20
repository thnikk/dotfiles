#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if [[ $HOST == "thnikk-desktop" ]]; then
    # Since this is specific to my configuration:
    polybar bar1 &
    polybar bar2 &
else
    polybar default &
fi

echo "Bars launched..."

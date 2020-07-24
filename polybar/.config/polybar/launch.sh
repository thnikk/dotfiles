#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if [ $1 == 0 ]; then
# Launch bar1 and bar2
polybar bar1 &
polybar bar2 &
#polybar tray &
elif [ $1 == 1 ]; then
polybar -c ~/.config/polybar/config.alt default &
fi

echo "Bars launched..."

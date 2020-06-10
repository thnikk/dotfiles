#!/usr/bin/dash

# Restart polybar (this is faster than pgrepping and launching.)
pkill -USR1 polybar
# If restart fails, start polybar
if [ $? -ne 0 ]; then
    if [ "$HOST" = "thnikk-desktop" ]; then
        # Since this is specific to my configuration:
        polybar bar1 &
        polybar bar2 &
    else
        polybar default &
    fi
fi


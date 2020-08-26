#!/usr/bin/dash

# Terminate already running bar instances
pkill -USR1 polybar

# If restart fails, start polybar
#if [ $? -ne 0 ]; then
    #case $HOST in
        #*desktop)
            #echo "Spawning desktop bar."
            #polybar bar1 &
            #polybar bar2 & ;;
        #*laptop)
            #echo "Spawning laptop bar."
##            polybar -c ~/.config/polybar/config.alt default & ;;
            #polybar default & ;;
    #esac
#fi

if [ $? -ne 0 ]; then
    polybar default &
fi

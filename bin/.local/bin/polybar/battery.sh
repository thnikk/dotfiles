#!/bin/bash



# Check if fontawesome exists
if fc-list | grep -q "Font Awesome"; then
    ICON_ENABLE=1
fi


if [ -f ~/.cache/bat_detail ] && which upower >/dev/null; then

    PERCENTAGE=$(upower -d | grep "percentage" | tail -1 | awk -F ':' '{print $2}' | awk '{$1=$1};1' | awk -F'.' '{print $1}')
    TL=$(upower -d | grep "time to empty" | tail -1 | awk -F ':' '{print $2}' | awk '{$1=$1};1' | sed 's/ hours/h/g')


    if [ $ICON_ENABLE -eq 1 ]; then
        if [ $PERCENTAGE -gt 80 ]; then
            ICON=" "
        elif [ $PERCENTAGE -gt 60 ]; then
            ICON=" "
        elif [ $PERCENTAGE -gt 40 ]; then
            ICON=" "
        elif [ $PERCENTAGE -gt 20 ]; then
            ICON=" "
        elif [ $PERCENTAGE -gt 0 ]; then
            ICON=" "
        fi
    fi

    echo "$ICON$PERCENTAGE% $TL"

else

    COUNT=0
    for d in /sys/class/power_supply/*; do
        case $d in
            *AC) continue ;;
            # If a system battery:
            *BAT*)
                [ $COUNT -gt 0 ] && echo -n " "
                PERCENTAGE="$(cat "$d/energy_now")"
                CAPACITY="$(cat "$d/energy_full")"
                PERCENTAGE=$(( PERCENTAGE*100/CAPACITY ))

                if [ $ICON_ENABLE -eq 1 ]; then
                    if [ $PERCENTAGE -gt 80 ]; then
                        ICON=" "
                    elif [ $PERCENTAGE -gt 60 ]; then
                        ICON=" "
                    elif [ $PERCENTAGE -gt 40 ]; then
                        ICON=" "
                    elif [ $PERCENTAGE -gt 20 ]; then
                        ICON=" "
                    elif [ $PERCENTAGE -gt 0 ]; then
                        ICON=" "
                    fi
                fi
            ;;
            # If other
            *)
                [ $COUNT -gt 0 ] && echo -n " "
                case $d in
                    # Dualshock 4
                    *sony_controller* | *xpadneo*) ICON=" " ;;
                    # Logitech mouse
                    *hidpp*) ICON=" ";;
                    *) ICON="?";;
                esac
                if [ -f $d/capacity ]; then
                    PERCENTAGE="$(cat "$d/capacity")"
                elif [ -f $d/capacity_level ]; then
                        case $(cat $d/capacity_level) in
                            Full) PERCENTAGE=100 ;;
                            High) PERCENTAGE=80 ;;
                            Normal) PERCENTAGE=60 ;;
                            Low) PERCENTAGE=40 ;;
                            Critical) PERCENTAGE=20 ;;
                            *) LELVEL="??" ;;
                        esac
                fi
            ;;
        esac
        echo -n "$ICON$PERCENTAGE%"
        COUNT=$(( COUNT+1 ))
    done

fi

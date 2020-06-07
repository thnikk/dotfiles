#!/usr/bin/dash

STATE="$HOME/.cache/polynet"
[ -f $STATE ] || echo "0" > "$STATE"
STATEVAL="$(cat $STATE)"

j=0
# Check all networking devices
for i in /sys/class/net/*; do
    if [ "$(basename $i)" != "lo" ] && [ "$(basename $i)" != "virbr0" ] && [ "$(basename $i)" != "vnet0" ] && [ -e "$i/carrier" ] ;then
        CARRIER=$(cat "$i/carrier" 2>/dev/null)
        # If device is connected...
        if [ "$CARRIER" = "1" ];then
            # echo "$i is connected."
            j=$((j+1))
            # if [ $j -gt 1 ]; then echo -n " "; fi
            # Look for line with subnet mask to find ip and strip it out
            IPADDR=$(echo -n "$(ip addr show "$(basename $i)" | grep -m 1 "/24" | grep -v "virbr" | awk '{print $2}' | sed 1q )")
            # echo $IPADDR
            IPADDR="${IPADDR%%/24*}"
        fi
    fi
done

if [ $j -eq "0" ];then
    echo "Disconnected"
else
    case $STATEVAL in
        0)
            logfile="${XDG_CACHE_HOME:-$HOME/.cache}/netlog"
            [ -f "$logfile" ] && touch "$logfile"
            prevdata="$(cat "$logfile")" || echo "0 0" > "$logfile"

            rxcurrent="$(($(paste -d '+' /sys/class/net/[ew]*/statistics/rx_bytes)))"
            txcurrent="$(($(paste -d '+' /sys/class/net/[^lo]*/statistics/tx_bytes)))"

            rxMiB="$(((rxcurrent-${prevdata%% *})/1024/1024))"
            txMiB="$(((txcurrent-${prevdata##* })/1024/1024))"

            uicon="%{F#747c84}%{F-}"
            dicon="%{F#747c84}%{F-}"
            udicon="%{F#747c84}%{F-}"

            echo "$rxcurrent $txcurrent" > "$logfile"
            echo "$IPADDR $rxMiB/$txMiB"
            ;;
        1)
            echo "$(iw wlp3s0 info | grep -Po '(?<=ssid).*' | tr -d ' ')"
            ;;
    esac
fi


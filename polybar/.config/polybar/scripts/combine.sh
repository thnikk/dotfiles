#!/usr/bin/dash

# Set variables ahead of time to avoid errors
battery_level_0=0
battery_level_1=0
battery_max_0=0
battery_max_1=0

# Path to batteries
path_battery_0="/sys/class/power_supply/BAT0"
path_battery_1="/sys/class/power_supply/BAT1"

# Set variables from files if they exist
[ -f "$path_battery_0/energy_now" ] && battery_level_0=$(cat "$path_battery_0/energy_now")
[ -f "$path_battery_0/energy_full" ] && battery_max_0=$(cat "$path_battery_0/energy_full")
[ -f "$path_battery_1/energy_now" ] && battery_level_1=$(cat "$path_battery_1/energy_now")
[ -f "$path_battery_1/energy_full" ] && battery_max_1=$(cat "$path_battery_1/energy_full")

# Add levels together
battery_level=$(( battery_level_0 + battery_level_1 ))
# Add max levels together
battery_max=$(( battery_max_0 + battery_max_1 ))
# Multiply first to avoid using floats
battery_percent=$(( battery_level * 100 ))
# Divide to get final percentage
battery_percent=$(( battery_percent / battery_max ))

# Force percentage to always span two digits
[ $battery_percent -lt 10 ] && echo -n " "
[ $battery_percent -eq 100 ] && battery_percent=99

UPD() {
    ping -c1 google.com >/dev/null 2>/dev/null || exit 1

    # Check for updates once an hour
    if [ "$(stat -c %y ~/.cache/updates 2>/dev/null | cut -d':' -f1)" != "$(date '+%Y-%m-%d %H')" ]; then
        # Check main repos and aur
        updates_arch=$(checkupdates 2> /dev/null | wc -l )
        updates_aur=$(yay -Qum 2> /dev/null | wc -l)
        echo $(( "$updates_arch"+"$updates_aur" )) > ~/.cache/updates
    fi

    updates=$(cat ~/.cache/updates)

    if [ "$updates" -gt 0 ]; then
        echo "UPD: $updates | "
    else
        echo ""
    fi
}

DATE="$(date +%a,\ %b\ %+d)"
TIME="$(date +%I:%M%p)"
BAT="BAT: $battery_percent%"

echo "$(UPD)$BAT | $DATE | $TIME "

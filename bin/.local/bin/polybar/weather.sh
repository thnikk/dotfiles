#!/bin/sh
# (Slightly less than) simple script for pulling nicely formatted weather data for polybar based on IP address.

# Temp formats
# Use m for celsius and u for farenheight
F="u"
# Change to desired format
ACTIVE=$F

get_weather() {
    curl -s "wttr.in/?format=%C+%t&$ACTIVE" |
        sed 's/\s*//g'
}

# First, check to see if the file exists in the first place
[ -f ~/.cache/weather ] ||
    # If not, make it
    get_weather > ~/.cache/weather

# If connected to the internet, update cache file if an hour has passed.
if [ "$(ping -c 1 google.com 2>/dev/null)" ]; then
    # If the file is over an hour old or a check has been forced with "-f"
    if [ "$(stat -c %y ~/.cache/weather 2>/dev/null | cut -d':' -f1)" != "$(date '+%Y-%m-%d %H')" ] || [ "$1" = "-f" ]; then
        # Save new weather data as variable
        WEATHER="$(get_weather)"
        # Only overwrite cache if valid new weather info is found
        echo "$WEATHER" | grep -q "Unknown" || echo "$WEATHER" > ~/.cache/weather
    fi
fi

# Cat cache file to variable for pulling additional info
PULL=$(cat ~/.cache/weather)

# Separate icon text and temperature
ICON=$(echo "$PULL" | awk -F '+' '{print $1}')
# Remove + and ° from temperature
TEMP=$(echo "$PULL" | awk -F '+' '{print $2}' | sed 's/°//g' )

# Replace weather description with icons
case $ICON in
	*"unny"* ) ICON="";;
	*"loudy"*) ICON="";;
	*"ain"*) ICON="";;
	*"now"*) ICON="";;
    "Clear"*) ICON="";;
    *"haze"* | *"Overcast"* | *"Mist"*) ICON="";;
	*) ICON="?";;
esac


# Return full string
[ "$1" = "-p" ] && echo "%{F#747c84}$ICON%{F-}%{T3} %{T-}$TEMP" || echo "$ICON $TEMP"

#!/bin/sh
# (Slightly less than) simple script for pulling nicely formatted weather data for polybar based on IP address.

# Temp formats
C="m"
F="u"
# Change to desired format
ACTIVE=$F

# First, check to see if the file exists in the first place
[ -f ~/.cache/weather ] ||
    # If not, make it
    curl -s "wttr.in/?format=%C+%t&$ACTIVE" | sed 's/\s*//g'  > ~/.cache/weather

# Check for weather info every hour if connected to network
[ $(wget -q --spider http://google.com) ] &&
    [ "$(stat -c %y ~/.cache/weather 2>/dev/null | cut -d':' -f1)" != "$(date '+%Y-%m-%d %H')" ] &&
	curl -s "wttr.in/?format=%C+%t&$ACTIVE" | sed 's/\s*//g'  > ~/.cache/weather
# Alternate method
#[ "$(date -d"$(stat -c %y ~/.cache/weather | cut -f1 -d" ")" --iso-8601=hours)" != "$(date --iso-8601=hours)" ]

# Cat cache file to variable for pulling additional info
PULL=$(cat ~/.cache/weather)

# Separate icon text and temperature
ICON=$(echo "$PULL" | awk -F '+' '{print $1}')
# Remove + and ° from temperature
TEMP=$(echo "$PULL" | awk -F '+' '{print $2}' | sed 's/°//g' )

# Replace weather description with material icons
case $ICON in
	Sunny | Partlycloudy) ICON=
	;;
	Cloudy) ICON=
	;;
	*) ICON=?
	;;
esac


# Apply color to icon
ICON=$(echo "$ICON" | awk '{$1 = "%{F#747c84}"$1"%{F-}"; print}')

# Return full string
echo "$ICON%{T3} %{T-}$TEMP"

#!/usr/bin/env sh

# Get ram stats
MEM=$(free | grep Mem)
# Find used ram and multiply by 100 to avoid using floats
USED=$(( $(echo "$MEM" | awk '{print $3}') * 100 ))
# Find total ram
TOTAL=$(echo "$MEM" | awk '{print $2}')
# Calculate final percentage
PERCENTAGE="$(( USED/TOTAL ))"
# If the percentage is 100, bump it down to 99 to not take up a third digit.
# (this should never happen anyway)
[ $PERCENTAGE -eq 100 ] && PERCENTAGE="99"
# Add a space before the percentage if it's less than 10
[ $PERCENTAGE -lt 10 ] && PERCENTAGE=" $PERCENTAGE"
# Echo final percentage
echo "$PERCENTAGE%"

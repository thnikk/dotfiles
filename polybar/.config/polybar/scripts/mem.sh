#!/usr/bin/dash

# Get ram stats
MEM=$(free | grep Mem)
# Find used ram and multiply by 100 to avoid using floats
USED=$(( $(echo $MEM | awk '{print $3}') * 100 ))
# Find total ram
TOTAL=$(echo $MEM | awk '{print $2}')
# Echo final percentage
echo "$(( USED/TOTAL ))%"

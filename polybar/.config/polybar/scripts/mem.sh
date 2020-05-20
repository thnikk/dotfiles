#!/bin/bash

MEM=$(free | grep Mem)
USED=$(( $(echo $MEM | awk '{print $3}') * 100 ))
TOTAL=$(echo $MEM | awk '{print $2}')

echo "$(( USED/TOTAL ))%"

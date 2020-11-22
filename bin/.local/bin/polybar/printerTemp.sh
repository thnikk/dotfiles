#!/bin/bash

#declare -a arr=("simple" "spro" "spro2" "play" "play2")
#declare -a names=("S" "SP" "SP2" "P" "P2")
declare -a arr=("spro2")
declare -a names=("SP2")
declare -a output

count=0;
for i in "${arr[@]}"; do
    output[$count]="${names[count]}:$(mosquitto_sub -h 10.0.0.29 -t "$i/temperature/tool0" -C 1 |
    awk '{print $4}' |
    awk -F. '{print $1}')/$(mosquitto_sub -h 10.0.0.29 -t "$i/temperature/bed" -C 1 |
    awk '{print $4}' | awk -F. '{print $1}') "
    ((count++))
done

echo "${output[@]}"

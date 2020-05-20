#!/bin/bash

declare -a arr=("simple" "spro" "spro2" "play" "play2")
declare -a names=("S" "SP" "SP2" "P" "P2")

count=0;
for i in "${arr[@]}"; do
echo -n "${names[count]}:$(mosquitto_sub -h 10.0.0.20 -t $i/temperature/tool0 -C 1 |
    awk '{print $4}' |
    awk -F. '{print $1}')/$(mosquitto_sub -h 10.0.0.20 -t $i/temperature/bed -C 1 |
    awk '{print $4}' | awk -F. '{print $1}') "
    ((count++))
done

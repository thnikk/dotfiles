#!/bin/bash

if pkill picom; then
    sleep 0.5
    echo "Restarting picom"
    picom &
else
    echo "Picom not running"
fi

#!/bin/bash

while ! pgrep i3; do
    echo "i3 is not running!"
    sleep 5
done

while true; do
    # Continuously try to run script
    ~/.local/bin/anime-rpc
    echo "Failed to launch or some other problem."
    # If it dies or fails to launch, retry every 5 seconds
    sleep 5
done

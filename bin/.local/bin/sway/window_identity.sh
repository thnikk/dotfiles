#!/bin/bash
ID=$(swaymsg -t get_tree | jq -r "..|try select(.focused == true) | .app_id")
NAME=$(swaymsg -t get_tree | jq -r "..|try select(.focused == true) | .name")

notify-send "ID:$ID Name:$NAME"

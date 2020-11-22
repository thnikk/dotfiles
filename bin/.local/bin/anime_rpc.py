#!/usr/bin/env python3

import sys
import time
import gi
import re
import os
gi.require_version('Playerctl', '2.0')

from gi.repository import Playerctl, GLib
from pypresence import Presence
import pypresence.exceptions

cache = os.getenv("HOME") + '/.cache/lsa.cache'

manager = Playerctl.PlayerManager()

print("Starting RPC client...")
#RPC = Presence('440997014315204609')
RPC = Presence('738881382872252447')
to_clear = 0

def connect_rpc():
    while True:
        try:
            RPC.connect()
            print("RPC client connected")
            break
        except ConnectionRefusedError as e:
            print("Failed to connect to RPC! Trying again in 10 seconds...")
            time.sleep(10)
        except (FileNotFoundError, AttributeError) as e:
            print("RPC failed to connect due to Discord not being opened yet. Please open it. Reconnecting in 10 seconds...")
            time.sleep(10)

def setup_player(name):
    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status::playing', on_play, manager)
    player.connect('playback-status::paused', on_pause, manager)
    player.connect('metadata', on_metadata, manager)
    manager.manage_player(player)
    update(player)

def get_name(player):
    name = "%s" % (player.get_title())
    return name

def clean_name(name):
    name_no_ext = name.split(".",1)
    clean_name = name_no_ext[0]
    ex = re.sub("[\(\[].*?[\)\]]", "", clean_name).strip()
    return ex

def check(checkName):
    # If the cache file exists, check if the name of the show is in the list
    if os.path.isfile(cache):
        with open(cache) as f:
            datafile = f.readlines()
        for line in datafile:
            if checkName in line:
                print("File is in anime folder.")
                return True
        print ("File not in anime folder.")
        return False
    # If now, just pass the filename through to the next step
    else:
        return True

def update(player):
    status = player.get_property('status')
    global to_clear
    try:
        if status == "":
            internal_clear()
        elif status == "Playing":
            name = get_name(player)
            if check(name):
                RPC.update(state='Playing', details=clean_name(name), large_image='music', large_text=name, small_image='play')
                to_clear = 1
        elif status == "Paused":
            internal_clear()
    except pypresence.exceptions.InvalidID:
        print("Lost connection to Discord RPC! Attempting reconnection...")
        connect_rpc()

def on_play(player, status, manager):
    update(player)

def on_pause(player, status, manager):
    update(player)

def on_metadata(player, metadata, manager):
    update(player)

def on_player_add(manager, name):
    setup_player(name)

def on_player_remove(manager, player):
    if len(manager.props.players) < 1:
        internal_clear()
    else:
        update(manager.props.players[0])

def internal_clear():
    global to_clear
    if to_clear == 1:
        try:
            RPC.clear()
        except pypresence.exceptions.ServerError:
            connect_rpc()
        to_clear = 0

manager.connect('name-appeared', on_player_add)
manager.connect('player-vanished', on_player_remove)

# Start program, connect to Discord, setup existing players & hook into GLib's main loop
connect_rpc()

for name in manager.props.player_names:
    setup_player(name)

GLib.MainLoop().run()

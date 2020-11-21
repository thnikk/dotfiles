#!/usr/bin/python

from i3ipc import Connection, Event
from pypresence import Presence
import os
import time
import re
import psutil

# Create the Connection object that can be used to send commands and subscribe
# to events.
i3 = Connection()

# Discord RPC stuff
client_id = '738881382872252447'  # Put your Client ID here, this is a fake ID
RPC = Presence(client_id,pipe=0)  # Initialize the client class

oldname = ''
clear = 0
cache = os.getenv("HOME") + '/.cache/lsa.cache'
connected = 0

# Function for checking if a file playing in MPV exists in cache file
def check(checkName):
    with open(cache) as f:
        datafile = f.readlines()
    for line in datafile:
        if checkName in line:
            print("File is in anime folder.")
            return True
    print ("File not in anime folder.")
    return False

def Connect():
    # Connect to discord server
    RPC.connect()

# Check if discord is running
while "Discord" not in (p.name() for p in psutil.process_iter()):
    # If not, trap
    print("Waiting for discord to open.")
    time.sleep(5)

Connect()

while True:
    # Check if discord is running
    while "Discord" not in (p.name() for p in psutil.process_iter()):
        # If not, trap
        print("Waiting for discord to open.")
        time.sleep(5)
        connected = 0

    if connected == 0:
        Connect()
        connected = 1

    # Get the name of the focused window
    focused = i3.get_tree().find_focused()
    if " - mpv" in focused.name:
        # First, remove everything after file extension
        split_name = focused.name.split(".",1)
        # Copy contents to new variable for easier manipulation
        clean_name = split_name[0]
        # Strip out all brackets
        name = re.sub("[\(\[].*?[\)\]]", "", clean_name).strip()
        # If the filename is different from the last time it was checked...
        if oldname != name:
            # Check if file exists in anime folder
            if check(focused.name.replace(' - mpv','')):
                # If so, update discord rpc
                print ("Watching", name)
                RPC.update(details=name)  # Set the presence
                oldname = name
        clear = 1
    else:
        if clear == 1:
            print("MPV is no longer the active window, clearing RPC.")
            RPC.clear()
            oldname = ''
            clear = 0
    time.sleep(15)


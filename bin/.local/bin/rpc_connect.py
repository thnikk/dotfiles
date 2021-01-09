#!/usr/bin/env python3
# This simple script will report the first argument given to Discord's RPC.
# The status will clear upon killing the script.

import sys
import time
import re

from pypresence import Presence
import pypresence.exceptions

RPC = Presence('738881382872252447')

RPC.connect()
name=sys.argv[1]
RPC.update(state='Playing', details=name, large_image='music', large_text=name, small_image='play')
while True:
    time.sleep(1)


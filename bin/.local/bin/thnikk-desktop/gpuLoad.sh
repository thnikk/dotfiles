#!/bin/bash

sudo /bin/cat /sys/kernel/debug/dri/0/amdgpu_pm_info | grep -i load | cut -c11- | rev | cut -c3- | rev

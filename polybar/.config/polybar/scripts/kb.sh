#!/bin/bash
ENGINE=$(ibus engine | awk -F ":" '{print $NF}')

case $ENGINE in
    eng) echo "en" ;;
    anthy) echo "jp" ;;
esac

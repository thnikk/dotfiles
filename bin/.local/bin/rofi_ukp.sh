#!/bin/bash

{
    echo "2k"
    echo "4k"
    echo "2kt"
    echo "4kt"
} | rofi -dmenu | xargs -I {} ukp {}

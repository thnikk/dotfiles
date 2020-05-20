#!/bin/bash

vm=$(sudo virsh list --name)

    #echo %{o#ff9900}%{+o} "Not Running" %{o#0000ff}
if [[ $vm  == *"win10"* ]]; then
    echo %{o#cca3be8c}%{+o}%{o#cca3be8c}
    sudo virsh list --name
else
    echo %{F#99c0c5ce}%{F-}
fi


#!/bin/bash

if ! pgrep -x "greenclip" > /dev/null
then
    sleep 5
    greenclip daemon >/dev/null 2>&1 &
fi

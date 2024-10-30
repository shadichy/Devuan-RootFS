#!/bin/bash

# Reload input devices
udevadm trigger

# Start X11 if not running
if [ -z "$DISPLAY" ] && ! pidof X; then
  startx /usr/bin/jwm
fi

# Print message when no jwm
clear

cat /etc/bliss/message.txt

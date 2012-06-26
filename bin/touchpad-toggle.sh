#!/usr/bin/env sh
# Toggle touchpad on/off.

synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')

#!/usr/bin/env sh
# Activate A2DP on the last bluetooth pulse audio device found.

bluez_card=$(pactl list short cards | grep bluez_card | tail -1 | awk '{ print $1 }')
pactl set-card-profile "$bluez_card" a2dp
amixer set Master 50%

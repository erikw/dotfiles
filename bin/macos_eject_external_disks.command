#!/usr/bin/env osascript
# Inspired by https://apple.stackexchange.com/a/143427/197493

tell application "Finder" to eject (every disk whose ejectable is true and local volume is true and free space is not equal to 0)
display notification "Attempted to eject external disks." with title "Ejected external disks"

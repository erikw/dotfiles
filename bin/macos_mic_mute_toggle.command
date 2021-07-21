#!/usr/bin/env osascript

# Reference: https://superuser.com/a/937488/42070

set inputVolume to input volume of (get volume settings)
if inputVolume = 0 then
set inputVolume to 100
set displayNotification to "Microphone Unmuted"
else
set inputVolume to 0
set displayNotification to "Microphone Muted"
end if
set volume input volume inputVolume

display notification displayNotification
delay 1

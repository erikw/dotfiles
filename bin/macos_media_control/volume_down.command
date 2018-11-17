#!/usr/bin/env osascript

set vol to ((output volume of (get volume settings)) - 5)
if (vol < 0) then set vol to 0
set volume output volume (vol)

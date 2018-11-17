#!/usr/bin/env osascript

set vol to ((output volume of (get volume settings)) + 5)
if (vol > 100) then set vol to 100
set volume output volume (vol)

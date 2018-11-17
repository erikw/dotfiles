#!/usr/bin/env osascript

set isMuted to output muted of (get volume settings)
if isMuted then
	set volume without output muted
else
	set volume with output muted
end if

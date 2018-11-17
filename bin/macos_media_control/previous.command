#!/usr/bin/env osascript

on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running


if is_running("iTunes") then
	tell application "iTunes"
		previous track
	end tell
else if is_running("Spotify") then
	tell application "Spotify"
		previous track
	end tell
end if

#!/usr/bin/env osascript
# Open Now Playing in the menu bar.
tell application "System Events"
    tell process "Control Center"
        tell menu bar item "now playing" of menu bar 1
            click
        end tell
    end tell
end tell

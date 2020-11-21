#!/usr/bin/env osascript
# Open Control Center in the menu bar.
# Reference: https://www.reddit.com/r/MacOSBeta/comments/i4q5q7/open_control_center_with_gesturekeyboard_btt/
tell application "System Events"
    tell process "Control Center"
        tell menu bar item "control center" of menu bar 1
            click
        end tell
    end tell
end tell

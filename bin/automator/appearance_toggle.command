#!/usr/bin/env osascript
# Toggle system Apperance mode (dark|light).
# Reference: https://lifehacker.com/switch-between-dark-and-light-mode-on-your-mac-with-thi-1838488087

tell application "System Events"
	tell appearance preferences
		set dark mode to not dark mode
	end tell
end tell

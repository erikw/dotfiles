#!/usr/bin/env osascript
# To bind this to a shortcut
# * Open Automator and create a new Service (Quick Action).
# * Select the action "Run Applescript" and paste the contents here in that script template
# * Save the service as "start_screensaver".
# * Assign the keyboard shortcut under
#   System Preferences -> Keyboard -> Shortcuts -> Services > and set it to Ctrl+Cmd+L

do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"

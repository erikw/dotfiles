#!/usr/bin/env osascript
# To bind this to a shortcut
# * Open Automator and create a new Service
# * Select the action "Run Applescript" and paste the contents here in that script template
# * Save the service
# * Assign the keyboard shortcut under
#   System Preferences -> Keyboard -> Keyboard Shortcuts -> Services

do shell script "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"

#!/usr/bin/env bash
# SOURCE: https://gist.github.com/aberezin/f1e15db7181cdf062c3e7fb5ef6bc735
# If iterm2.app is closed, 2 windows will be opended by this script. To prevent this, Iterm2 > Settrings > General > Startup > "Only Restore Hotkey Window"

# Open new iTerm window from the command line using v3 syntax for applescript as needed in iTerm2 Version 3+
# This script blocks until the cmd is executed in the new iTerm2 window.  It then leaves the window open.
# TODO Add option to close iTerm2 after cmd execs


# See also https://www.iterm2.com/documentation-scripting.html
#
# Usage:
#     iterm                   Opens the current directory in a new iTerm window
#     iterm [PATH]            Open PATH in a new iTerm window
#     iterm [CMD]             Open a new iTerm window and execute CMD
#     iterm [PATH] [CMD] ...  You can prob'ly guess
#
# Example:
#     iterm ~/Code/HelloWorld ./setup.sh
#
# References:
#     iTerm AppleScript Examples:
#     https://gitlab.com/gnachman/iterm2/wikis/Applescript
#
# Credit:
#     Forked from https://gist.github.com/vyder/96891b93f515cb4ac559e9132e1c9086
#     Inspired by tab.bash by @bobthecow
#     link: https://gist.github.com/bobthecow/757788
#

# macOS only
[ `uname -s` != "Darwin" ] && echo 'OS X Only' && exit

function iterm () {
    local cmd=""
    local wd="$PWD"
    local args="$@"

    if [ -d "$1" ]; then
        wd="$1"
        args="${@:2}"
    fi

    if [ -n "$args" ]; then
        # echo $args
        cmd="$args"
    fi

   # osascript &>/dev/null <<EOF
    osascript <<EOF
tell application "iTerm"
	activate
	set new_window to (create window with default profile)
	set cSession to current session of new_window
	tell new_window
		tell cSession
			delay 1
			write text "cd $wd;$cmd"
			delay 2
			repeat
				delay 0.1
				--          display dialog cSession is at shell prompt
				set isdone to is at shell prompt
				if isdone then exit repeat
			end repeat
		end tell
	end tell
end tell
EOF
}
iterm $@

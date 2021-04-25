#!/usr/bin/env sh
# Monitor changes to Dark/Light apparance mode in macOS.
# Heavily inspired by https://gist.github.com/jerblack/869a303d1a604171bf8f00bbbefa59c2 but implemented in shell.
# Dependencies: $ brew install fswatch
#
# fswatch tutorial: http://emcrisostomo.github.io/fswatch/doc/1.14.0/fswatch.html/Tutorial-Introduction-to-fswatch.html#Tutorial-Introduction-to-fswatch
# Install with launchagent, see macos_install.sh

plist=$HOME/Library/Preferences/.GlobalPreferences.plist
fswatch --one-per-batch --event Renamed $plist | while read change; do \
	defaults read -g AppleInterfaceStyle >/dev/null 2>&1
	case "$?" in
 		0) mode=dark ;;
 		*) mode=light ;;
	esac
	echo $mode
	$HOME/bin/solarized_toggle.sh -m $mode
done

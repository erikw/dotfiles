#!/usr/bin/env bash
# Inspired by http://apetronix.com/switch-audio-outputs-with-a-keyboard-shortcut-on-os-x/
# brew dependencies: switchaudio-osx

# When this is run from Automator: we can't use $(brew --prefix) as we don't know where brew(1) is, neither rely on $BREW_PREFIX as shell files are not read.
# thus, HARDCODE-ish!
brew_prefix=/usr/local
if [ -d /opt/homebrew/ ]; then
	brew_prefix=/opt/homebrew
fi
bin="${brew_prefix}/bin/SwitchAudioSource"

# Default: cycle devices
cmd="$bin -t output -n"

# Output device obtained via $(SwitchAudioSource -a -t output)
if [ -n "$1" ]; then
	cmd="$bin -t output -s \"$1\""
fi

output=$(eval "$cmd")

output=$(echo "$output" | sed -e 's/"//g')
script=$(printf '%q' "$(basename $0)")
osascript -e "display notification \"$output\" with title \"$script\""

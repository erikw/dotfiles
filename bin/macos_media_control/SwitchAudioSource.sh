#!/usr/bin/env bash
# Inspired by http://apetronix.com/switch-audio-outputs-with-a-keyboard-shortcut-on-os-x/
# brew dependencies: switchaudio-osx

# Default: cycle devices
bin=/usr/local/bin/SwitchAudioSource
cmd="$bin -t output -n"

# Output device obtained via $(SwitchAudioSource -a -t output)
if [ -n "$1" ]; then
	cmd="$bin -t output -s \"$1\""
fi

output=$(eval "$cmd")

output=$(echo "$output" | sed -e 's/"//g')
script=$(printf '%q' "$(basename $0)")
osascript -e "display notification \"$output\" with title \"$script\""

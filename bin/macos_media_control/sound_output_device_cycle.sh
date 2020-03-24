#!/usr/bin/env bash

set -x
output=$(/usr/local/bin/SwitchAudioSource -t output -n)

#output=$(printf "%q" "$output")
output=$(echo "$output" | sed -e 's/"//g')
script=$(printf '%q' "$(basename $0)")
osascript -e "display notification \"$output\" with title \"$script\""

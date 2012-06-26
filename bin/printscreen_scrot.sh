#!/usr/bin/env bash
# Take screenshot. A good mapping for printscreen key.

datestamp="%Y-%m-%d-%H%M%S"
image="$HOME/media/images/screenshots/screenshot_$(date +${datestamp}).png"
#image="/tmp/screenshot_${USER}_$(date +${datestamp}).png"

scrot --quality 75 "$image"
notify-send --app-name "scrot" "Screenshot saved to ${image}"
type xclip >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
	echo "$image" | xclip -i
fi

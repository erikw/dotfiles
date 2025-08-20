#!/usr/bin/env bash
# Wrapper for yt-dlp. Works with YouTube and SoundCloud.
# Requirements: yt-dlp, ffmpeg

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
DEST_DIR="$HOME/dl"

IFS= read -rd '' USAGE <<EOF || :
Wraper for yt-dlp
Usage: $ ${SCRIPT_NAME} -h | url
EOF


while getopts ":h?" opt; do
	case "$opt" in
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

if [ "$#" != 1 ]; then
	echo "No URL provided" >&2
	exit 1
fi
url="$1"


opts=(
	--extract-audio
	--audio-format mp3
	--audio-quality 0			# 0 is best
	--no-playlist				# Prevent following &list= part of URL
	--add-metadata
	--embed-metadata
	--embed-thumbnail
	--embed-chapters
	--convert-thumbnails jpg	# jpg works better than webp in many players. This option can fail with "Requested format is not available. Use --list-formats..."
	 # Replace empty artist field with channel name. \
	--parse-metadata "uploader:%(artist)s" --replace-in-metadata "artist" "^$" "%(uploader)s"
	-o "${DEST_DIR}/%(artist)s - %(title)s.%(ext)s"
	"$url"
)

if yt-dlp "${opts[@]}"; then
	echo "MP3 saved to ${DEST_DIR}"
else
	echo "Error creating MP3" >&2
	exit 2
fi

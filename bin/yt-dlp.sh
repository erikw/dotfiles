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
Wraper for yt-dlp. Defaults to download MP3.
Usage: $ ${SCRIPT_NAME} -h | [-v] url

-v\tDownload video instead of MP3.
EOF


arg_video=false
while getopts ":vh?" opt; do
	case "$opt" in
		v) arg_video=true;;
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


if $arg_video; then
	opts=(
		# Opt1: download best quality & convert to iOS friendly format.
		#--format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4"
		## By default YouTube’s “best” video is usually in WebM/VP9 (video) + Opus (audio). iOS (Files app, Photos, QuickTime on iPhone) does not support VP9/WebM -> always re-encode to mp4 with ffmpeg.
		#--recode-video mp4
		## -c:v libx264 -> re-encode video to H.264
		## -c:a aac -b:a 192k ->  re-encode audio to AAC (192 kbps)
		#--postprocessor-args "ffmpeg:-c:v libx264 -c:a aac -b:a 192k"


		# Opt2: download the fallback H.264 (avc1) video + AAC (m4a) audio stream up to 720p. Much faster, but could be lower quality.
		# bestvideo[ext=mp4][vcodec^=avc1] -> only select H.264 (avc1) MP4 video
		# +bestaudio[ext=m4a] -> only select AAC audio in M4A container
		# /best[ext=mp4] -> fallback to the best single MP4 if separate tracks aren’t available
		--format "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]"
	)
else
	opts=(
		--extract-audio
		--audio-format mp3
		--audio-quality 0			# 0 is best
		--convert-thumbnails jpg	# jpg works better than webp in many players. This option can fail with "Requested format is not available. Use --list-formats..."
	)
fi


opts+=(
	--progress
	--no-playlist		# Prevent following &list= part of URL
	--add-metadata
	--embed-metadata
	--embed-thumbnail
	--embed-chapters
	# Replace empty artist field with channel name.
	--parse-metadata "uploader:%(artist)s" --replace-in-metadata "artist" "^$" "%(uploader)s"
	# Set album field to the playlist (if downloading from a playlist URL)
	--metadata-from-title "album:%(playlist)s"
	--print after_move:filepath
	-o "${DEST_DIR}/%(artist)s - %(title)s.%(ext)s"
	"$url"
)


if ! yt-dlp "${opts[@]}"; then
	echo "Error creating file." >&2
	exit 2
fi

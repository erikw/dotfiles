#!/usr/bin/env bash
# Save .torrent file or a magnet URI in rTorrent watch directory

# Launch this script within a xterm window.
if [ "$1" != "RUNNING_XTERM" ]; then
	xterm -e "$0" "RUNNING_XTERM" "$1"
	exit
fi

# Base directory that rTorrent polls.
watch_dir="$HOME/dl/torrent/watch"

if [[ "$2" =~ xt=urn:btih:([^&/]+) ]]; then	# Magnet URL.
	magnet_url="$2"
	magnet_hash="${BASH_REMATCH[1]}"
elif [[ "$2" =~ .+\.torrent ]]; then		# Torrent file.
	torrent_file="$2"
else						# Bogus.
	exit
fi

# ncursed dialog commando.
dialog_cmd=(dialog --keep-tite --menu "Select rTorrent category" 15 30 8)

# Subcategories under the base watch directory.
categories=(
1 "ebooks"
2 "games"
3 "misc"
4 "movies"
5 "music"
6 "software"
7 "tv"
8 "none"
)

choice=$("${dialog_cmd[@]}" "${categories[@]}" 2>&1 >/dev/tty)

# If user chose an alternative.
if [ "$?" = 0 ]; then
	# Select the corresponding text in the array.
	category=${categories[2 * $choice - 1]}

	# None goes to base directory.
	if [ "$category" = "none" ]; then
		category=
	fi

	if [ ! -z "${magnet_hash+dummy}" ]; then	# If $magnet_hash is not not set.
		# Create a magnet torrent file.
		echo "d10:magnet-uri${#magnet_url}:${magnet_url}e" > "$watch_dir/$category/meta-${magnet_hash}.torrent"
	elif [ ! -z "${torrent_file+dummy}" ]; then
		mv --interactive "${torrent_file}" "$watch_dir/$category/"
	fi
fi

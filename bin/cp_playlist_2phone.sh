#!/usr/bin/env bash
# Copy selected MPD playlists to my phone's SD card.

playlist_path="$HOME/.mpd/playlists"
media_path="$HOME/media/music"
sd_card="/media/660C-1AE6/music"



get_playlists() {
	cd "$playlist_path"

	for playlist in *; do
		keep=""
		while ([[ -z "$keep" ]] || [[ "$keep" != [yYnN] ]]); do
			echo -n "Copy ${playlist} [y/N]: "
			read keep
			[ -z "$keep" ] && keep="n"
			if  [[ "$keep" = [yY] ]]; then
				playlists+=("$playlist")
			fi
		done
	done

	echo -e "\nYou've selected these playlists:"
	printf "%s\n" "${playlists[@]}"

	ok=""
	while ([[ -z "$ok" ]] || [[ "$ok" != [yYnN] ]]); do
		echo -en "\nCopy these playlists to ${sd_card}? [yn]:"
		read ok
		if [[ "$ok" = [nN] ]]; then
			exit
		fi
	done;
}

copy_playlist() {
	local playlist="$1"
	local sd_path="$2"

	echo "Processing playlist ${playlist%????}"
	mkdir -p "$sd_path/${playlist%????}"
	while read song; do
		local song_path="${media_path}/${song}"
		echo "Copying ${song_path}"
		cp "$song_path" "${sd_path}/${playlist%????}/"
	done < "${playlist_path}/$playlist"
}


declare -a playlists
get_playlists
for playlist in "${playlists[@]}"; do
	copy_playlist "${playlist}" "$sd_card"
done

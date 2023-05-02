#!/bin/bash
# Covnert some defined images to pngs in the given path and deletes them.
targets=(jpg JPG jpeg JPEG gif GIF tif TIF)
ipath="."
[[ -n "$1" ]] && ipath=$1
for TARGET in ${targets[*]}; do
	nbr=$(ls -l $ipath/* | grep "${TARGET}" | wc -l)
	if [[ "$nbr" -gt "0" ]]; then
		mogrify -format png ${ipath}/*.$TARGET
		rm -f ${ipath}/*.$TARGET
	fi
done
exit 0

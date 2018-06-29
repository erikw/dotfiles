#!/usr/bin/env sh
# Rename to sane file names.

if [ -n  "$1" ]; then
	path="$1"
else
	path="."
fi

IFS=$'\n'
for dir in $(find $path -type d | tac); do
	echo "$dir"
	cd "$dir"
	# TODO on macOS, case-only rename is not allowed. Need to rename file to temporay name first.
	# https://stackoverflow.com/questions/7787029/how-do-i-rename-all-files-to-lowercase
	rename.pl 's/(.*)/lc($1)/e' *
	rename.pl 's/ /_/g' *
	cd - >/dev/null
done

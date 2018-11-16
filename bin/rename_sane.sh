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
	# On macOS, case-only rename is not allowed. Need to rename file to temporay name first.
	# Reference: https://stackoverflow.com/questions/7787029/how-do-i-rename-all-files-to-lowercase
	#rename.pl 's/(.*)/lc($1)/e' *
	for f in *; do
		mv "$f" "$f.tmp"; mv "$f.tmp" "`echo $f | tr "[:upper:]" "[:lower:]"`"
	done
	rename.pl 's/ /_/g' *
	cd - >/dev/null
done

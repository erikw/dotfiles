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
	rename.pl 's/(.*)/lc($1)/e' *
	rename.pl 's/ /_/g' *
	cd - >/dev/null
done

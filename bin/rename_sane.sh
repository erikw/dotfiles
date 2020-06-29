#!/usr/bin/env sh
# Rename to sane file names.

#set -xe

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
		#lower=$(echo $f | tr "[:upper:]" "[:lower:]")
		# gnu tr is not internationalized, but gawk is: https://unix.stackexchange.com/a/228570/19909
		lower=$(echo $f | gawk '{print tolower($0)}')
		mv "$f" "$f.tmp"
		mv "$f.tmp" "$lower"
	done
	rename.pl 's/ /_/g' *
	cd - >/dev/null
done

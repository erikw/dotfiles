#!/usr/bin/env bash
# List recursively the last modified files.

if [ "$#" -ne 1 ]; then
	echo "Need argument: path." 1>&2
fi

path="$1"

find "$path" \( -type f -o -type l \) -exec stat -c "%y" {} \; -exec echo {} \; | paste -s -d ' \n' | sort -n

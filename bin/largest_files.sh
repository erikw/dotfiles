#!/usr/bin/env sh
# Recursively find top largest files in given directory. Default is current directory.
# Usage: largest_files.sh | head -50

test -n "$1" && path="$1" || path="."

# Modified version of https://unix.stackexchange.com/a/203705/19909
find "$path" -type f -print0 | xargs -0 ls -la | awk '{print int($5/(1024^2)) " MiB\t" $9}' | sort -n -r -k1

#!/usr/bin/env sh
# Recursively find top largest files in given directory. Default is current directory.
# Usage: largest_files.sh | head -50

test -n "$1" && path="$1" || path="."

# Modified version of https://unix.stackexchange.com/a/203705/19909 that handles file names with spaces.
# Ref: https://linuxhint.com/print-columns-awk/
find "$path" -type f -print0 | xargs -0 ls -la | awk '{for (i=5; i<NF; i++) { if (i == 5) { printf int($i/(1024^2)) " MiB\t" } else if (i >= 9 ) {  printf $i " " } }; if (NF >= 5) print $NF; }' | sort -n -r -k1

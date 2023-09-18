#!/usr/bin/env bash

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
	echo "No root dir given"
	exit 1
fi
root="$(realpath "$1")"
cd "$root"
#echo "Entered $root"


for f in $(find . -type f); do
	#echo "Inspecting: $f"
	if [[ "$f" =~ -edited\....$ ]]; then
		#echo "Found edited file! $f"
		f_uned="$(echo "$f" | sed -e 's/-edited\././')"
		if [ -f "$f_uned" ]; then
			#echo "Unedited exist too! $f_uned"
			echo "Deleting original to keep edited: $f_uned"
			rm "$f_uned"
		fi
	fi
done

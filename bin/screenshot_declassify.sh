#!/usr/bin/env bash
# Requirements: imagemagick, exiftool

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS= read -rd '' USAGE <<EOF || :
Declassify an image as a screenshot in macOS Photos.app

1. Drag it out of the Photos.app
2. Delete it from the library
3. Run this tool
4. Drag-and-drop it back to Photos.app
5. Re-add photo to previous albums

Usage: $ ${SCRIPT_NAME} -h | <input_photo>
EOF


while getopts ":c:h?" opt; do
	case "$opt" in
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

path_in="$1"
dir_in="$(dirname "$path_in")"
filename_in=$(basename "$path_in")

filename_out="Photo_$(date +%Y%m%d_%H%M%S).jpg"
dir_out="${dir_in}/declassified"
path_out="${dir_out}/${filename_out}"

mkdir -p "$dir_out"


magick "$path_in" "$path_out"

exiftool \
  -Software="Canon EOS 5D Mark IV" \
  -Make="Canon" \
  -Model="Canon EOS 5D Mark IV" \
  -UserComment="" \
  -FileName="${filename_out}" \
  -ImageDescription="Vacation photo" \
  -overwrite_original \
  "$path_out"


echo "Now reimport this image to Photos.app: ${path_out}"

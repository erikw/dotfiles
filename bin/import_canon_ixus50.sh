#!/bin/sh
# Download new images from my Canon Ixus 50 camera in PTP mode over USB using gphoto2. The camera must be turned on.
# Usage: import_canon_ixus50.sh [<import_name>]
#gphoto2 --auto-detect
import_dir="$HOME/media/images/camera/imported"
cd $import_dir

if [ -n "$1" ]; then
	file_name="$1"
	mkdir -p "$file_name"
	cd "$file_name"
else
	file_name="imported"
fi

gphoto2 --camera "Canon Digital IXUS 50 (PTP mode)" --get-all-files --filename "${file_name}_%n.jpg" --new
[ "$?" -ne 0 ] && echo "Aborting import." 1>&2 && exit

echo -n "Import completed. Now converting to PNG... "
mogrify -format png *.jpg
rm *.jpg
echo "done."

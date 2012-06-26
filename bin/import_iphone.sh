#!/bin/sh
# Download new images from my iPhone 3G.
#gphoto2 --auto-detect
import_dir=$HOME/media/images/camera/imported/
file_name="iphone"

cd $import_dir
if [ ! -d iphone ]; then
	mkdir iphone
fi
cd iphone

gphoto2 --camera "Canon Digital IXUS 50 (PTP mode)" --get-all-files --filename "${file_name}_%n.jpg" --new
echo -n "Import completed. Now converting to PNG... "
mogrify -format png *.jpg
rm *.jpg
echo "done."

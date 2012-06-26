#!/bin/bash
# Restore folderstructure in /media/.

folders=(cdrom iphone ipod ipod_shuffle key mybook tmachine usb_media vcamera)
for folder in ${folders[*]}
do
	mkdir -p /media/$folder
done

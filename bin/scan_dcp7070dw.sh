#!/usr/bin/env bash
# Scan image from Brother DCP-7070DW scanner.
# dependencies: sane, brscan4 (from AUR)
# install: sudo brsaneconfig4 -a name=dcp7070dw model=DCP-7070DW ip=10.0.0.5
# Device name found with $(scanimage -L) after configuring it with brsaneconfig4.

dev_name="brother4:net1;dev0"
dest_dir="$HOME/media/images/scanned"
timestamp=$(date "+%Y-%m-%d-%H%M%S")
scan_name="scanned_${timestamp}"
dest_file_path="${dest_dir}/${scan_name}.pdf"

convert2type() {
	local scan_name="$1"
	local from="$2"
	local to="$3"
	convert -quality 75 "${scan_name}.${from}" "${scan_name}.${to}"
	rm "${scan_name}.${from}"
}

copy_path_to_xclipboard() {
	local path="$1"
	echo  "$path" | xclip -i
}

compress=true
if [ "$1" = "-C" ]; then
	compress=false
fi

scanimage --device-name="${dev_name}" --progress --format=tff > "/tmp/${scan_name}.tff"
if [ "$?"  -ne 0 ]; then
	echo "scanimage(1) failed." 1>&2
	exit
fi

if [ -e "/tmp/${scan_name}.tff" ]; then
	convert2type "/tmp/$scan_name" "tff" "pdf"
	mv "/tmp/${scan_name}.pdf" $dest_dir
	if [ $compress = true ]; then
		pdf_compress.sh -r "${dest_file_path}" >/dev/null
	fi
	copy_path_to_xclipboard "${dest_file_path}"
	echo "Scanned image at: ${dest_file_path}"
else
	echo "Scan failed -- no output." 1>&2
fi

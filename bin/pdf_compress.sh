#!/usr/bin/env bash
# Compress PDF files to smaller size.
# Inspired by: https://askubuntu.com/a/256449/277752

get_file_size() {
	file="$1"
	du -h "$file" | awk '{print $1}'
}

compress_pdf() {
	pdf_input="$1"
	pdf_settings="$2"
	replace="$3"
	open="$4"

	basename=${1%%.pdf}
	pdf_output="${basename}_compressed.pdf"


	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/${pdf_settings} -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${pdf_output} ${pdf_input}
	if [ "$?" -ne 0 ]; then
		echo "Failed to compress input PDF." >&2  && exit 2
	fi

	size_before=$(get_file_size "$pdf_input")
	size_after=$(get_file_size "$pdf_output")

	if [ "$replace" = true ]; then
		mv "${pdf_output}" "${pdf_input}"
		ftype="original"
	else
		ftype="copy"
	fi

	printf "Compressed %s from %s to %s at: %s\n" $ftype $size_before $size_after "$pdf_output"
	test $open = true && open "$pdf_output"
	test $replace = true || printf "> Replace with:\nmv %s %s\n" "$pdf_output" "$pdf_input"
}

scriptname=${0##*/}
usage="Usage: ${scriptname} [-r] [-o] [-s [default|screen*|ebook|prepress|printer]] <pdf>"

pdf_settings=screen
replace=false
open=false
while getopts ":ros:h?" opt; do
	case "$opt" in
		r) replace=true;;
		o) open=true;;
		s) case "$OPTARG" in
				default|screen*|ebook|prepress|printer) pdf_settings="$OPTARG" ;;
				*) echo "Invalid pdf settings" >&2 && exit 1 ;;
			esac
		;;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo "$usage"; exit 0;;
	esac
done
shift $(($OPTIND - 1))

if [ "$#" -lt 1 ]; then
	echo "Mising PDFs to compress" 2>/dev/null
	exit 1
fi
pdfs="$*"

for pdf in $pdfs; do
	compress_pdf "$pdf" "$pdf_settings" $replace $open
done

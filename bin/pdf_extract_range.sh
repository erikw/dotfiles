#!/usr/bin/env bash
# Extract a range of pages from an PDF to a new file
# Usage: pdf_extract_range.sh input.pdf lower-upper
# Inspired by: https://askubuntu.com/questions/221962/how-can-i-extract-a-page-range-a-part-of-a-pdf
# Dependencies: pdftk (or pdftk-java port)

if [ -z "$1" ]; then
	echo "Need to provide and input PDF file on command line." >&2 && exit 1
fi
pdf_input="$1"

if [ -z "$2" ]; then
	echo "Need to provide PDF range input on command line e.g 2, or 3-15." >&2 && exit 2
fi
range="$2"

pdf_basename=${1%%.pdf}
pdf_output="${pdf_basename}_p${range}.pdf"


pdftk "$pdf_input" cat $range output "$pdf_output"


if [ "$?" -eq 0 ]; then
	echo "Extracted range ${range} to a new file: ${pdf_output}"
else
	echo "Failed to extract range from input PDF." >&2  && exit 2
fi

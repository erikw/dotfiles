#!/usr/bin/env sh
# Delete files with confirmation.

case $# in
	0) echo "Missing operand."; exit ;;
	[1234]) rm -i "$@";;
	*)
		echo "$@"
		echo "Delete all? [y/N] "
		read y
		case "$y" in
			[yY]) rm "$@";;
		esac
		;;
esac

#!/bin/sh
# A wrapper for md5sum.

md5sumer() {
	clear_text="$0"
	echo -n "$clear_text" | md5sum - | cut -d' ' -f1
}

md5sumer "$1"

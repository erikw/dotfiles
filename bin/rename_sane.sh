#!/usr/bin/env sh
# Rename to sane file names.
# Requirements: rename(.pl)
# Requirements: $ cpan Text::Unidecode

test -n "$1" && path="$1" || path="."

IFS=$'\n'
for dir in $(find $path -type d | tac); do
	cd "$dir" && echo "====> Entering: $dir/"
	rename --verbose --transcode utf8 --lower-case --sanitize --force  *
	# Transcode unicode to ASCII. See rename(1).
	rename --verbose --transcode utf8 -MText::Unidecode '$_ = unidecode $_' *
	cd - >/dev/null
done

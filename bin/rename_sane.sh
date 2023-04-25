#!/usr/bin/env sh
# Rename to sane file names.
# Usage: rename_sane.sh [path]
# Requirements:
# - rename(.pl)
# - Requirements: detox
# - ~Requirements: $ cpan Text::Unidecode~
#   - non-interactive: $ PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Text::Unidecode'

test -n "$1" && path="$1" || path="."

IFS=$'\n'
for dir in $(find $path -type d | tac); do
	test -z "$(ls -A "$dir")" && continue

	cd "$dir" && echo "====> Entering: $dir/"
    # --force: for case-insensitive fs https://github.com/ap/rename/issues/16
	rename --verbose --transcode utf8 --lower-case --sanitize --force  *

	# NOPE Recode Unicode to ASCII. See rename(1).
	#rename --verbose --transcode utf8 -MText::Unidecode '$_ = unidecode $_' *
	# Better use detox, so that we don't need to install cpan modules!
	detox -rv  .

	cd - >/dev/null
done

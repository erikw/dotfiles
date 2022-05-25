#!/usr/bin/env sh
# Rename to sane file names.
# * Requirements: rename(.pl)
# * Requirements: $ cpan Text::Unidecode
#   * non-interactive: $ PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Text::Unidecode'

test -n "$1" && path="$1" || path="."

IFS=$'\n'
for dir in $(find $path -type d | tac); do
	cd "$dir" && echo "====> Entering: $dir/"
        # --force: for case-insensitive fs https://github.com/ap/rename/issues/16
	rename --verbose --transcode utf8 --lower-case --sanitize --force  *
	# Recode Unicode to ASCII. See rename(1).
	rename --verbose --transcode utf8 -MText::Unidecode '$_ = unidecode $_' *
	cd - >/dev/null
done

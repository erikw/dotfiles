#!/bin/bash
# Clean duplicated artworks created by PuddleTaggs Atwork To File.
find . -iregex '.*folder_.*\.\(png\|jpg\)' -print -exec rm {} \;
find . -iregex '.*folder\.jpg' -print -exec rm {} \;
exit 0

#!/usr/bin/env sh
# clock.pl wrapper that excludes two common external package roots.

find $GOPATH/src -maxdepth 1 -type d -not \( -wholename "$GOPATH/src" -o -wholename "$GOPATH/src/github.com" -o -wholename "$GOPATH/src/code.google.com" \) | tr  "\\n" " "  | xargs cloc.pl

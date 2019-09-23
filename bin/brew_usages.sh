#!/usr/bin/env bash
# List brew packages with packages that depends on it. To know which packages that can be removed.
# Source: https://www.thingy-ma-jig.co.uk/blog/22-09-2014/homebrew-list-packages-and-what-uses-them

brew list -1 | while read cask; do echo -ne "\x1B[1;34m $cask \x1B[0m"; brew uses $cask --installed | awk '{printf(" %s ", $0)}'; echo ""; done

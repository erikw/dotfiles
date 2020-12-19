#!/usr/bin/env bash
# Show installed brew packages that have no dependencies.
# Because brew_usages.sh outputs from multiple subprocesses, output needs to be collected completely first.
# See also $(brew autoremove) to clean up existing dangling formulas!


outf=/tmp/brew_usages.$$.out
brew_usages.sh 2>&1 >$outf &
wait
grep -E "^\s*\w+:\s*$" $outf | tr -d :

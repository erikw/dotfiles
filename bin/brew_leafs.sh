#!/usr/bin/env sh
# Show installed brew packages that have no dependencies.

brew_usages.sh | grep -E "^\s*\w+\s*$"

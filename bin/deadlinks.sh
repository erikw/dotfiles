#!/usr/bin/env sh
# Find dead symbolic links.

find . -type l -print | perl -nle '-e || print'

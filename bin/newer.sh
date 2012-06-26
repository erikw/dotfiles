#!/usr/bin/env sh
# Display the newest of a group of files.
 ls -dt "$@" | head -1; 

#!/usr/bin/env sh
# Print login count statistics.
last | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | sed -e 's/^\s*//g'

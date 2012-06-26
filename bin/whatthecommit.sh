#!/usr/bin/env bash
msg=$(curl 'http://whatthecommit.com' 2>/dev/null | sed -n 's/<p>\(.*\)$/\1/p')
echo "$msg"

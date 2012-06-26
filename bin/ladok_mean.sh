#!/usr/bin/env bash
# One liner that calculates your mean course score given a HTML copy of the LADOK results page (in English).
grep  -PZoi "(?<=>)[3-5]&nbsp;</td>(\s*(?:\\n|<td[^>]*>[^<]*</td>))*\s*<\/tr>\s*<tr>\s*<td[^>]*>[^<]*</td>\s*<td[^>]*>examiner" < "$1"  | grep  -PZoi "^[3-5G](?=&nbsp;</td>)" | sed -e 's/g/3/i' | awk 'BEGIN{sum=0;count=0}{sum+=$1;count++}END{print sum/count}'

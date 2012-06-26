#!/usr/bin/env sh
# Fetched from Peter Möllers' site: http://cs.lth.se/kontakt/peter_moller/unix/bash/

locate_ip() {
  curl www.geoiptool.com/en/ 2>/dev/null | awk '
  /<td.*>(Country:|City)/ {
  record="t";gsub("[\t ]*<[^>]*>",""); printf("%-1s ",$0);next;
  }
  record == "t" { gsub("[\t ]*<[^>]*>[\t ]*","");print $0;record="f";next}
  {next}
  END{print ""}'
}

locate_ip "$@"

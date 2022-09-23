#/usr/bin/env bash
# Fetched from Peter Möller's site: http://cs.lth.se/kontakt/peter_moller/unix/bash/
# Test bash operators on a file.

testt ()
{
  local dp;
  until [ -z "${1:-}" ]; do
    dp="$1";
    [[ ! -a "$1" ]] && dp="$PWD/$dp";
    command ls -lAGd "$dp";
    [[ -d "$dp" ]] && find "$dp" -mount -depth -wholename "$dp"
    for f in a b c d e f g h L k p r s S t u w x O G N;
    do
      test -$f "$dp" && help test | sed "/-$f F/!d" | sed -e 's#^[\t ]*-\([a-zA-Z]\{1\}\) F[A-Z]*[\t ]*   True if#-\1 "'$dp'" #g';
    done;
    shift;
  done
}

testt "$@"

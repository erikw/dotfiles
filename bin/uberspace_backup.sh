#!/usr/bin/env bash
# Backup my uberspace.de account.

set -x

tar_pattern=takeout_erikw_\*
bak_dest="$HOME/bak/uberspace/"

ssh uberspace "uberspace takeout takeout"
scp uberspace:${tar_pattern} ${bak_dest}
ssh uberspace "rm ~/${tar_pattern}"
ls -lh $bak_dest

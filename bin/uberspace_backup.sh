#!/usr/bin/env bash
# Backup my uberspace.de account.

set -ex

tar_pattern=takeout_erikw_\*
bak_dest="$HOME/bak/uberspace/"

# Skip ToolsVersions as of https://github.com/Uberspace/takeout/issues/35
ssh uberspace "uberspace takeout takeout --skip-item ToolVersions"
scp uberspace:${tar_pattern} ${bak_dest}
ssh uberspace "rm ~/${tar_pattern}"
ls -lh $bak_dest

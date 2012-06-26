#!/usr/bin/env sh
# Fetch gpodder episodes.

export GPODDER_HOME="$HOME/media/music/gPodder"
gpo update
gpo download

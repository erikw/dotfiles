#!/usr/bin/env sh
# Fix "Unverified developer" error when opening unsigned VST files.
# Reference: https://bigendians.com/2020/08/26/vst-plugins-on-os-x-catalina-cant-be-opened-because-it-is-from-an-unidentified-developer/

BASE_PATH=/Volumes/toshiba_music/daw/plugins
FIX_CMD='xattr -rd com.apple.quarantine "{}"; xattr -rd com.apple.macl "{}"'

find $BASE_PATH/VST  -iname "*.vst"  -print0 | gxargs -0 -i sh -c "$FIX_CMD"
find $BASE_PATH/VST3 -iname "*.vst3" -print0 | gxargs -0 -i sh -c "$FIX_CMD"

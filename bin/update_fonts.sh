#!/usr/bin/env bash
#cd $HOME/.fonts
cd $HOME/.local/share/fonts/
mkfontdir
mkfontscale
fc-cache -fv
xset fp rehash

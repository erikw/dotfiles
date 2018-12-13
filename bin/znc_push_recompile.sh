#!/usr/bin/env sh
# Recompile and install ZNC notification module.

dir=$HOME/src/github.com/jreese/znc-push/

cd $dir
znc-buildmod push.cpp
sudo cp $dir/push.so /usr/local/lib/znc/
sudo service znc restart

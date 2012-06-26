#!/usr/bin/env sh
# Toggle solarized between light and dark in vim and urxvt.

storage=$HOME/.solarizedtoggle
! [ -d $storage ] && mkdir $storage

statusfile=$storage/status
xres=$HOME/.Xresources
xres_symlink=$storage/Xresouces_theme
xres_dark=$HOME/.Xresources.solarized_dark
xres_light=$HOME/.Xresources.solarized_light

xrdb_exist() {
	type xrdb >/dev/null 2>&1
}

set_xrdb() {
	if xrdb_exist; then
		xrdb -load $xres
	fi
}

set_dark() {
	echo dark | tee $statusfile
	if  [ -n $DISPLAY ];  then
		ln -sf $xres_dark $xres_symlink
		set_xrdb
	fi
}

set_light() {
	echo light | tee $statusfile
	if  [ -n $DISPLAY ];  then
		ln -sf $xres_light $xres_symlink
		set_xrdb
	fi
}

read_status() {
	[ -e $statusfile ] && cat $statusfile || echo ""
}

if ! [ -e $statusfile ]; then
	set_light
else
	[ $(read_status) = dark ] && set_light || set_dark
fi

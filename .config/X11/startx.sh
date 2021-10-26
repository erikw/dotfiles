# Start X if we're at vt1.
# TODO start using systemd service when there is an official way of starting xorg in a user session.

source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/functions

if shell_is_linux; then
	host=$(hostname --short)
elif shell_is_macos; then
	host=$(hostname -s)
else
	host=$(hostname)
fi

if [ $host = irvine ]; then
	type startx >/dev/null 2>&1
	# End with cons, so the status code is not 1 when sourcing this.
	#[[ -z $DISPLAY && $XDG_VTNR -eq 1 && "$?" -eq 0 ]] && exec startx || :
	# XDG support: https://wiki.archlinux.org/title/XDG_Base_Directory
	[[ -z $DISPLAY && $XDG_VTNR -eq 1 && "$?" -eq 0 ]] && exec startx "${XDG_CONFIG_HOME:-$HOME/.config}/X11/xinitrc" vt1  || :
fi

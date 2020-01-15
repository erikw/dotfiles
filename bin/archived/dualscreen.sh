#!/usr/bin/env bash
# Control dual screens. Alternatively use arandr GUI tool.
# Get information with $(xrandr -q).

if [ "$#" -eq 2 ]; then
	monitor="$1"
	action="$2"
	if !([ "$action" == "enable" ] || [ "$action" == "disable" ]); then
		echo "Unknown action \"${2}\"." 1>&2
		exit 3
	fi
else
	echo "Expected argument: monitor (enable|disable)" 1>&2
	exit 1
fi

#args_lvds1="--output LVDS1 --primary --mode 1600x900"
# Set --pos to align with external monitor. Found by exporting config from arandr(1).
args_lvds1="--output LVDS1 --primary --mode 1600x900 --pos 0x300 "
case "$monitor" in
	"dell24") # Dell 24" monitor. Dell UltraSharp U2412M e-IPS 24" - black
		if [ "$action" == "enable" ]; then
			#ext_monargs="--output HDMI2 --mode 1920x1200 --right-of LVDS1"
			# Set alignment, found by exporting config from arandr(1)
			ext_monargs="--output HDMI2 --mode 1920x1200 --pos 1600x0"
		else
			#args_lvds1="${args_lvds1} --primary"
			ext_monargs="--output HDMI2 --off"
		fi
		;;
	"lgtv") # Lund LG TV.
		if [ "$action" == "enable" ]; then
			ext_monargs="--output HDMI1 --mode 1360x768 --left-of LVDS1"
		else
			#args_lvds1="${args_lvds1} --primary"
			ext_monargs="--output HDMI1 --off"
		fi
		;;
	"ljunghusen-sharp") # Parents' large TV.
		if [ "$action" == "enable" ]; then
			ext_monargs="--output HDMI1 --mode 1920x1080i --left-of LVDS1"
		else
			#args_lvds1="${args_lvds1} --primary"
			ext_monargs="--output HDMI1 --off"
		fi
		;;
	*)
		echo "Unknow monitor \"${monitor}\"." 1>&2
		exit 2
		;;
esac
xrandr $args_lvds1 $ext_monargs

# Set wallpaper again to re-fit.
#$HOME/bin/wallpaper_set.sh

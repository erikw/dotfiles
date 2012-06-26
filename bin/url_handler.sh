#!/bin/bash
#
# url_handler.sh for SuSE Linux
#
# Copyright (c) 2000 SuSE GmbH Nuernberg, Germany.
# Copyright (c) 2007 SuSE LINUX Products GmbH, Nuernberg, Germany
#
# Author: Werner Fink <werner@suse.de>
#
   url="$1"
method="${1%%:*}"
ttybrowser="lynx links w3m"
x11browser="firefox Mozilla mozilla konqueror opera amaya Netscape netscape Mosaic mosaic"

if test "$url" = "$method" ; then
    case "${url%%.*}" in
	www|web|w3) method=http		;;
	mail|mailx) method=mailto	;;
	gopher)	    method=gopher	;;
	*)
	    case "${url}" in
		*/*.htm|*/*.html) method=http	;;
		*/*.htmls)	  method=https	;;
		*@*)		  method=mailto ;;
		/*) if test -r "${url}" ; then
				  method=file
		    fi				;;
		*)				;;
	    esac
					;;
    esac
    case "$method" in
	mailto|file)	url="${method}:$url"	;;
	*)		url="${method}://$url"	;;
    esac
fi

### an alternative method of handling "news:*" URL's
#
# if test "$method" = "news" ; then
#     url="http://www.deja.com/[ST_rn=if]/topics_if.xp?search=topic&group=${url#news:}"
#     method=http
# fi

shift

case "$method" in
    ftp)
	ftp=ftp
	if type -p ncftp &> /dev/null ; then
	    ftp=ncftp
	else
	    url="${url#ftp://}"
	    echo "=====>  Paste this command by mouse:"
	    echo cd "/${url#*/}"
	    url="${url%%/*}"
	fi
	exec $ftp "$url"
	;;
    file|http|https|gopher)
	http=
	browser="${ttybrowser}"
	if test -n "$DISPLAY" ; then
	    browser="${x11browser} ${browser}"
	fi
	for p in ${browser} ; do
	    http=$(type -p $p 2> /dev/null) && break
	done
	if test -z "$http" ; then
	    echo "No HTTP browser found."
	    read -p "Press return to continue: "
	    exit 0  # No error return
	fi
	case "${http##*/}" in
	    firefox)	$http -remote "openURL(${url},new-tab)" || exec $http "${url}" ;;
	    [nN]etscape|[mM]ozilla)
			$http -noraise -remote "xfeDoCommand(openBrowser)" &> /dev/null && \
			$http -remote "openURL(${url})" || \
			exec $http "${url}" ;;
	    *)		exec $http "${url}" ;;
	esac
	;;
    mailto)
	: ${MAILER:=mutt}
	if type -p ${MAILER} &> /dev/null ; then
	    exec ${MAILER} "${url#mailto:}"
	else
	    echo "No mailer ${MAILER} found in path."
	    echo "Please check your environment variable MAILER."
	    read -p "Press return to continue: "
	    exit 0  # No error return
	fi
	;;
    *)
	echo "URL type \"$method\" not know"
	read -p "Press return to continue: "
	exit 0  # No error return
	;;
esac

# One link is enough for me. Kill parent (urlview).
kill $PPID

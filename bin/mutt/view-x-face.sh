#! /bin/sh
#
# $ Id: view-x-face,v 2.3 2002/12/01 12:52:23 roland Exp $
#
# Read a mail message on stdin and display X-Face, if one exists.
#
# See http://www.spinnaker.de/mutt/view-x-face for new versions.
#
# This is not the optimal way to implement X-Face support into a mailreader,
# but this works for me. I bound it to "ESC f" in my muttrc with the
# following command:
#  macro	pager	\ef	"|view-x-face\n"
#
# This script needs the following tools:
# uncompface from the compface package, which can be found at
#	     ftp://ftp.cs.indiana.edu/pub/faces/compface/compface.tar.Z
# icontopbm  from the pbmplus or netpbm package, which you will find
#            everywhere on the net.
# A pbm viewer, e.g. xli, xv or if you don't have X11 running, you may want
#            to try out image2ascii, a little Shell script, which uses
#            ImageMagick to convert nearly any graphics file to ASCII.
#            have a look at http://www.spinnaker.de/mutt/image2ascii
#
#########################################################################
#
#   Based on an idea of Ralf Döblitz <Doeblitz@gmx.de>
#
#   Copyright (C) 1997-2002  Roland Rosenfeld <roland@spinnaker.de>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#########################################################################

# Used programms:
UNCOMPFACE=uncompface	# from compface package
ICONTOPBM=icontopbm	# from pbmplus/netpbm package

# Image viewer (should be able to read from stdin!):
if [ -n "$DISPLAY" ]
then
    #VIEWER="xli stdin"		# Use xli as X11 image viewer
    VIEWER="xv -quit -"		# Use xv as X11 image viewer
else
    VIEWER=image2ascii		# Use image2ascii as ASCII image viewer
fi

cat "$@" \
| sed -n -e '/^X-Face:/,/^[^ \t]/ p' \
| sed -n -e 's/^X-Face://' -e '/^[ \t]/ p' \
| sed -e 's/^[ \t]\+//' \
| { echo '/* Width=48, Height=48 */'; $UNCOMPFACE; } \
| $ICONTOPBM \
| $VIEWER

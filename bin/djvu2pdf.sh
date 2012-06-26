#!/bin/bash
# Source: https://superuser.com/questions/100572/how-do-i-convert-a-djvu-document-to-pdf-in-linux-using-only-command-line-tools

# convert DjVu -> PDF
# usage:  djvu2pdf.sh  <file.djvu>

i="$1"
echo "------------ converting $i to PDF ----------------";
o="`basename $i .djvu`"
o="$o".pdf
echo "[ writing output to $o ] "

cmd="ddjvu -format=pdf -quality=95 -verbose $i $o "
$cmd


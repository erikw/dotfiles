#!/usr/bin/perl -w
# Escape XFace so it can be used in muttrc. Make XFace with http://www.dairiki.org/xface/ 

# perl script to quote my_hdr commands for Mutt.
# mainly useful for X-Face. headers.
# (c) 2004 Christoph Berg, GNU GPL.
# 2004-06-13 cb: initial version

@lines = <>;
foreach (@lines) {
	chomp;
	s/([\\;'"`\$#])/\\$1/g;
}

print join '\n', @lines;
print "\n";

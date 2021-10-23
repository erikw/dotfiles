" Vim hacks for mutt.

" Formats all quoted lines to &tw columns.
function! MailFormat()
	":+/^>.*$
	":normal gqip

	":g/^>.*$/normal gqq
	":silent g/^>.*$/,/^$/- normal! gqq
	silent execute "g/.\\{" . &textwidth . ",\\}/normal\! gqq"

endfunction

" Fix quoted text so that there is one space after the last quote character (/^>\+ .$/).
function! MailEnspaceReply()
	:silent %s/^\(>\+\)\([^> ].*\)$/\1 \2/e
endfunction

" Strip the last quoted .sig and blank lines above.
function! MailStripSig()
	":%s/^\%(>\s*\n\)*> -- \_.\{-}\n$//e
	:%s/^\%(>\s*\n\)*> -- \_.\{-}\n$//e

	" Alternative
	"normal! G
	":?^> -- *$
	"normal d}
endfunction

" Wrap long lines.
setlocal textwidth=80
" Color the 81th column.
let s:twcc = &textwidth +  1
execute "setlocal colorcolumn=" . s:twcc
" Auto format text.
setlocal formatoptions+=a
" Use par for gq (gw-> vim internal).
if executable("par")
	execute "setlocal formatprg=par\\ -w" . &textwidth . "qs0"
endif

call MailFormat()
call MailEnspaceReply()
call MailStripSig()
" Jump to the first blank line.
silent! +/^$
" Clear highlight from jump above.
:nohlsearch

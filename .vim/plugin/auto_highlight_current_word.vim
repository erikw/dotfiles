" Merged version of
" https://github.com/lygaret/autohighlight.vim
" and http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
" TODO load on start does not work
" TODO is not per buffer

let s:current = 0

function! s:clear()
	if (s:current > 0)
		call matchdelete(s:current)
		let s:current = 0
	endif
endfunction

function! s:highlight()
	call s:clear()
	let word = expand('<cword>')
	if (word != '')
		let s:current = matchadd('CursorAutoHighlight', '\V\<'.escape(word, '\').'\>')
	endif
endfunction

function! s:highlightEnable()
	highlight CursorAutoHighlight term=underline cterm=underline gui=underline
	setl updatetime=500 " only be idle on a word for 1/2 second. "
	augroup autohighlight
		au!
		au CursorHold * call s:highlight()
		au BufLeave * call s:clear()
		au BufEnter * call s:highlight()
	augroup end
endfunction

function! s:highlightDisable()
	call s:clear()
	au! autohighlight
	augroup! autohighlight
	setl updatetime=4000
endfunction


" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightCurrentWordToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightCurrentWordToggle()
	let @/ = ''
	if  exists('#autohighlight')
		call s:highlightDisable()
		echo 'Highlight current word: off'
		return 0
	else
		call s:highlightEnable()
		echo 'Highlight current word: on'
		return 1
	endif
endfunction

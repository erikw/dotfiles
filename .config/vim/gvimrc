" Erik Westrup's gVim & macVim configuration.
" Modeline {
"	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
" }

" Envionment {
	function! GetRunningOS()
		if has("win32")
			return "win"
		endif
		if has("unix")
			if system('uname')=~'Darwin'
				return "mac"
			else
				return "linux"
			endif
		endif
	endfunction
	let s:os=GetRunningOS()
" }

" UI {
	" a - try to make VISUAL select available in GUI SELECT paste.
	" c - use console dialog instead of GUI popup.
	" e - use GUI tabs.
	" g - gray out inactive GUI elements.
	" i - use Vim icon in upper left corner of window.
	" m - show menu bar.
	" L - hotizontal scrollbar only present when needed.
	" t - include tearoff menu items?
	set guioptions=acegimLt

	" Disable (0) cursor blinking.
	set guicursor+=n-v-c:blinkon0

	" Show tabnumber and title in tab label. Referenced: https://github.com/mkitt/tabline.vim/issues/8
	set guitablabel=\[%N\]\ %t\ %M


	if s:os == "linux"
		"set guifont=Monospace\ 11
		set guifont=Terminus\ Medium\ 14
	elseif s:os == "mac"
		" Use a monospace font that comes with macos by default
		"set guifont=Courier:h14
		" Get Inconsolata font here: https://github.com/google/fonts/tree/master/ofl/inconsolata
		set guifont=Inconsolata:h14

		" Quit MacVim.app when quitting last buffer in macOS.
		" Downside of this is that you get a GUI dialog (instead of console) when force-qutting.
		" A better way: Macvim > Preferences > General > "After the last window closes": Quit Macvim.
		" Reference:  https://superuser.com/questions/312097/how-to-configure-macvim-to-quit-on-exit
		"autocmd VimLeave * macaction terminate:
	endif
" }

" Auto color mode {
" Macvim automatic OS appearance mode. See
" https://github.com/macvim-dev/macvim/pull/929
" TODO move this to ~/.vimrc if vim from macvim gets support for this as well!
if s:os == "mac"
	func! ChangeBackground()
		if (v:os_appearance == 1)
			set background=dark
		else
			set background=light
		endif
		redraw!
	endfunc
	au OSAppearanceChanged * call ChangeBackground()
endif
" }

" Mappings {
	" Make shift-insert work like in xterm.
	map! <S-Insert> <MiddleMouse>
" }

" Source gvimrc on write.
autocmd! BufWritePost .gvimrc source ~/.gvimrc

" Erik Westrup's gVim & macVim configuration.

" Graphical options.
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

let s:os=GetRunningOS()
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

" Make shift-insert work like in xterm.
map! <S-Insert> <MiddleMouse>


" Source gvimrc on write.
autocmd! BufWritePost .gvimrc source ~/.gvimrc

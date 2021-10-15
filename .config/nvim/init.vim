" Erik Westrup's Neovim configuration.
" Modeline {
"	vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=4 :
" }

" Profiling {
" $ nvim --startuptime /tmp/nvim.log
" $ nvim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" TODO fix indentation of comments to be consistent in this file.

" Plugins {
" vim-plug data folder
call plug#begin(stdpath('data') . '/plugged')

" TODO migrate Vundle plugins from .vimrc
Plug 'overcache/NeoSolarized'

" Initialize plugin system
call plug#end() 
" }

" Environment {
set tags+=./tags;/	" Look for tags in current directory or search up until found. TODO default would suffice?

" Also use $HOME/.vim in Windows. TODO needed?
"if has('win32') || has('win64')
"	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"endif
" }

" General {
set undofile				" Save undo to file in undodir.
set mouse=a					" Enable mouse in all modes.

"set spell					" Enable spell highlighting and suggestions.
set spelllang=en_us				" Languages to do spell checking for.
set spellsuggest=best,10			" Limit spell suggestions.
" Set spellfile dynamically. Shared with Vim.
execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" TODO make this depend on 'spellang' if I can get files for Swedish and German.
set thesaurus+=~/.vim/thesaurus/mthesaur.txt    " Use a thesaurus file.
set completeopt=longest,menu,preview		" Insert most common completion and show menu.

set omnifunc=syntaxcomplete#Complete		" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
" TODO ALE not needed as neovim has native LSP? https://neovim.io/doc/lsp/
"set omnifunc=ale#completion#OmniFunc		" Use ALE for omnicompletion

set shortmess=filmnrxtToOI    			" Abbreviate messages.
set nrformats=alpha,bin,octal,hex			" What to increment/decrement with ^A and ^X.
set hidden						" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables when saving sessions.
set undolevels=2048				" Levels of undo to keep in memory.
"set clipboard+=unnamed				" Use register "* instead of unnamed register. This means what is being yanked in vim gets put to external clipboard automatically.
set timeoutlen=1500				" Timout (ms) for mappings and keycodes.
" }

" UI {
colorscheme NeoSolarized

" Adjust colors to this background.
if filereadable(expand("~/.solarizedtoggle/status"))
	let &background = readfile(expand("~/.solarizedtoggle/status"), '', 1)[0]
else
	"set background=dark
	" Lighter bg during night.
	" Source:  http://benjamintan.io/blog/2014/04/10/switch-solarized-light-slash-dark-depending-on-the-time-of-day/
	let s:hour = strftime("%H")
	if 7 <= s:hour && s:hour < 18
		set background=light
	else
		set background=dark
	endif
endif

set termguicolors	" Enable 24-bit RGB. Required by NeoSolarized.
set title			" Show title in console title bar.
set number						" Show line numbers.
set showmatch						" Shortly jump to a matching bracket when match.
set cursorline						" Highlight the current line.
"set cursorcolumn					" Highlight the current column.
set wildignorecase					" Case insensitive filename completion.
set scrolljump=5 					" Lines to scroll when cursor leaves screen.
set scrolloff=3 					" Minimum lines to keep above and below cursor.  set splitbelow						" Open horizontal split below.
set splitright						" Open vertical split to the right.
set listchars=eol:$,space:·,tab:>-,trail:¬,extends:>,precedes:<,nbsp:. 	" Characters to use for :list.
" }

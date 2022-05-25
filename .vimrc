" Erik Westrup's Vim configuration.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
" }
" gf shourtcuts:
" ~/.config/nvim/commons_plugin.vim
" ~/.config/nvim/commons.vim

" Profiling {
" $ vim --startuptime /tmp/vim.log
" $ vim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" Environment {
if v:version < 703
	echoerr 'WARNING: This vimrc is written for Vim >= v.703; this is' v:version
endif
set viminfo+=n~/.vim/viminfo	" Write the viminfo file inside the Vim directory.
set undodir=~/.vim/undo/	" Collect history instead of having them in '.'.
set tags+=./tags;/		" Look for tags in current directory or search up until found.

let g:xdg_config_home = empty($XDG_CONFIG_HOME) ? "$HOME/.config" : $XDG_CONFIG_HOME
let g:xdg_state_home = empty($XDG_STATE_HOME) ? "$HOME/.local/state" : $XDG_STATE_HOME

" Also use $HOME/.vim in Windows
if has('win32') || has('win64')
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" }

" Plugins {
" Setup {
let g:ale_completion_enabled = 1	" Must be set before ALE is loaded.

" vim-plug data folder
call plug#begin('~/.vim/plugged')
" }

" Common Plugins {
" gf shourtcut: ~/.config/nvim/commons_plugin.vim
execute "source " . g:xdg_config_home . "/nvim/commons_plugin.vim"
" }

" Setup - end {
" Initialize plugin system
call plug#end()
" }
" }

" Commons Config {
" gf shourtcut: ~/.config/nvim/commons_plugin_config.vim
execute "source " . g:xdg_config_home . "/nvim/commons.vim"
" }

" General {
set nocompatible		" Be IMproved. Should be first.
set encoding=utf-8		" Use Unicode inside Vim's registers, viminfo, buffers ...
"filetype plugin indent on	" File type specific features. Already set as part of Vundle setup.
syntax enable			" Syntax highlighting but keep current colors.
"syntax on			" Use default colors for syntax highlighting.
set mouse=a			" Enable mouse in all modes.
set viewoptions=folds,cursor,slash,unix	" What to save with mkview.
set history=512			" Store much history.


"set complete-=k complete+=k		" Put the dictionaries in the normal completion set.
set shortmess=filmnrxtTo		" Abbreviate messages.
set nrformats=alpha,octal,hex		" What to increment/decrement with ^A and ^X.
set hidden				" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set autoread				" Autoreload buffer from file if not changed in vim, e.g. with the :checktime command.
set sessionoptions-=options		" Don't store global and local variables when saving sessions.
set undofile				" Save undo to file in undodir.
set undolevels=2048			" Levels of undo to keep in memory.history.
set modelines=5				" Number of lines from head of file to check for modelines. Setting this explicitly as on some syste*m (like macos in /usr/share/vim/vimrc) disables modelined by default. "
set ttyfast				" Smoother changes.
set clipboard+=unnamed			" Use register "* instead of unnamed register.
set timeoutlen=1500			" Timout (ms) for mappings and keycodes.
if !has('gui_running')
	if !has('win32') && !has('win64')
		set term=$TERM		" Make arrow and other keys work.
	endif
	if &l:term  =~ "screen.*"
		set ttymouse=xterm2	" Needed for mouse support inside GNU Screen.
	endif
endif
if has("unix")
	let s:uname = system("uname -s")
	if s:uname == "Darwin"
		set clipboard=unnamed	" Make copy to clipboard work under macOS.
	endif
endif

" Function keys {
" Urxvt does not emit what Vim expects for the function keys.
" This must be after "set term".
" NOTE Not needed anymore it seems.
"if !empty($TERMEMU) && $TERMEMU  =~ ".*rxvt.*"
	"set <F1>=[11~
	"set <F2>=[12~
	"set <F3>=[13~
	"set <F4>=[14~
	"set <F5>=[15~
	"set <F6>=[17~
	"set <F7>=[18~
	"set <F8>=[19~
	"set <F9>=[20~
	"set <F10>=[21~
	"set <F11>=[23~
	"set <F12>=[24~
	""set termencoding=latin1	" This will make Meta key work if meta8 is enabled.
"end
" }
" }

" Formatting {
set linebreak			" Wrap on 'breakat'-chars.
"set showbreak=>		" Indicate wrapped lines.
set showbreak=…			" Indicate wrapped lines.
set smartindent			" Indent smart on C-like files.
set preserveindent		" Try to preserve indent structure on changes of current line.
set copyindent			" Copy indentstructure from existing lines.
set tabstop=8			" Let a tab be X spaces wide. 8 spaces for a tab render best as HTML on e.g. GithHub.
set shiftwidth=8		" Tab width for auto indent and >> shifting.
"set softtabstop=8		" Number of spaces to count a tab for on ops like BS and tab.
set noexpandtab			" Do not expand tabs to spaces!
set matchpairs+=<:>		" Also match <> with %.
set formatoptions=tcroqwnl	" Formatting options.
set cinoptions+=g=		" Left-indent C++ access labels.
"set pastetoggle  = <Leader>p    " Toggle 'paste' for sane pasting.
" }

" Searching {
set hlsearch	" Highlight search.
set incsearch	" Incremental search.
set ignorecase	" Case insensitive search.
set smartcase	" Smart case search.
set nowrapscan	" Don't wrap search around file.
" }

" Spelling {
"set spell			" Enable spell highlighting and suggestions.
set spellsuggest=best,10	" Limit spell suggestions.
set spelllang=en_us		" Languages to do spell checking for.
" Set spellfile dynamically.
execute "set spellfile=" . g:xdg_config_home ."/nvim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
execute "set thesaurus=" . g:xdg_config_home . "/nvim/thesaurus/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . ".txt"
set dictionary+=~/.vim/spell/		" Use custom dictionaries.
"set dictionary+=/usr/share/dict/words	" Use system dictionary.
" }

" UI {
silent! colorscheme NeoSolarized	" Ignore if don't exist. Ref: https://stackoverflow.com/a/5703164/265508

set t_Co=256		" Set number of colors.
"hi Normal ctermbg=NONE	" Transparent background.
set title		" Show title in console title bar.
" Adjust colors to this background.
let s:solarized_status = g:xdg_state_home . "/solarizedtoggle/status"
if filereadable(s:solarized_status)
	let &background = readfile(s:solarized_status)[0]
else
	" Lighter bg during night.
	" Source:  http://benjamintan.io/blog/2014/04/10/switch-solarized-light-slash-dark-depending-on-the-time-of-day/
	let s:hour = strftime("%H")
	if 7 <= s:hour && s:hour < 18
		set background=light
	else
		set background=dark
	endif
endif

set number				" Show line numbers.
set tabpagemax=64			" Upper limit on number of tabs.
set showmode				" Show current mode in the last line.
set backspace=indent,eol,start		" Make backspace work like expected.
set linespace=0				" No line spacing.
set showmatch				" Shortly jump to a matching bracket when match.
set wildmode=full			" Full completion.
set wildignorecase			" Case insensitive filename completion.
set scrolljump=5			" Lines to scroll when cursor leaves screen.
set scrolloff=3				" Minimum lines to keep above and below cursor.
set splitbelow				" Open horizontal split below.
set splitright				" Open vertical split to the right.
set foldenable				" Use folding.
set showcmd				" Show incomplete commands in the lower right corner.
set ruler				" Show current cursor position in the lower right corner.
set laststatus=2			" Always show the status line.
set nolist				" Don't show unprintable characters.
"set listchars=eol:$,tab:>-,trail:¬,extends:>,precedes:<,nbsp:.	" Characters to use for list.
set listchars=eol:$,space:·,tab:>-,trail:¬,extends:>,precedes:<,nbsp:.	" Characters to use for list.
set cursorline				" Highlight the current line.
"set cursorcolumn			" Highlight the current column.
" Colors of the CursorLine.
"hi CursorLine cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
"hi CursorColumn cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black

" }

" Plugin Config {
" vim-startify {
" Bookmarks
let g:startify_bookmarks = [
	\ {'v': '$HOME/.vimrc'},
	\ {'p': g:xdg_config_home . '/nvim/commons_plugin.vim'},
	\ {'c': g:xdg_config_home . '/nvim/commons.vim'},
	\ g:xdg_config_home . '/shell/commons',
	\ g:xdg_config_home . '/shell/aliases'
	\ ]

let g:startify_fortune_use_unicode = 1	" Draw fortune with Unicode instead of ASCII.


" Reference: https://vi.stackexchange.com/a/9942
let s:vim_version = matchstr(execute('version'), 'Vi IMproved \zs\d[^ ]*')

" Custom logo instead of cowsay.
let s:ascii = [
\ '    ##############..... ##############',
\ '    ##############......##############',
\ '      ##########..........##########',
\ '      ##########........##########',
\ '      ##########.......##########',
\ '      ##########.....##########..',
\ '      ##########....##########.....',
\ '    ..##########..##########.........',
\ '  ....##########.#########.............',
\ '    ..##################.............',
\ '      ################.............',
\ '      ##############.............',
\ '      ############.............',
\ '      ##########.............',
\ '      ########.............',
\ '      ######    .........',
\ '                  .....',
\ '                    .',
\ '      Vim ' . s:vim_version
\]
"let g:startify_custom_header = s:ascii + startify#fortune#boxed()
let g:startify_custom_header = s:ascii

" Show version in fooder. Reference: https://github.com/mhinz/vim-startify/issues/449
"let g:startify_custom_footer = "startify#pad(['', '\ufa76' . matchstr(execute('version'), 'NVIM v\\z\\s[^\\n]\*'), ''])"
" }
" }

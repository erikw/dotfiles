" Erik Westrup's Vim configuration.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
" }

" Profiling {
" $ vim --startuptime /tmp/vim.log
" $ vim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" TODO extracted common plugins like done with .config/nvim/commons_plugin_config.vim?
" Plugins {
" Setup {
let g:ale_completion_enabled = 1	" Must be set before ALE is loaded.

" vim-plug data folder
call plug#begin('~/.vim/plugged')
" }

" General {
	"Plug 'dhruvasagar/vim-table-mode'			" Create ASCII tables
	"Plug 'godlygeek/tabular'				" Create tables. Disabled: not used and have some startup time.
	"Plug 'mattn/vim-gist' | Plug 'mattn/webapi-vim'	" Post a new Gist.
	"Plug 'salsifis/vim-transpose'				" Matrix transposition of texts.
	"Plug 'scrooloose/nerdtree'				" Replaced by built-in netrw
	"Plug 'vim-scripts/lbdbq'				" Mutt: Query lbdb for recipinents.
	"Plug 'voldikss/vim-translator'				" Async language translator.
	Plug 'bfontaine/Brewfile.vim', { 'for': 'brewfile' }	" Syntax for Brewfiles
	Plug 'danro/rename.vim'					" Provides the :Rename command
	Plug 'fidian/hexmode'					" Open binary files as a HEX dump with :Hexmode
	Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}	" Live preview markdown files in browser.
	Plug 'mbbill/undotree'					" Navigate history in a sidebar. Replaces old 'mbbill/undotree'
	Plug 'michaeljsmith/vim-indent-object'			" Operate on intendtation as text objects
	Plug 'ntpeters/vim-better-whitespace'			" Highlight and remove trailing whitespaces.
	Plug 'preservim/nerdcommenter'				" Comment source code.
	Plug 'tpope/vim-capslock'				" Software CAPSLOCK.
	Plug 'tpope/vim-fugitive'				" Git wrapper and shorthands.
	Plug 'tpope/vim-repeat'					" Extend '.' repetition for plugins like vim-surround, vim-speeddating.
	Plug 'tpope/vim-speeddating'				" Increment dates with C-a.
	Plug 'tpope/vim-surround'				" Work on surrond delimiters or its content.
	Plug 'tpope/vim-unimpaired'				" Bracket mappings like [<space>
"}

" Development {
" Development: General {
	Plug 'AndrewRadev/sideways.vim'			" Shift function arguments left and right.
	Plug 'airblade/vim-gitgutter'			" Git modified status in sign column
	Plug 'andymass/vim-matchup'				" Extend % matching. Replaces old the matchit plugin.
	Plug 'cohama/lexima.vim'				" Autmoatically close opened braces etc. Replaces old 'Townk/vim-autoclose'.
	Plug 'dense-analysis/ale'				" LSP linting engine.
	Plug 'editorconfig/editorconfig-vim'	" Standard .editorconfig file in shared projects.
	Plug 'preservim/tagbar'					" Sidepane showing info from tags file.
	Plug 'rhysd/conflict-marker.vim'		" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
	Plug 'vim-scripts/argtextobj.vim'		" Make function arguments text objects that can be operated on with.
"}

" Development: C/C++ {
	"Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
	"Plug 'chazy/cscope_maps'					" More macros than autoload_cscope.vom
	"Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }
	Plug 'vim-scripts/autoload_cscope.vim', { 'for': ['c', 'cpp'] }	" Load cscope file and define macros for using it. https://github.com/vim-scripts/autoload_cscope.vim/blob/master/plugin/autoload_cscope.vim#L81-L88
	Plug 'craigemery/vim-autotag'				" Autogenerate new tags file. Could replace with https://github.com/ludovicchabant/vim-gutentags
"}

" Development: Go {
	"Plug 'fatih/vim-go', { 'for': 'go' }	" Compilation commands etc.
"}

" Development: Java {
	"Plugin 'artur-shaik/vim-javacomplete2', { 'for': 'java' }	" Omni-complete for Java
	"Plugin 'erikw/jcommenter.vim', { 'for': 'java' }		" Generate javadoc.
"}

" Development: LaTeX {
	"Plug 'donRaphaco/neotex'				" Live preview PDF output from latex.
	Plug 'LaTeX-Box-Team/LaTeX-Box'			" TODO replace with https://github.com/latex-lsp/texlab
" }

" Development: Python {
	"Plugin 'davidhalter/jedi-vim', { 'for': 'python' }	" Autocompletion using jedi library.
	"Plugin 'python-rope/ropevim', { 'for': 'python' }	" Refactoring with rope library.
	"Plugin 'fisadev/vim-isort', { 'for': 'python' }	" Sort imports
"}

" Development: Swift {
	"Plugin 'keith/swift.vim', { 'for': 'switft' }	" Syntax files for Switch
"}

" Development: Web {
	Plug 'ap/vim-css-color', { 'for': ['css', 'scss'] }	" Display CSS colors in vim.
" }
" }

" Navigation {
	" FZF - Fuzzy finding
	" - Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
	" - Commands: https://github.com/junegunn/fzf.vim#commands
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
" }

" Snippets {
	Plug 'garbas/vim-snipmate' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim'
	Plug 'honza/vim-snippets'				" Snippet library
	Plug 'rbonvall/snipmate-snippets-bib', { 'for': 'tex' }	" Bibtex snippets.
" }

" UI {
	"Plug 'vim-scripts/ScrollColors'	" Cycle though available colorschemes.
	Plug 'cormacrelf/dark-notify'		" Watch system light/dark mode changes.  Requires dark-notify(1).
	Plug 'mhinz/vim-startify'		" Start screen with recently opended files.
	Plug 'mkitt/tabline.vim'		" More informative tab titles.


" Colorschemes {
	"Plug 'altercation/vim-colors-solarized'	" The one theme to rule them all.
	"Plug 'mhartington/oceanic-next'
	"Plug 'morhetz/gruvbox'
	Plug 'overcache/NeoSolarized'
" }
"}

" Setup - end {
" Initialize plugin system
call plug#end()
" }
" }

" Environment {
if v:version < 703
	echoerr 'WARNING: This vimrc is written for Vim >= v.703; this is' v:version
endif
set nocompatible		" Be IMproved. Should be first.
set viminfo+=n~/.vim/viminfo	" Write the viminfo file inside the Vim directory.
set undodir=~/.vim/undo/	" Collect history instead of having them in '.'.
set tags+=./tags;/		" Look for tags in current directory or search up until found.
set encoding=utf-8		" Use Unicode inside Vim's registers, viminfo, buffers ...

let s:xdg_config_home = empty($XDG_CONFIG_HOME) ? "$HOME/.config" : $XDG_CONFIG_HOME
let s:xdg_state_home = empty($XDG_STATE_HOME) ? "$HOME/.local/state" : $XDG_STATE_HOME

" Also use $HOME/.vim in Windows
if has('win32') || has('win64')
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" }

" General {
"filetype plugin indent on	" File type specific features. Already set as part of Vundle setup.
syntax enable			" Syntax highlighting but keep current colors.
"syntax on			" Use default colors for syntax highlighting.
set mouse=a			" Enable mouse in all modes.
set viewoptions=folds,cursor,slash,unix	" What to save with mkview.
set history=512			" Store much history.


"set complete-=k complete+=k		" Put the dictionaries in the normal completion set.
set completeopt=longest,menu,preview	" Insert most common completion and show menu.
"set omnifunc=syntaxcomplete#Complete	" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
set omnifunc=ale#completion#OmniFunc	" Use ALE for omnicompletion
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

" Abbreviations {
" Expand my name.
"iabbrev ew Erik Westrup
" }

" Commands {
" Sort words on the current line.
command! Sortline call setline(line('.'),join(sort(split(getline('.'))), ' '))
" Write with extended privileges.
command! Wsudo silent w !sudo tee % > /dev/null
" Update and run make.
command! Wmake update | silent !make >/dev/null
" See buffer and file diff.
command! Wdiff w !diff % -

" Change to directory of current file.
command! Cdpwd cd %:p:h
command! Lcdpwd lcd %:p:h

command! -nargs=* Wrap set wrap linebreak nolist	" Set softwrap correctly.
autocmd BufWinLeave * silent! mkview			" Save fold views.
autocmd BufWinEnter * silent! loadview			" Load fold views on start.
"autocmd! BufWritePost .vimrc source $MYVIMRC		" Source first found vimrc on change.
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

" Mappings {
let mapleader = "\\"					" The key for <Leader>.
nmap <silent> <C-_> :nohlsearch<CR>			" Clear search matches highlighting. (Ctrl+/ => ^_)
"nmap <silent> <C-_> :let @/=""<CR>			" Clear search matches highlighting. (Ctrl+/ => ^_)
nmap <silent> <Leader>v :source $MYVIMRC<CR>		" Source vimrc.
nmap <silent> <Leader>V :tabe $MYVIMRC<CR>		" Edit vimrc.
"nmap <silent> <Leader>d "=strftime("%Y-%m-%d")<CR>P	" Insert the current date.
noremap <silent> <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>	" Open tags definition in a new tab.
noremap <silent> <Leader>] :vsp<CR>:exec("tag ".expand("<cword>"))<CR>	" Open tags definition in a vertical split.
"nmap <silent> <Leader>S :%s/\s\+$//ge<CR>		" Remove all trailing spaces.
nnoremap <silent> gfs :wincmd f<CR>			" Open path under cursor in a split.
nnoremap <silent> gfv :vertical wincmd f<CR>		" Open path under cursor in a vertical split.
nnoremap <silent> gft :tab wincmd f<CR>			" Open path under cursor in a tab.
nnoremap <silent> gV `[v`]				" Visually select the text that was last edited/pasted.
nnoremap g^t :tabfirst<CR>				" Go to first tab.
nnoremap g$t :tablast<CR>				" Go to last tab.
noremap Yf :let @" = expand("%")<CR>			" Yank current file name.
noremap YF :let @" = expand("%:p")<CR>			" Yank current (fully expanded) file name.
nnoremap <silent> <Leader>R :checktime<CR>		" Reload buffers from file if changed.

" Redraw window so that search terms are centered.
nnoremap n nzz
nnoremap N Nzz

" Calculate current Word e.g. type 1+2 and press ^c.
inoremap <C-c> <C-O>yiW<End>=<C-R>=<C-R>0<CR>=

" Enable ^d and ^u movement in completion dialog.
inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

if &l:term  =~ "screen.*"
	noremap <silent> <C-x>x <C-x>	" Decrement for consistency with GNU Screen.
endif

" Toggles {
noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>		" Toggle line wrapping.
noremap <silent> <Leader>` :set list!<CR>			" Toggle listing of characters. See listchars.
noremap <silent> <ESC>p :set paste! paste?<CR>			" Toggle 'paste' for sane pasting.
noremap <silent> <leader>p :set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>	" Paste on line after in paste-mode from register "*.
noremap <silent> <leader>P :set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>	" Paste on line before in paste-mode from register "*.

" Toggle spell with a language. {
function! ToggleSpell(lang)
	if !exists("b:old_spelllang")
		let b:old_spelllang = &spelllang
		let b:old_spellfile = &spellfile
		let b:old_thesaurus = &thesaurus
		let b:old_dictionary = &dictionary
	endif

	let l:newMode = ""
	if !&l:spell || a:lang != &l:spelllang
		setlocal spell
		let l:newMode = "spell, " . a:lang
		execute "setlocal spelllang=" . a:lang
		execute "setlocal spellfile=" . "~/.vim/spell/" . matchstr(a:lang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
		execute "setlocal dictionary=" . "~/.vim/spell/" . a:lang . "." . &encoding . ".dic"
		execute "setlocal thesaurus=" . "~/.vim/thesaurus/" . a:lang . ".txt"
	else
		setlocal nospell
		let l:newMode = "nospell"
		execute "setlocal spelllang=" . b:old_spelllang
		execute "setlocal spellfile=" . b:old_spellfile
		execute "setlocal dictionary=" . b:old_dictionary
		execute "setlocal thesaurus=" . b:old_thesaurus
	endif
	return l:newMode
endfunction
" }
nmap <silent> <F6> :echo ToggleSpell("en_us")<CR>	" Toggle English spell.
nmap <silent> <F7> :echo ToggleSpell("sv")<CR>		" Toggle Swedish spell.
nmap <silent> <F8> :echo ToggleSpell("de")<CR>		" Toggle German spell.

" Toggle between static and relative line numbers. {
function! ToggleLine()
	if &number
		set relativenumber
	else
		set number
	endif
endfunction
" }
" Toggle static/relative line numbering.
if v:version >= 74
	nmap <Leader>l :set relativenumber!<CR>
else
	nmap <Leader>l :call ToggleLine()<CR>
endif

" Toggle Cursor {
function! HighlightNearCursor()
	if !exists("s:highlightcursor")
		match Todo /\k*\%#\k*/
		let s:highlightcursor=1
	else
		match None
		unlet s:highlightcursor
	endif
endfunction
" }
nmap <silent> <Leader>J :call HighlightNearCursor()<CR>	" Toggle highlight on cursor-word.

" Toggle mouse {
function! ToggleMouse()
	if &mouse == "a"
		set mouse=
	else
		set mouse=a
	endif
	set mouse?
endfunction
" }
nmap <Leader>m :call ToggleMouse()<CR>	" Toggles mouse on and off.

" Toggle background mode {
function! ToggleBackgroundMode()
	if &background == "light"
		set background=dark
	else
		set background=light
	endif
	set background?
endfunction
" }
nmap <silent> <F5> :call ToggleBackgroundMode()<CR>	" Toggle between light and dark background mode.
" }

" Cmaps {
" Prevent saving buffer to a file '\'.
cmap w\ echoerr "Using a Swedish keyboard?"<CR>
" }
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
execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
execute "set thesaurus=" . "~/.vim/thesaurus/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . ".txt"
set dictionary+=~/.vim/spell/		" Use custom dictionaries.
"set dictionary+=/usr/share/dict/words	" Use system dictionary.
" }

" UI {
colorscheme NeoSolarized

set t_Co=256		" Set number of colors.
"hi Normal ctermbg=NONE	" Transparent background.
set title		" Show title in console title bar.
" Adjust colors to this background.
let s:solarized_status = s:xdg_state_home . "/solarizedtoggle/status"
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

" Statusline {
" Comment these out when using powerline statusbar.
set statusline=%t			" Tail of the filename.
set statusline+=%m			" Modified flag.
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},	" File encoding.
set statusline+=%{&ff}]			" File format.
set statusline+=%h			" Help file flag.
set statusline+=%r			" Read only flag.
set statusline+=%y			" Filetype.
"set statusline+=['%{getline('.')[col('.')-1]}'\ \%b\ 0x%B]	" Value of byte under cursor.

set statusline+=%#StatusLineNC#		" Change highlight group
set statusline+=%{fugitive#statusline()}	" Show current branch.
set statusline+=%*
set statusline+=%{tagbar#currenttag('[#%s]','')}	" Current tag.

set statusline+=%=			" Left/right-aligned separator.
"set statusline+=[\%b\ 0x%B]\		" Value of byte under cursor.
"set statusline+=[0x%O]\		" Byte offset from start.
set statusline+=%l/%L,			" Cursor line/total lines.
set statusline+=%c			" Cursor column.
set statusline+=\ %P			" Percent through file.
set statusline+=\ 0x%B			" Character valur under cursor.
" }
" }

" Plugin Config {
" gF shourtcut: ~/.config/nvim/commons_plugin_config.vim
execute "source " . s:xdg_config_home . "/nvim/commons_plugin_config.vim"

" vim-startify {
" Bookmarks
let g:startify_bookmarks = [
	\ {'v': '$HOME/.vimrc'},
	\ {'p': s:xdg_config_home . '/nvim/commons_plugin_config.vim'},
	\ s:xdg_config_home . '/shell/commons',
	\ s:xdg_config_home . '/shell/aliases'
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

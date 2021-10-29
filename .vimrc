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

" Plugins {
" See *vundle-plugins-uris* for Plugin syntax.
let g:ale_completion_enabled = 1	" Must be set before ALE is loaded.
let s:using_vundle = 1			" Vundle will break default behaviour of spellfile. Let others know when using Vundle.

set nocompatible           " be iMproved, required
filetype off                " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" General {
"Plugin 'dhruvasagar/vim-table-mode'
"Plugin 'fatih/vim-go'
"Plugin 'godlygeek/tabular'		" Disabled: not used and have some startup time.
"Plugin 'mattn/gist-vim'
"Plugin 'mattn/webapi-vim'		" Required for gist-vim
"Plugin 'salsifis/vim-transpose'
"Plugin 'scrooloose/nerdtree'		" Replaced by built-in netrw
"Plugin 'sjl/gundo.vim'			" Use mbbill/undotree instead; is better: https://vi.stackexchange.com/a/13863
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'MarcWeber/vim-addon-mw-utils'	" Required for  garbas/vim-snipmate.
Plugin 'bfontaine/Brewfile.vim'
Plugin 'danro/rename.vim'
Plugin 'fidian/hexmode'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'instant-markdown/vim-instant-markdown'
Plugin 'mbbill/undotree'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'rbonvall/snipmate-snippets-bib'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tomtom/tlib_vim'		" Required for garbas/vim-snipmate
Plugin 'tpope/vim-capslock'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
"}

" UI {
"Plugin 'flazz/vim-colorschemes'
"Plugin 'ScrollColors'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mkitt/tabline.vim'		" More informative tab titles. Only for terminal; gvim uses guilabel setting.
Plugin 'mhinz/vim-startify'		" Start screen with recently opended files.
"}

" Navigation {
"Plugin 'FuzzyFinder'	" Disabled, as it has high startup time
"Plugin 'L9'			" Required for FuzzyFinder.
"Plugin 'wincent/command-t'

" FZF - Fuzzy finding
" - Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
" - Commands: https://github.com/junegunn/fzf.vim#commands
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
"}

" Development: General {
"Plugin 'Townk/vim-autoclose'
"Plugin 'scrooloose/syntastic'		" Replaced by ale
Plugin 'AndrewRadev/sideways.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'cohama/lexima.vim'		" Autmoatically close opened braces etc.
Plugin 'argtextobj.vim'
Plugin 'dense-analysis/ale'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'majutsushi/tagbar'
Plugin 'rhysd/conflict-marker.vim'	" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
Plugin 'tmhedberg/matchit'

"}

" Development: C/C++ {
"Plugin 'Rip-Rip/clang_complete'
"Plugin 'rhysd/vim-clang-format'
"Plugin 'chazy/cscope_maps'
Plugin 'autoload_cscope.vim'
Plugin 'craigemery/vim-autotag'
"}

" Development: Java {
"Plugin 'artur-shaik/vim-javacomplete2'
"Plugin 'erikw/jcommenter.vim'
"}

" Development: Python {
"Plugin 'davidhalter/jedi-vim'
"Plugin 'python-rope/ropevim'
"Plugin 'fisadev/vim-isort'
"}

" Development: Swift {
"Plugin 'keith/swift.vim'
"}

" Development: Web {
Plugin 'ap/vim-css-color'	" Display CSS colors in vim.
" }

" mutt {
"Plugin 'lbdbq'
"}

call vundle#end()            " required
filetype plugin indent on    " required
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
set tabstop=4			" Let a tab be X spaces wide.
set shiftwidth=4		" Tab width for auto indent and >> shifting.
"set softtabstop=4		" Number of spaces to count a tab for on ops like BS and tab.
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
		if exists("s:using_vundle")
			let b:old_dictionary = &dictionary
		endif
	endif

	let l:newMode = ""
	if !&l:spell || a:lang != &l:spelllang
		setlocal spell
		let l:newMode = "spell, " . a:lang
		execute "setlocal spelllang=" . a:lang
		if exists("s:using_vundle")
			execute "setlocal spellfile=" . "~/.vim/spell/" . matchstr(a:lang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
		endif
		execute "setlocal dictionary=" . "~/.vim/spell/" . a:lang . "." . &encoding . ".dic"
		execute "setlocal thesaurus=" . "~/.vim/thesaurus/" . a:lang . ".txt"
	else
		setlocal nospell
		let l:newMode = "nospell"
		execute "setlocal spelllang=" . b:old_spelllang
		if exists("s:using_vundle")
			execute "setlocal spellfile=" . b:old_spellfile
		endif
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
colorscheme solarized	" Use the solarized colorscheme.

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
" ALE {
" Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
" Linting {
" Disabled linters:
		"\ 'sql': ['sqls'],
		"\ 'tex': ['texlab'],
let g:ale_linters = {
		\ 'go': ['gopls'],
		\ 'json': ['jsonls'],
		\ 'python': ['pyright'],
		\ 'ruby': ['solargraph'],
		\ 'sh': ['language_server'],
		\ 'vim': ['vimls'],
		\ }
" }

" Fixing {
" Removed 'trim_whitespace' and 'remove_trailing_lines' as it overlaps with the functionally already provided by vim-better-whitespace.
let g:ale_fixers = {
	\ '*': ['prettier'],
	\ 'ruby': ['rubocop'],
	\}
let g:ale_fix_on_save = 1
" }

" Completion {
let g:ale_completion_autoimport = 1
" Trigger on ^x^o
set omnifunc=ale#completion#OmniFunc
" }

" Mappings {
" See :help ale-commands
" Make similar keybindings to https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gr <Plug>(ale_find_references)
nmap <silent> K <Plug>(ale_hover)
nmap <silent> <space>rn <Plug>(ale_rename)

" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" }
" }

" clang_complete {
	"let g:clang_auto_select = 1				" Select first entry but don't insert.
	"let g:clang_complete_copen = 1				" Open quickfix on error.
	"let g:clang_close_preview = 1				" Close preview after completion.
	"let g:clang_user_options = '2>/dev/null || exit 0'	" Ignore clang errors.
	"let g:clang_complete_macros = 1			" Complete preprocessor macros and constants.
	"let g:clang_complete_patterns = 1			" Complete code patters e.g. loop constructs.
" }

" fzf.vim {
" Stolen from my friend https://github.com/erikagnvall/dotfiles/blob/master/vim/init.vim
" Comment must be on line of its own...
" Search for files in given path.
nnoremap <leader>f :FZF<space>
" Search for files starting at current directory.
nnoremap <c-p> :Files<CR>
" Search in tags file.
nnoremap <leader>T :Tags<CR>
" Search open buffers.
" ; conflicts with repeating search for characther (fF]
"nnoremap ; :Buffers<CR>
"nnoremap <leader>; :Buffers<CR>
nnoremap <leader>b :Buffers<CR>
" Search open tabs (indirectly; " https://medium.com/@paulodiovani/vim-buffers-windows-and-tabs-an-overview-8e2a57c57afa).
nnoremap <leader>t :Windows<CR>
" Search history of opended files
nnoremap <leader>h :History<CR>
" }

	" nerdcommenter {
	" Swap invert comment toggle.
		"map <silent> <Leader>c<Space> <plug>NERDCommenterInvert
		"map <silent> <Leader>ci <plug>NERDCommenterToggle
	" }

" netrw {
" Ships by default with vim mostly.
" Reference: https://shapeshed.com/vim-netrw/
" Reference: " http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
noremap <silent> <F2> :Lexplore<CR>	" Toggle the left vertical window
let g:netrw_liststyle = 3		" Default view: tree. Cycle with (i).
let g:netrw_banner = 0			" Remove space consuming top header text.
let g:netrw_browse_split = 4		" Open in previous window by default (like NERDTree).
let g:netrw_winsize = 20		" %-tage of window space to take in the respective open mode (vertical/horizontal).
"let g:netrw_altv = 1			" Supposedly needed to splitit to left. However not needed as I just use :LExplore?

" Auto close {
" Close after opening a file (which gets opened in another window)
" Reference: https://stackoverflow.com/a/69029703/265508
let g:netrw_fastbrowse = 0
autocmd FileType netrw setl bufhidden=wipe
function! CloseNetrw() abort
	for bufn in range(1, bufnr('$'))
		if bufexists(bufn) && getbufvar(bufn, '&filetype') ==# 'netrw'
			silent! execute 'bwipeout ' . bufn
			if getline(2) =~# '^" Netrw '
				silent! bwipeout
			endif
			return
		endif
	endfor
endfunction
augroup closeOnOpen
	autocmd!
	autocmd BufWinEnter * if getbufvar(winbufnr(winnr()), "&filetype") != "netrw"|call CloseNetrw()|endif
aug END
" }
" }

" nvim-cmp {
"set completeopt=menu,menuone,noselect

"" Lua Setup {
" Copy and paste latest setup from https://github.com/hrsh7th/nvim-cmp#setup
" Not possible to comment out as lua code is interpreted still somehow.
" The essential custom part is kept here:
  "-- Setup lspconfig.
  "require('lspconfig')['bashls'].setup {
    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    "}
  "require('lspconfig')['jsonls'].setup {
    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    "}
  "require('lspconfig')['pyright'].setup {
    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    "}
  "require('lspconfig')['solargraph'].setup {
    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    "}
  "require('lspconfig')['vimls'].setup {
    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  "}

" INSERT CONFIG FROM README HERE.
"" }
" }

" tagbar {
nmap <silent> <F3> :TagbarToggle<CR>	" Toggle the Tagbar window.
let g:tagbar_left = 0			" Keep the window on the right side.
let g:tagbar_width = 30			" Width of window.
let g:tagbar_autoclose = 1		" Close tagbar when jumping to a tag.
let g:tagbar_autofocus = 1		" Give tagbar focus when it's opened.
let g:tagbar_sort = 1			" Sort tags alphabetically.
let g:tagbar_compact = 1		" Omit the help text.
let g:tagbar_singleclick = 1		" Jump to tag with a single click.
let g:tagbar_autoshowtag = 1		" Open folds if tag is not visible.
" }

" vim-autoclose {
"let g:AutoClosePairs = "() [] {} <> «» ` \" '"	" Pairs to auto-close.
""let g:AutoCloseProtectedRegions = ["Comment", "String", "Character"]	" Syntax regions to ignore.

"noremap <silent> <Leader>ac :AutoCloseToggle<CR>				" Toggle vim-autoclose plugin mode.
" }

" vim-better-whitespace {
let g:strip_whitelines_at_eof=1		" Also strip empty lines at end of file on save.
let g:show_spaces_that_precede_tabs=1	" Highlight spaces that happens before tab.
let g:strip_whitespace_on_save = 1	" Activate by default.
let g:strip_whitespace_confirm=0	" Don't ask for permission.
" Filetypes to ignore even when strip_whitespace_on_save=1
"let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>',


" Use same command as in the old ~/.vim/plugin/stripspaces.vim
" Need to wrap the command in a function as we can't chain
" commands unless they were declared to support this.
" Reference: " https://unix.stackexchange.com/questions/144568/how-do-i-write-a-command-in-vim-to-run-multiple-commands
function! StripWhitespaceWrapper()
	execute 'StripWhitespace'
endfunction
command! Ws call StripWhitespaceWrapper() | update

" Like :wq but strip whitespaces first.
command! Wqs call StripWhitespaceWrapper() | wq
" Like :wqa but strip whitespaces in each buffer first.
command! Wqas bufdo call StripWhitespaceWrapper() | wq
" }

" vim-clang-format {
"let g:clang_format#auto_format = 0			" Auto format on save.
"let g:clang_format#auto_formatexpr = 1			" Let vim's formatexpr be set to clang-format (format with gq).
"autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

"" Git pull request for this: https://github.com/rhysd/vim-clang-format/pull/17
"function! ClangFormatAutoToggleFunc()
	"if !exists("g:clang_format#auto_format") || g:clang_format#auto_format == 0
		"let g:clang_format#auto_format = 1
		"echo "Auto clang-format: enabled"
	"else
		"let g:clang_format#auto_format = 0
		"echo "Auto clang-format: disabled"
	"endif
"endfunction
"" Toggle auto clang-format.
"command! ClangFormatAutoToggle call ClangFormatAutoToggleFunc()
"nmap <Leader>C :ClangFormatAutoToggle<CR>
"}

" vim-fugative {
autocmd BufReadPost fugitive://* set bufhidden=delete	" Close Fugitive buffers when leaving.
" }

" vim-gist {
let g:gist_detect_filetype = 1				" Detect filetype from name.
let g:gist_show_privates = 1				" Let Gist -l show private gists.
let g:gist_private = 1					" Make private the default for new Gists.
let g:gist_open_browser_after_post = 1			" Open in browser after post.
"let g:gist_clip_command = 'xclip -selection clipboard'	" Copy command.
"let g:gist_browser_command = 'w3m %URL%'		" Browser to use.
let g:gist_browser_command = 'firefox  %URL%'		" Browser to use.
" }

" vim-gitgutter {
set updatetime=100		" Speedier update of file status.

" }

" vim-instant-markdown {
" Blocklist certain paths for previewing files (recursively).
" See https://github.com/instant-markdown/vim-instant-markdown/issues/198
let g:instant_markdown_autostart=0
augroup InstantMarkdownGroup
  autocmd!
  au! BufReadPre,BufNewFile,BufEnter,BufFilePre *.md let g:instant_markdown_autostart=1
  au! BufReadPre,BufNewFile,BufEnter,BufFilePre ~/src/github.com/erikw/hackerrank-solutions/*.md,~/src/github.com/erikw/leetcode-solutions/*.md let g:instant_markdown_autostart=0
augroup END
" }

" vim-snipmate {
let g:snipMate = { 'snippet_version' : 1 }	" Use the new parser (and surpress message about using the old parser).
" }

" vim-startify {
" Bookmarks
let g:startify_bookmarks = [ {'v': '$HOME/.vimrc'}, s:xdg_config_home . '/shell/commons', s:xdg_config_home . '/shell/aliases' ]

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

" sideways.vim {
nnoremap <silent> <a :SidewaysLeft<CR>		" Move function argument to the left.
nnoremap <silent> >a :SidewaysRight<CR>		" Move function argument to the right.
" }

" undotree {
nmap <silent> <F4> :UndotreeToggle<CR>	" Toggle side pane.
let g:undotree_WindowLayout=2		" Set style to have diff window below.
let g:undotree_SetFocusWhenToggle=1	" Put cursor in undo window on open.
" }
" }

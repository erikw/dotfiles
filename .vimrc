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

" General {
	"Plug 'dhruvasagar/vim-table-mode'			" Create ASCII tables
	"Plug 'godlygeek/tabular'				" Create tables. Disabled: not used and have some startup time.
	"Plug 'mattn/vim-gist' | Plug 'mattn/webapi-vim'	" Post a new Gist.
	"Plug 'salsifis/vim-transpose'				" Matrix transposition of texts.
	"Plug 'scrooloose/nerdtree'				" Replaced by built-in netrw
	"Plug 'vim-scripts/lbdbq'				" Mutt: Query lbdb for recipinents.
	"Plug 'voldikss/vim-translator'				" Async language translator.
	Plug 'LucHermitte/local_vimrc' | Plug 'LucHermitte/lh-vim-lib' " Project local vim config.
	Plug 'danro/rename.vim'					" Provides the :Rename command
	Plug 'fidian/hexmode'					" Open binary files as a HEX dump with :Hexmode
	Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}	" Live preview markdown files in browser.
	Plug 'mbbill/undotree'					" Navigate history in a sidebar. Replaces old 'mbbill/undotree'
	Plug 'michaeljsmith/vim-indent-object'			" Operate on intendtation as text objects
	Plug 'ntpeters/vim-better-whitespace'			" Highlight and remove trailing whitespaces.
	Plug 'preservim/nerdcommenter'				" Comment source code.
	Plug 'svermeulen/vim-yoink'				" Yankring implementation.
	Plug 'tpope/vim-capslock'				" Software CAPSLOCK.
	Plug 'tpope/vim-fugitive'				" Git wrapper and shorthands.
	Plug 'tpope/vim-repeat'					" Extend '.' repetition for plugins like vim-surround, vim-speeddating.
	Plug 'tpope/vim-speeddating'				" Increment dates with C-a.
	Plug 'tpope/vim-surround'				" Work on surrond delimiters or its content.
	Plug 'tpope/vim-unimpaired'				" Bracket mappings like [<space>
	Plug 'tpope/vim-characterize'				" 'ga' on steroid.
" }

" Development {
" Development: General {
	Plug 'AndrewRadev/sideways.vim'			" Shift function arguments left and right.
	Plug 'airblade/vim-gitgutter'			" Git modified status in sign column
	Plug 'andymass/vim-matchup'			" Extend % matching. Replaces old the matchit plugin.
	Plug 'cohama/lexima.vim'			" Autmoatically close opened braces etc. Replaces old 'Townk/vim-autoclose'.
	Plug 'dense-analysis/ale'			" LSP linting engine.
	Plug 'editorconfig/editorconfig-vim'		" Standard .editorconfig file in shared projects.
	Plug 'godlygeek/tabular' | Plug 'preservim/vim-markdown' " Markdown utilties like list indention, TOC.
	Plug 'preservim/tagbar'				" Sidepane showing info from tags file.
	Plug 'rhysd/conflict-marker.vim'		" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
	Plug 'ruanyl/vim-gh-line'			" Copy lik to file on GitHub.
	Plug 'superDross/ticket.vim'			" Manage vim Sessions per git branch.
	Plug 'vim-scripts/argtextobj.vim'		" Make function arguments text objects that can be operated on with.
" }

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

" Snippets {
	" Snippet engine. Not very active. https://github.com/honza/vim-snippets list altenatives. neosnippet.vim seems nice, but require python provider.
	Plug 'garbas/vim-snipmate' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim'
	Plug 'honza/vim-snippets'				" Snippet library
	Plug 'rbonvall/snipmate-snippets-bib', { 'for': 'tex' }	" Bibtex snippets.
" }

" Navigation {
	" FZF - Fuzzy finding
	" - Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
	" - Commands: https://github.com/junegunn/fzf.vim#commands
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
" }

" Syntax {
	Plug 'bfontaine/Brewfile.vim', { 'for': 'brewfile' }		" Syntax for Brewfiles
	Plug 'kalekundert/vim-nestedtext', { 'for': 'nestedtext' }	" Syntax for NestedText .nt files.
" }

" UI {
	"Plug 'itchyny/lightline.vim'
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
" }

" Setup - end {
" Initialize plugin system
call plug#end()
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
" A stronger quit that unloads the buffer
command! Q bd

" Change to directory of current file.
command! Cdpwd cd %:p:h
command! Lcdpwd lcd %:p:h

command! -nargs=* Wrap set wrap linebreak nolist	" Set softwrap correctly.
autocmd BufWinLeave * silent! mkview			" Save fold views.
autocmd BufWinEnter * silent! loadview			" Load fold views on start.


" Disable all fixers. Good when editing non-owned code bases.
command! DisableFixers execute "DisableStripWhitespaceOnSave" | execute "let g:ale_fix_on_save = 0"


function! DebuggerClear()
	let current_buf = bufnr()
	silent :bufdo exe "g/^\\s*debugger\\s*$/d | update"
	execute 'buffer' current_buf
endfunction
command! DebuggerClear :call DebuggerClear()  " Clear all debugger statement lines in all open buffers.

" }

" Completion {
"set completeopt=longest,menu,preview	" Insert most common completion and show menu.
"set omnifunc=syntaxcomplete#Complete	" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
" }

" General {
set nrformats=alpha,octal,hex		" What to increment/decrement with ^A and ^X.
set tabpagemax=100			" Upper limit on number of tabs.
set hidden				" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables in sessions.
set sessionoptions-=folds		" Don't store folds in sessions.
set undofile				" Save undo to file in undodir.
set undolevels=2048			" Levels of undo to keep in memory.
set timeoutlen=500			" Timout (ms) for mappings and keycodes. Make it a bit snappier.
set nocompatible		" Be IMproved. Should be first.
set encoding=utf-8		" Use Unicode inside Vim's registers, viminfo, buffers ...
"filetype plugin indent on	" File type specific features. Already set as part of Vundle setup.
syntax enable			" Syntax highlighting but keep current colors.
"syntax on			" Use default colors for syntax highlighting.
set mouse=a			" Enable mouse in all modes.
set viewoptions=folds,cursor,slash,unix	" What to save with mkview.
set history=512			" Store much history.


"set complete-=k complete+=k		" Put the dictionaries in the normal completion set.
set shortmess=filmnrxtToA		" Abbreviate messages. 'A' disables the attention prompt when editing a file that is already open (beware: https://superuser.com/a/1065503)
set autoread				" Autoreload buffer from file if not changed in vim, e.g. with the :checktime command.
set modelines=5				" Number of lines from head of file to check for modelines. Setting this explicitly as on some syste*m (like macos in /usr/share/vim/vimrc) disables modelined by default. "
set ttyfast				" Smoother changes.
set clipboard+=unnamed			" Use register "* instead of unnamed register.
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
set matchpairs+=<:>		" Also match <> with %.
set formatoptions=tcroqwnl	" How automatic formatting should happen.
set cinoptions+=g=		" Left-indent C++ access labels.
"set pastetoggle  = <Leader>p   " Toggle 'paste' for sane pasting.
" }

" Mappings {
let mapleader = "\\"					" The key for <Leader>.
nmap <silent> <C-_> :nohlsearch<CR>			" Clear search matches highlighting. (Ctrl+/ => ^_). Note: neovim has <c-l> doing this be default now. https://neovim.io/doc/user/vim_diff.html#nvim-features-new
nmap <silent> <Leader>v :source $MYVIMRC<CR>		" Source init.vim
nmap <silent> <Leader>V :tabe $MYVIMRC<CR>		" Edit init.vim
noremap <silent> <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>	" Open tags definition in a new tab.
noremap <silent> <Leader>] :vsp<CR>:exec("tag ".expand("<cword>"))<CR>		" Open tags definition in a vertical split.
nnoremap g^t :tabfirst<CR>				" Go to first tab.
nnoremap g$t :tablast<CR>				" Go to last tab.
noremap Yf :let @" = expand("%")<CR>			" Yank current file name.
noremap YF :let @" = expand("%:p")<CR>			" Yank current (fully expanded) file name.
nnoremap <silent> <Leader>R :checktime<CR>		" Reload buffers from file if changed.
"nmap <silent> <Leader>d "=strftime("%Y-%m-%d")<CR>P	" Insert the current date.
"nmap <silent> <Leader>S :%s/\s\+$//ge<CR>		" Remove all trailing spaces.

nnoremap <silent> gfs :wincmd f<CR>			" Open path under cursor in a split.
nnoremap <silent> gfv :vertical wincmd f<CR>		" Open path under cursor in a vertical split.
nnoremap <silent> gft :tab wincmd f<CR>			" Open path under cursor in a tab.
nnoremap <silent> gV `[v`]				" Visually select the text that was last edited/pasted.

" Save (force) current session.
"nnoremap <silent> <C-S> :mksession! <bar> echo "Session saved"<CR>
"nnoremap <silent> <Leader>s :mksession! <bar> echo "Session saved"<CR>
" Load saved session
"nnoremap <silent> <C-O> :source Session.vim <bar> echo "Session loaded"<CR>
"nnoremap <silent> <Leader>o :source Session.vim <bar> echo "Session loaded"<CR>

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

" TabWinAdjustSplit() {
function! TabWinAdjustSplit()
	let current_tab = tabpagenr()
	tabdo wincmd =
	execute 'tabnext' current_tab
endfunction
" }
nnoremap <silent> <leader>= :call TabWinAdjustSplit()<cr>	" Ctrl+w+= in all tabs: adjust window splits equally in all tabs

" Toggles {
noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>		" Toggle line wrapping.
noremap <silent> <Leader>` :set list!<CR>			" Toggle listing of characters. See listchars.
noremap <Leader>l :set relativenumber!<CR>			" Toggle :number between absolute and line relative.
noremap <silent> <ESC>p :set paste! paste?<CR>			" Toggle 'paste' for sane pasting.
noremap <silent> <leader>p :set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>	" Paste on line after in paste-mode from register "*.
noremap <silent> <leader>P :set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>	" Paste on line before in paste-mode from register "*.

" Toggle spell with a language. {
" Set 'spellang' last, otherwise vim (but not nvim) complains that ~/.vim/spell dont' exist.
function! ToggleSpell(lang)
	if !exists("b:old_spelllang")
		let b:old_spellfile = &spellfile
		let b:old_dictionary = &dictionary
		let b:old_thesaurus = &thesaurus
		let b:old_spelllang = &spelllang
	endif

	let l:newMode = ""
	if !&l:spell || a:lang != &l:spelllang
		setlocal spell
		let l:newMode = "spell, " . a:lang
		execute "setlocal spellfile=" . g:xdg_config_home . "/nvim/spell/" . matchstr(a:lang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
		execute "setlocal dictionary=" . g:xdg_config_home ."/nvim/spell/" . a:lang . "." . &encoding . ".dic"
		execute "setlocal thesaurus=" . g:xdg_config_home . "/nvim/thesaurus/" . a:lang . ".txt"
		execute "setlocal spelllang=" . a:lang
	else
		setlocal nospell
		let l:newMode = "nospell"
		execute "setlocal spellfile=" . b:old_spellfile
		execute "setlocal dictionary=" . b:old_dictionary
		execute "setlocal thesaurus=" . b:old_thesaurus
		execute "setlocal spelllang=" . b:old_spelllang
	endif
	return l:newMode
endfunction
" }
nmap <silent> <F6> :echo ToggleSpell("en_us")<CR>	" Toggle English spell.
nmap <silent> <F7> :echo ToggleSpell("sv")<CR>		" Toggle Swedish spell.
nmap <silent> <F8> :echo ToggleSpell("de")<CR>		" Toggle German spell.

" Toggle mouse {
"function! ToggleMouse()
	"if &mouse == "a"
		"set mouse=
	"else
		"set mouse=a
	"endif
	"set mouse?
"endfunction
" }
"nmap <Leader>m :call ToggleMouse()<CR>	" Toggles mouse on and off.

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
set ignorecase	" Case insensitive search.
set smartcase	" Smart case search.
set nowrapscan	" Don't wrap search around file.
set hlsearch	" Highlight search.
set incsearch	" Incremental search.
" }

" Spelling {
"set spell			" Enable spell highlighting and suggestions.
set spelllang=en_us		" Languages to do spell checking for.
set spellsuggest=best,10	" Limit spell suggestions.
" Set spellfile dynamically.
execute "set spellfile=" . g:xdg_config_home ."/nvim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
execute "set thesaurus=" . g:xdg_config_home . "/nvim/thesaurus/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . ".txt"
set dictionary+=~/.vim/spell/		" Use custom dictionaries.
"set dictionary+=/usr/share/dict/words	" Use system dictionary.
" }

" UI {
" Ignore if don't exist. This is the case when $(vim -c PlugInstall) the firs time. Ref: https://stackoverflow.com/a/5703164/265508
silent! colorscheme NeoSolarized

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

set t_Co=256		" Set number of colors.
"hi Normal ctermbg=NONE	" Transparent background.
set title		" Show title in console title bar.

set termguicolors	" Enable 24-bit RGB. Required by NeoSolarized.
set mouse=a		" Enable mouse in all modes.
set title		" Show title in console title bar.
set number		" Show line numbers.
set relativenumber	" Show relative line numbers.
set showmatch		" Shortly jump to a matching bracket when match.
set cursorline		" Highlight the current line.
set wildignorecase	" Case insensitive filename completion.
set scrolljump=5	" Lines to scroll when cursor leaves screen.
set scrolloff=3		" Minimum lines to keep above and below cursor.
set splitbelow		" Open horizontal split below.
set splitright		" Open vertical split to the right.
set listchars=eol:$,space:·,tab:>-,trail:¬,extends:>,precedes:<,nbsp:.	" Characters to use for :list.
"set cursorcolumn	" Highlight the current column.
" Colors of the CursorLine.
"hi CursorLine cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
"hi CursorColumn cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
set showmode				" Show current mode in the last line.
set backspace=indent,eol,start		" Make backspace work like expected.
set linespace=0				" No line spacing.
set wildmode=full			" Full completion.
set foldenable				" Use folding.
set showcmd				" Show incomplete commands in the lower right corner.
set ruler				" Show current cursor position in the lower right corner.
set laststatus=2			" Always show the status line.
set nolist				" Don't show unprintable characters.

" UI: Statusline {
" Comment these out when using powerline statusbar.
set statusline=%t		" Tail of the filename.
set statusline+=%m		" Modified flag.
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},	" File encoding.
set statusline+=%{&ff}]		" File format.
set statusline+=%h		" Help file flag.
set statusline+=%r		" Read only flag.
set statusline+=%y		" Filetype.
"set statusline+=['%{getline('.')[col('.')-1]}'\ \%b\ 0x%B]	" Value of byte under cursor.

" vim-fugitive:
set statusline+=%#StatusLineNC#			" Change highlight group
set statusline+=%{fugitive#statusline()}	" Show current branch.
set statusline+=%*
set statusline+=%{tagbar#currenttag('[#%s]','')}	" Current tag.

set statusline+=%=		" Left/right-aligned separator.
"set statusline+=[\%b\ 0x%B]\	" Value of byte under cursor.
"set statusline+=[0x%O]\	" Byte offset from start.
set statusline+=%l/%L,		" Cursor line/total lines.
set statusline+=%c		" Cursor column.
set statusline+=\ %P		" Percent through file.
set statusline+=\ 0x%B		" Character value under cursor.
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
		\ 'javascript': ['eslint'],
		\ 'json': ['jsonls'],
		\ 'python': ['pyright', 'flake8'],
		\ 'ruby': ['solargraph', 'ruby'],
		\ 'sh': ['language_server'],
		\ 'vim': ['vimls'],
		\ }
" }

" Fixing {
" * - disabled 'trim_whitespace' and 'remove_trailing_lines' as it overlaps with the functionally already provided by vim-better-whitespace.
" python - disabled autoimport as it messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59
let g:ale_fixers = {
	\ '*': ['prettier'],
	\ 'javascript': ['eslint'],
	\ 'ruby': ['rubocop'],
	\ 'python': ['autoflake', 'black', 'isort'],
	\}
let g:ale_fix_on_save = 1
" }

" Completion {
let g:ale_completion_autoimport = 1
" Trigger on ^x^o
set omnifunc=ale#completion#OmniFunc
" 'longest' seems to tirgger a variation of :h ale-completion-completeopt-bug
" See https://github.com/dense-analysis/ale/issues/1700#issuecomment-991643960
set completeopt=menu,preview
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

" Toggle command for fixers
" Reference: https://github.com/dense-analysis/ale/issues/1353#issuecomment-424677810
command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"
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
nnoremap <Leader>f :FZF<space>
" Search for files starting at current directory.
" Sublime-like shortcut 'go to file' ctrl+p.
" Disabled here; see vim-yoink section for a re-mapping for :Files
"nnoremap <C-p> :Files<CR>
" Search for files starting at current directory.
" Sublime-like shortcut 'go to file' ctrl+shift+p. Note: <C-S-p> is not mappable in vim. <M-P> is in neovim but not vim.
nnoremap <leader>c :Commands<CR>
" Search in tags file.
nnoremap <Leader>T :Tags<CR>
" Search open buffers.
" ; conflicts with repeating search for characther (fF]
"nnoremap ; :Buffers<CR>
"nnoremap <leader>; :Buffers<CR>
nnoremap <Leader>b :Buffers<CR>
" Search open tabs (indirectly; " https://medium.com/@paulodiovani/vim-buffers-windows-and-tabs-an-overview-8e2a57c57afa).
nnoremap <Leader>t :Windows<CR>
" Search history of opended files
nnoremap <Leader>H :History<CR>
" Search mappings.
nnoremap <Leader>m :Maps<CR>
" Search with rg (aka live grep).
nnoremap <Leader>g :Rg<CR>

" To ignore a certain path in a git project from both RG and FD used by FZF,
" the eaiest way is to create ignore files and exclude the in local git clone.
" Ref: https://stackoverflow.com/a/1753078/265508
" $ cd git_proj/
" $ echo "path/to/exclude" > .rgignore
" $ echo "path/to/exclude" > .fdignore
" $ printf ".rgignore\n.fdignore" >> .git/info/exclude
" }

" local_vimrc {
" File names to recognize.
let g:local_vimrc = ['.vimlocal', '_vimrc_local.vim']
" Paths to not ask before loading.
if exists("lh#local_vimrc")
	call lh#local_vimrc#munge('whitelist', $HOME.'/src/github.com/erikw')
end
" }

" lexima.vim {
" Don't auto-close quotes at "word" (more like non-whitespaces places )boundaries. Reference: https://github.com/cohama/lexima.vim/issues/129
if exists("lexima#add_rule")
	call lexima#add_rule({'char': '"', 'at': '\%#\S\|\S\%#'})
	call lexima#add_rule({'char': "'", 'at': '\%#\S\|\S\%#'})
	call lexima#add_rule({'char': "[", 'at': '\%#\S\|\S\%#'})  " for []() url syntax around word.
endif
" }

" nerdcommenter {
" Swap invert comment toggle.
	"map <silent> <Leader>c<Space> <plug>NERDCommenterInvert
	"map <silent> <Leader>ci <plug>NERDCommenterToggle

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" }

" netrw {
" Ships by default with vim mostly.
" Reference: https://shapeshed.com/vim-netrw/
" Reference: " http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
" Keyboard shortcuts: https://gist.github.com/t-mart/610795fcf7998559ea80
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

" tagbar {
nmap <silent> <F3> :TagbarToggle<CR>	" Toggle the Tagbar window.
let g:tagbar_left = 0			" Keep the window on the right side.
let g:tagbar_width = 50			" Width of window.
let g:tagbar_autoclose = 1		" Close tagbar when jumping to a tag.
let g:tagbar_autofocus = 1		" Give tagbar focus when it's opened.
let g:tagbar_sort = 0			" Sort tags alphabetically.
let g:tagbar_compact = 1		" Omit the help text.
let g:tagbar_singleclick = 1		" Jump to tag with a single click.
let g:tagbar_autoshowtag = 1		" Open folds if tag is not visible.
" }

" tickets.vim {
" Alternatives that also support per-branch saving to some extent:
" * https://piet.me/branch-based-sessions-in-vim/
" * https://github.com/dhruvasagar/vim-prosession
" * https://github.com/wting/gitsessions.vim
" * https://github.com/rmagatti/auto-session

let g:auto_ticket = 0  " Automatically load tickets when starting vim without file arguments.

 " Save current session.
nnoremap <silent> <C-M-s> :execute ':SaveSession' <bar> echo "Session saved"<CR>
nnoremap <silent> <C-M-o> :execute ':OpenSession' <bar> echo "Session loaded"<CR>
" }

" sideways.vim {
nnoremap <silent> <a :SidewaysLeft<CR>		" Move function argument to the left.
nnoremap <silent> >a :SidewaysRight<CR>		" Move function argument to the right.
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
let g:instant_markdown_autostart=1

" Blocklist certain paths for previewing files (recursively).
" See https://github.com/instant-markdown/vim-instant-markdown/issues/198
" Did not work to put this in .vimlocal file, as it's loaded too late.
augroup InstantMarkdownGroup
  autocmd!
  " [1-9]*.md - PR body by gh(1) have file names with this pattern.
  au! BufReadPre,BufNewFile,BufEnter,BufFilePre ~/src/github.com/erikw/hackerrank-solutions/*.md,~/src/github.com/erikw/leetcode-solutions/*.md,[1-9]*.md let g:instant_markdown_autostart=0
augroup END
" }

" vim-markdown {
let g:vim_markdown_folding_disabled = 1		" No fold by default
let g:vim_markdown_toc_autofit = 1		" Make :Toc smaller
let g:vim_markdown_follow_anchor = 1		" Let ge follow #anchors
let g:vim_markdown_new_list_item_indent = 2	" Bullent space indents.
" }

" vim-snipmate {
let g:snipMate = { 'snippet_version' : 1 }	" Use the new parser (and surpress message about using the old parser).
let g:snipMate.always_choose_first = 1		" Make it easy to override snippet from ~/.local/share/nvim/plugged/vim-snippets/snippets/ in ~/.config/nvim/snippets/

" }

" vim-startify {
" Bookmarks
let g:startify_bookmarks = [
	\ {'v': '$HOME/.vimrc'},
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

" vim-yoink {
let g:yoinkMaxItems=16			" Increase from default 10.
let g:yoinkSyncNumberedRegisters=1	" Repurpose the registers to be a history stack!
let g:yoinkIncludeDeleteOperations=1	" Include text delete operations in the yank history.
let g:yoinkSyncSystemClipboardOnFocus=0	" Don't integrate with system clipboard.

if has("nvim")
	let g:yoinkSavePersistently=1		" Persist history across sessions.
endif


" Replace default paste with Yoink. "xp still works
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" Also replace the default gp with yoink paste so we can toggle paste in this case too
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)

" Cycle yankring immediately after pasting.
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
"nmap <c-p> <plug>(YoinkPostPasteSwapForward)
" Let c-p execute fzf if we're not in paste mode.
nmap <expr> <c-p> yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : ':Files<CR>'

" Toggle formatted paste.
"nmap <c-=> <plug>(YoinkPostPasteToggleFormat)
" }

" undotree {
nmap <silent> <F4> :UndotreeToggle<CR>	" Toggle side pane.
let g:undotree_WindowLayout=2		" Set style to have diff window below.
let g:undotree_SetFocusWhenToggle=1	" Put cursor in undo window on open.
" }
" }

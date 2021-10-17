" Erik Westrup's Neovim configuration.
" Modeline {
"	vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=4 :
" }

" Profiling {
" $ nvim --startuptime /tmp/nvim.log
" $ nvim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" TODO migrate Vundle plugins from .vimrc
" TODO fix indentation of comments to be consistent in this file.
" TODO order sections alphabetically?
" TODO check all TODOs in .vimrc too

" Plugins {
" vim-plug data folder
call plug#begin(stdpath('data') . '/plugged')
" General {
		"Plugin 'godlygeek/tabular'		" Create tables. Disabled: not used and have some startup time.
		"Plugin 'scrooloose/nerdtree'		" Replaced by built-in netrw
		"Plugin 'sjl/gundo.vim'			" Use 'mbbill/undotree' instead; is better: https://vi.stackexchange.com/a/13863
		Plug 'erikw/vim-unimpaired'
" }

" UI {
	"Plug 'vim-scripts/ScrollColors'
	Plug 'overcache/NeoSolarized'
	Plug 'mkitt/tabline.vim'	" More informative tabs. Only for terminal; gvim uses guilabel setting.
"}

" Navigation {
	"Plugin 'wincent/command-t' TODO replace this with fzf!
" }

" mutt {
	"Plugin 'vim-scripts/lbdbq' 	" Query lbdb for recipinents.
"}

" Development: General {
	"Plug 'dense-analysis/ale' TODO not needed, as Neovim has built-in LSP support?
	Plug 'Townk/vim-autoclose'			" Automatically insert matching brace pairs.
	Plug 'airblade/vim-gitgutter'		" Git modified status in sign column
	Plug 'andymass/vim-matchup'			" Extend % matching. Replaces old the matchit plugin.
	Plug 'editorconfig/editorconfig-vim'	" Standard .editorconfig file in shared projects.
	Plug 'preservim/tagbar'				" Sidepane showing info from tags file. 
	Plug 'rhysd/conflict-marker.vim' 	" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
	Plug 'vim-scripts/argtextobj.vim'	" Make function arguments objects that can be operated on with.
" }

" Development: C/C++ {
	"Plug 'Rip-Rip/clang_complete'
	"Plug 'chazy/cscope_maps'	" More macros than autoload_cscope.vom
	"Plug 'rhysd/vim-clang-format'
	Plug 'vim-scripts/autoload_cscope.vim'	" Load cscope file and define macros for using it. https://github.com/vim-scripts/autoload_cscope.vim/blob/master/plugin/autoload_cscope.vim#L81-L88
	Plug 'craigemery/vim-autotag'	" Autogenerate new tags file.
"}

" Development: Java {
	"Plugin 'artur-shaik/vim-javacomplete2'		" Omni-complete for Java
	"Plugin 'erikw/jcommenter.vim' " Generate javadoc.
"}

" Development: Go {
	"Plug 'fatih/vim-go'	" Compilation commands etc.
"}

" Development: Python {
	"Plugin 'davidhalter/jedi-vim'	" Autocompletion using jedi library.
	"Plugin 'python-rope/ropevim'	" Refactoring with rope library.
	"Plugin 'fisadev/vim-isort'		" Sort imports
"}

" Development: Swift {
	"Plugin 'keith/swift.vim'	" Syntax files for Switch
"}


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
set shortmess=filmnrxtToO    			" Abbreviate messages.
set nrformats=alpha,bin,octal,hex			" What to increment/decrement with ^A and ^X.
set hidden						" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables when saving sessions.
set undolevels=2048				" Levels of undo to keep in memory.
"set clipboard+=unnamed				" Use register "* instead of unnamed register. This means what is being yanked in vim gets put to external clipboard automatically.
set timeoutlen=1500				" Timout (ms) for mappings and keycodes.

" TODO break out to Completion section?
set completeopt=longest,menu,preview		" Insert most common completion and show menu.
set omnifunc=syntaxcomplete#Complete		" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
" TODO ALE not needed as neovim has native LSP? https://neovim.io/doc/lsp/
"set omnifunc=ale#completion#OmniFunc		" Use ALE for omnicompletion
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
set mouse=a					" Enable mouse in all modes.
set title			" Show title in console title bar.
set number						" Show line numbers.
set showmatch						" Shortly jump to a matching bracket when match.
set cursorline						" Highlight the current line.
"set cursorcolumn					" Highlight the current column.
set wildignorecase					" Case insensitive filename completion.
set scrolljump=5 					" Lines to scroll when cursor leaves screen.
set scrolloff=3 					" Minimum lines to keep above and below cursor.  set splitbelow						" Open horizontal split below.
set splitbelow						" Open horizontal split below.
set splitright						" Open vertical split to the right.
set listchars=eol:$,space:·,tab:>-,trail:¬,extends:>,precedes:<,nbsp:. 	" Characters to use for :list.

" Statusline {
" Comment these out when using powerline statusbar.
set statusline=%t       				" Tail of the filename.
set statusline+=%m     					" Modified flag.
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},	" File encoding.
set statusline+=%{&ff}]					" File format.
set statusline+=%h     					" Help file flag.
set statusline+=%r     					" Read only flag.
set statusline+=%y     					" Filetype.
"set statusline+=['%{getline('.')[col('.')-1]}'\ \%b\ 0x%B] 	" Value of byte under cursor.

" TODO enable when fugitive is installed. Or use gitgutter below?
"set statusline+=%#StatusLineNC#				" Change highlight group
"set statusline+=%{fugitive#statusline()}		" Show current branch.
"set statusline+=%*
"set statusline+=%{tagbar#currenttag('[#%s]','')}	" Current tag.

" vim-gitgutter
"function! GitStatus()
"	let [a,m,r] = GitGutterGetHunkSummary()
"	return printf('+%d ~%d -%d', a, m, r)
"endfunction
"set statusline+=\ [%{GitStatus()}]


set statusline+=%=     					" Left/right-aligned separator.
"set statusline+=[\%b\ 0x%B]\  				" Value of byte under cursor.
"set statusline+=[0x%O]\ 				" Byte offset from start.
set statusline+=%l/%L, 					" Cursor line/total lines.
set statusline+=%c    					" Cursor column.
set statusline+=\ %P   					" Percent through file.
set statusline+=\ 0x%B					" Character value under cursor.
" }
" }

" Spelling {
set spelllang=en_us				" Languages to do spell checking for.
set spellsuggest=best,10			" Limit spell suggestions.
" Set spellfile dynamically. Shared with Vim.
execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"

" TODO make this depend on 'spellang' if I can get files for Swedish and German.
set thesaurus+=~/.vim/thesaurus/mthesaur.txt    " Use a thesaurus file.
" }

" Searching {
	set ignorecase		" Case insensitive search.
	set smartcase		" Smart case search.
	set nowrapscan		" Don't wrap search around file.
" }

" Formatting {
set linebreak			" Wrap on 'breakat'-chars.
"set showbreak=>		" Indicate wrapped lines.
set showbreak=…			" Indicate wrapped lines.
set smartindent			" Indent smart on C-like files.
set preserveindent		" Try to preserve indent structure on changes of current line.
set copyindent			" Copy indentstructure from existing lines.
set tabstop=4			" Let a tab be 8 spaces wide.
set shiftwidth=4		" Tab width for auto indent and >> shifting.
"set softtabstop=4		" Number of spaces to count a tab for on ops like BS and tab.
set matchpairs+=<:>		" Also match <> with %.
set formatoptions=tcroqwnl	" How automatic formatting should happen.
set cinoptions+=g=		" Left-indent C++ access labels.
"set pastetoggle  = <Leader>p    " Toggle 'paste' for sane pasting.
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
autocmd BufWinLeave * silent! mkview				" Save fold views.
autocmd BufWinEnter * silent! loadview				" Load fold views on start.
" }

" Mappings {
let mapleader = "\\"								" The key for <Leader>.
nmap <silent> <C-_> :nohlsearch<CR>						" Clear search matches highlighting. (Ctrl+/ => ^_)
nmap <silent> <Leader>v :source $MYVIMRC<CR>			" Source init.vim
nmap <silent> <Leader>V :tabe $MYVIMRC<CR>				" Edit init.vim
noremap <silent> <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>		" Open tags definition in a new tab.
noremap <silent> <Leader>] :vsp<CR>:exec("tag ".expand("<cword>"))<CR>      		" Open tags definition in a vertical split.
nnoremap g^t :tabfirst<CR>							" Go to first tab.
nnoremap g$t :tablast<CR>							" Go to last tab.
noremap Yf :let @" = expand("%")<CR>						" Yank current file name.
noremap YF :let @" = expand("%:p")<CR>						" Yank current (fully expanded) file name.
nnoremap <silent> <Leader>R :checktime<CR>						" Reload buffers from file if changed.
"nmap <silent> <Leader>d "=strftime("%Y-%m-%d")<CR>P 				" Insert the current date.
"nmap <silent> <Leader>S :%s/\s\+$//ge<CR>					" Remove all trailing spaces.

nnoremap <silent> gfs :wincmd f<CR>						" Open path under cursor in a split.
nnoremap <silent> gfv :vertical wincmd f<CR>					" Open path under cursor in a vertical split.
nnoremap <silent> gft :tab wincmd f<CR>						" Open path under cursor in a tab.
nnoremap <silent> gV `[v`]							" Visually select the text that was last edited/pasted.

" Redraw window so that search terms are centered.
nnoremap n nzz
nnoremap N Nzz

" Calculate current Word e.g. type 1+2 and press ^c.
inoremap <C-c> <C-O>yiW<End>=<C-R>=<C-R>0<CR>=

" Enable ^d and ^u movement in completion dialog.
inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

if &l:term  =~ "screen.*"
	noremap <silent> <C-x>x <C-x>						" Decrement for consistency with GNU Screen.
endif

" Toggles {
noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>				" Toggle line wrapping.
noremap <silent> <Leader>` :set list!<CR>					" Toggle listing of characters. See listchars.
noremap <Leader>l :set relativenumber!<CR>					" Toggle :number between absolute and line relative.
noremap <silent> <ESC>p :set paste! paste?<CR>					" Toggle 'paste' for sane pasting.
noremap <silent> <leader>p :set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>	" Paste on line after in paste-mode from register "*.
noremap <silent> <leader>P :set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>	" Paste on line before in paste-mode from register "*.

" Toggle spell with a language. {
function! ToggleSpell(lang)
	if !exists("b:old_spelllang")
		let b:old_spelllang = &spelllang
		let b:old_spellfile = &spellfile
		let b:old_dictionary = &dictionary
	endif

	let l:newMode = ""
	if !&l:spell || a:lang != &l:spelllang
		setlocal spell
		let l:newMode = "spell, " . a:lang
		execute "setlocal spelllang=" . a:lang
		execute "setlocal spellfile=" . "~/.vim/spell/" . matchstr(a:lang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
		execute "setlocal dictionary=" . "~/.vim/spell/" . a:lang . "." . &encoding . ".dic"
	else
		setlocal nospell
		let l:newMode = "nospell"
		execute "setlocal spelllang=" . b:old_spelllang
		execute "setlocal spellfile=" . b:old_spellfile
		execute "setlocal dictionary=" . b:old_dictionary
	endif
	return l:newMode
endfunction
" }
nmap <silent> <F6> :echo ToggleSpell("en_us")<CR>			" Toggle English spell.
nmap <silent> <F7> :echo ToggleSpell("sv")<CR>				" Toggle Swedish spell.
nmap <silent> <F8> :echo ToggleSpell("de")<CR>				" Toggle German spell.

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
nmap <Leader>m :call ToggleMouse()<CR>					" Toggles mouse on and off.
" }

" Cmaps {
" Prevent saving buffer to a file '\'.
cmap w\ echoerr "Using a Swedish keyboard?"<CR>
" }
" }

" Abbreviations {
" Expand my name.
"iabbrev ew Erik Westrup
" }

" Plugin Config {
" tagbar {
nmap <silent> <F3> :TagbarToggle<CR>		" Toggle the Tagbar window.
let g:tagbar_left		= 0		" Keep the window on the right side.
let g:tagbar_width		= 30		" Width of window.
let g:tagbar_autoclose		= 1		" Close tagbar when jumping to a tag.
let g:tagbar_autofocus		= 1		" Give tagbar focus when it's opened.
let g:tagbar_sort		= 1		" Sort tags alphabetically.
let g:tagbar_compact		= 1		" Omit the help text.
let g:tagbar_singleclick	= 1 		" Jump to tag with a single click.
let g:tagbar_autoshowtag	= 1		" Open folds if tag is not visible.
" }

" vim-autoclose {
let g:AutoClosePairs = "() [] {} <> «» ` \" '"	" Pairs to auto-close.
"let g:AutoCloseProtectedRegions = ["Comment", "String", "Character"]	" Syntax regions to ignore.

noremap <silent> <Leader>ac :AutoCloseToggle<CR>				" Toggle vim-autoclose plugin mode.

" }

" vim-gitgutter {
set updatetime=100		" Speedier update of file status.

" }

" }

" Erik Westrup's Vim configuration.
" Modeline {
"	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=8:
" }

" Vundle {
	let s:using_vundle = 1		" Vundle will break default behaviour of spellfile. Let others know when using Vundle.

	set nocompatible              " be iMproved, required
	filetype off                  " required

	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'


	" Formats {
	" Git:
		"Plugin 'git://git.domain.com/project.git'
	" Github:
		"Plugin 'username/project.vim'
	" vim-scripts.org (https://github.com/vim-scripts/):
		"Plugin 'ProjectName'
	" }

	" UI {
		Plugin 'ScrollColors'
		Plugin 'altercation/vim-colors-solarized'
		Plugin 'flazz/vim-colorschemes'
	"}
	" Navigation {
		Plugin 'FuzzyFinder'
		Plugin 'L9'			" Required for FuzzyFinder.
		Plugin 'wincent/command-t'
	"}
	" Development: General {
		"Plugin 'AndrewRadev/sideways.vim'
		Plugin 'ConflictMotions'
		Plugin 'tmhedberg/matchit'
		Plugin 'majutsushi/tagbar'
		Plugin 'ingo-library'		" Required for ConflictMotions.
		Plugin 'CountJump'             	" Required for ConflictMotions.
		Plugin 'Townk/vim-autoclose'
		Plugin 'airblade/vim-gitgutter'
		Plugin 'argtextobj.vim'
		Plugin 'editorconfig/editorconfig-vim'
	"}
	" Development: C/C++ {
		"Plugin 'Rip-Rip/clang_complete'
		"Plugin 'rhysd/vim-clang-format'
		Plugin 'autoload_cscope.vim'
		Plugin 'chazy/cscope_maps'
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
	" mutt {
		Plugin 'lbdbq'
	"}
	" General {
		"Plugin 'git://git.wincent.com/command-t.git'
		"Plugin 'tpope/vim-unimpaired'
		"Plugin 'easymotion/vim-easymotion'
		"Plugin 'terryma/vim-multiple-cursors'
		"Plugin 'sjl/gundo.vim' " Not updated for python3
		Plugin 'LaTeX-Box-Team/LaTeX-Box'
		Plugin 'buffergrep'
		Plugin 'danro/rename.vim'
		Plugin 'dhruvasagar/vim-table-mode'
		Plugin 'erikw/snipmate-snippets'
		Plugin 'tomtom/tlib_vim'	" Required for garbas/vim-snipmate
		Plugin 'erikw/vim-unimpaired'
		Plugin 'fatih/vim-go'
		Plugin 'fidian/hexmode'
		Plugin 'garbas/vim-snipmate'
		Plugin 'MarcWeber/vim-addon-mw-utils' " Required for  garbas/vim-snipmate.
		Plugin 'godlygeek/tabular'
		Plugin 'mattn/gist-vim'
		Plugin 'michaeljsmith/vim-indent-object'
		Plugin 'ntpeters/vim-better-whitespace'
		Plugin 'rbonvall/snipmate-snippets-bib'
		Plugin 'salsifis/vim-transpose'
		Plugin 'scrooloose/nerdcommenter'
		Plugin 'scrooloose/nerdtree'
		Plugin 'scrooloose/syntastic'
		Plugin 'suan/vim-instant-markdown'
		Plugin 'tmux-plugins/vim-tmux'
		Plugin 'tpope/vim-capslock'
		Plugin 'tpope/vim-fugitive'
		Plugin 'tpope/vim-markdown.git'
		Plugin 'tpope/vim-repeat'
		Plugin 'tpope/vim-speeddating'
		Plugin 'tpope/vim-surround'
	"}

	call vundle#end()            " required
	filetype plugin indent on    " required
" }

" Environment {
	if v:version < 703
		echoerr 'WARNING: This vimrc is written for Vim >= v.703; this is' v:version
	endif
	let s:use_plugins=1				" Enable plugin references in this rc.
	set nocompatible				" Be IMproved. Should be first.
	set viminfo+=n~/.vim/viminfo			" Write the viminfo file inside the Vim directory.
	set undodir=~/.vim/undo/			" Collect history instead of having them in '.'.
	set tags+=./tags;/				" Look for tags in current directory or search up until found.
	set encoding=utf-8				" Use Unicode inside Vim's registers, viminfo, buffers ...

	" Also use $HOME/.vim in Windows
	if has('win32') || has('win64')
		set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	endif
" }

" General {
	filetype plugin indent on			" File type specific features.
	syntax enable					" Syntax highlighting but keep current colors.
	"syntax on					" Use default colors for syntax highlighting.
	set mouse=a					" Enable mouse in all modes.
	set viewoptions=folds,cursor,slash,unix		" What to save with mkview.
	set history=512					" Store much history.
	"set spell					" Enable spell highlighting and suggestions.
	set spellsuggest=best,10			" Limit spell suggestions.
	set spelllang=en_us				" Languages to do spell checking for.
	if exists("s:using_vundle")
		" Set spellfile dynamically.
		execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
	endif
	set dictionary+=~/.vim/spell/			" Use custom dictionaries.
	"set dictionary+=/usr/share/dict/words		" Use system dictionary.
	set thesaurus+=~/.vim/thesaurus/mthesaur.txt    " Use a thesaurus file.
	"set complete-=k complete+=k			" Put the dictionaries in the normal completion set.
	set completeopt=longest,menu,preview		" Insert most common completion and show menu.
	set omnifunc=syntaxcomplete#Complete		" Omni completion.
	set shortmess=filmnrxtToOI    			" Abbreviate messages.
	set nrformats=alpha,octal,hex			" What to increment/decrement with ^A and ^X.
	set hidden					" Work with hidden buffers more easily.
	set autoread					" Autoreload buffer from file if not changed in vim, e.g. with the :checktime command.
	set sessionoptions-=options			" Don't store global and local variables when saving sessions.
	set undofile					" Save undo to file in undodir.
	set undolevels=2048				" Levels of undo to keep in memory.history.
	"set nomodeline					" Turn off possibly malicious Ex command execution.
	set ttyfast					" Smoother changes.
	set clipboard+=unnamed				" Use register "* instead of unnamed register.
	set timeoutlen=1500				" Timout (ms) for mappings and keycodes.
	if !has('gui_running')
		if !has('win32') && !has('win64')
			set term=$TERM       		" Make arrow and other keys work.
		endif
		if &l:term  =~ "screen.*"
			set ttymouse=xterm2		" Needed for mouse support inside GNU Screen.
		endif
	endif
	if has("unix")
		let s:uname = system("uname -s")
		if s:uname == "Darwin"
			set clipboard=unnamed		" Make copy to clipboard work under macOS.
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
			""set termencoding=latin1 	" This will make Meta key work if meta8 is enabled.
		"end
	" }
" }

" UI {
	if s:use_plugins
		"let g:solarized_termtrans=1			" Fix bacground problem in gnome-terminal.
		"let g:solarized_termcolors=16 			" Colors to use in solarized.
		colorscheme solarized				" Use the solarized colorscheme.
	else
		colorscheme default				" Use default color scheme.
	endif

	"set t_Co=16						" Set number of colors.
	set t_Co=256						" Set number of colors.
	"hi Normal ctermbg=NONE                                 " Transparent background.
	set title						" Show title in console title bar.
	" Adjust colors to this background.
	if has('gui_running')
		set background=light
	elseif filereadable(expand("~/.solarizedtoggle/status"))
		let &background = readfile(expand("~/.solarizedtoggle/status"), '', 1)[0]
	else
		"set background=dark
		" Lighter bg during night.
		" Source:  http://benjamintan.io/blog/2014/04/10/switch-solarized-light-slash-dark-depending-on-the-time-of-day/
		let s:hour = strftime("%H")
		if 7 <= s:hour && s:hour < 18
			set background=dark
		else
			set background=light
		endif
	endif
	set number						" Show line numbers.
	set tabpagemax=64					" Upper limit on number of tabs.
	set showmode						" Show current mode in the last line.
	set backspace=indent,eol,start				" Make backspace work like expected.
	set linespace=0						" No line spacing.
	set showmatch						" Shortly jump to a matching bracket when match.
	set wildmenu						" Enable tab-completion menu.
	set wildmode=full					" Full completion.
	set wildignorecase					" Case insensitive filename completion.
	set scrolljump=5 					" Lines to scroll when cursor leaves screen.
	set scrolloff=3 					" Minimum lines to keep above and below cursor.
	set splitbelow						" Open horizontal split below.
	set splitright						" Open vertical split to the right.
	set foldenable						" Use folding.
	set showcmd						" Show incomplete commands in the lower right corner.
	set ruler						" Show current cursor position in the lower right corner.
	set laststatus=2					" Always show the status line.
	set nolist						" Don't show unprintable characters.
	set listchars=eol:$,tab:>-,trail:¬,extends:>,precedes:<,nbsp:. 	" Characters to use for list.
	set cursorline						" Highlight the current line.
	"set cursorcolumn					" Highlight the current column.
	" Colors of the \cancel{hardstyle} CursorLine.
	"hi CursorLine cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
	"hi CursorColumn cterm=NONE ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black

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
		if s:use_plugins
			set statusline+=%#StatusLineNC#				" Change highlight group
			set statusline+=%{fugitive#statusline()}		" Show current branch.
			set statusline+=%*
			set statusline+=%{tagbar#currenttag('[#%s]','')}	" Current tag.
		endif
		set statusline+=%=     					" Left/right-aligned separator.
		"set statusline+=[\%b\ 0x%B]\  				" Value of byte under cursor.
		"set statusline+=[0x%O]\ 				" Byte offset from start.
		set statusline+=%l/%L, 					" Cursor line/total lines.
		set statusline+=%c    					" Cursor column.
		set statusline+=\ %P   					" Percent through file.
		set statusline+=\ 0x%B					" Character valur under cursor.
	" }
" }

" Searching {
	set hlsearch		" Highlight search.
	set incsearch		" Incremental search.
	set ignorecase		" Case insensitive search.
	set smartcase		" Smart case search.
	set nowrapscan		" Don't wrap search around file.
" }

" Formatting {
	set wrap			" Wrap long lines.
	set linebreak			" Wrap on 'breakat'-chars.
	"set showbreak=>		" Indicate wrapped lines.
	set showbreak=…			" Indicate wrapped lines.
	set autoindent			" Auto indent lines.
	set smartindent			" Indent smart on C-like files.
	set preserveindent		" Try to preserve indent structure on changes of current line.
	set copyindent			" Copy indentstructure from existing lines.
	set tabstop=8			" Let a tab be 8 spaces wide.
	set shiftwidth=8		" Tab width for auto indent and >> shifting.
	"set softtabstop=8		" Number of spaces to count a tab for on ops like BS and tab.
	set noexpandtab			" Do not expand tabs to spaces!
	set matchpairs+=<:>		" Also match <> with %.
	set formatoptions=tcroqwnl	" Formatting options.
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
	autocmd BufWinLeave * silent! mkview			" Save fold views.
	autocmd BufWinEnter * silent! loadview			" Load fold views on start.
	"autocmd! BufWritePost .vimrc source $MYVIMRC		" Source first found vimrc on change.
" }

" Mappings {
	let mapleader = "\\"								" The key for <Leader>.
	nmap <silent> <C-_> :nohlsearch<CR>						" Clear search matches highlighting. (Ctrl+/ => ^_)
	"nmap <silent> <C-_> :let @/=""<CR>						" Clear search matches highlighting. (Ctrl+/ => ^_)
	nmap <silent> <Leader>v :source $MYVIMRC<CR>					" Source vimrc.
	nmap <silent> <Leader>V :tabe $MYVIMRC<CR>					" Edit vimrc.
	"nmap <silent> <Leader>d "=strftime("%Y-%m-%d")<CR>P 				" Insert the current date.
	noremap <silent> <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>		" Open tags definition in a new tab.
        "noremap <silent> <M-\> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>      		" Open tags definition in a vertical split.
        noremap <silent> <Leader>] :vsp<CR>:exec("tag ".expand("<cword>"))<CR>      		" Open tags definition in a vertical split.
	"nmap <silent> <Leader>S :%s/\s\+$//ge<CR>					" Remove all trailing spaces.
	nnoremap <silent> gfs :wincmd f<CR>						" Open path under cursor in a split.
	nnoremap <silent> gfv :vertical wincmd f<CR>					" Open path under cursor in a vertical split.
	nnoremap <silent> gft :tab wincmd f<CR>						" Open path under cursor in a tab.
	nnoremap <silent> gV `[v`]							" Visually select the text that was last edited/pasted.
	nnoremap g^t :tabfirst<CR>							" Go to first tab.
	nnoremap g$t :tablast<CR>							" Go to last tab.
	noremap Yf :let @" = expand("%")<CR>						" Yank current file name.
	noremap YF :let @" = expand("%:p")<CR>						" Yank current (fully expanded) file name.
	nnoremap <silent> <Leader>R :checktime<CR>						" Reload buffers from file if changed.

	" Redraw window so that search terms are centered.
	nnoremap n nzz
	nnoremap N Nzz

	" Calculate current Word e.g type 1+2 and press ^c.
	inoremap <C-c> <C-O>yiW<End>=<C-R>=<C-R>0<CR>=

	" Enable ^d and ^u movement in completion dialog.
	inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
	inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

	if &l:term  =~ "screen.*"
		noremap <silent> <C-x>x <C-x>						" Decrement for consistency with GNU Screen.
	endif

	" Toggles {
		noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>				" Toggle line wrapping.
		noremap <silent> <Leader>` :set list!<CR>					" Toggle listing of characters.
		noremap <silent> <ESC>p :set paste! paste?<CR>					" Toggle 'paste' for sane pasting.
		noremap <silent> <leader>p :set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>	" Paste on line after in paste-mode from register "*.
		noremap <silent> <leader>P :set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>	" Paste on line before in paste-mode from register "*.

		noremap <silent> <Leader>ac :AutoCloseToggle<CR>				" Toggle AutoClose mode.

		" Toggle spell with a language. {
		function! ToggleSpell(lang)
			if !exists("b:old_spelllang")
				let b:old_spelllang = &spelllang
				let b:old_spellfile = &spellfile
				if exists("s:using_vundle")
					let b:old_dictionary = &dictionary
				endif
			endif

			let l:newMode = ""
			if !&l:spell || a:lang != &l:spelllang
				setlocal spell
				let l:newMode = "spell"
				execute "setlocal spelllang=" . a:lang
				if exists("s:using_vundle")
					execute "setlocal spellfile=" . "~/.vim/spell/" . matchstr(a:lang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
				endif
				execute "setlocal dictionary=" . "~/.vim/spell/" . a:lang . "." . &encoding . ".dic"
				let l:newMode .= ", " . a:lang
			else
				setlocal nospell
				let l:newMode = "nospell"
				execute "setlocal spelllang=" . b:old_spelllang
				if exists("s:using_vundle")
					execute "setlocal spellfile=" . b:old_spellfile
				endif
				execute "setlocal dictionary=" . b:old_dictionary
			endif
			return l:newMode
		endfunction
		" }
		nmap <silent> <F6> :echo ToggleSpell("en_us")<CR>			" Toggle English spell.
		nmap <silent> <F7> :echo ToggleSpell("sv")<CR>				" Toggle Swedish spell.
		nmap <silent> <F8> :echo ToggleSpell("de")<CR>				" Toggle German spell.

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
		nmap <silent> <Leader>J :call HighlightNearCursor()<CR>			" Toggle highlight on cursor-word.

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

" Plugins {
if s:use_plugins
	" AutoClose {
		"let g:AutoClosePairs = AutoClose#ParsePairs("() [] {} <> «» ` \" '") " Pairs to close. Does not seems to work with vundle.
		let g:AutoCloseProtectedRegions = ["Comment", "String", "Character"]	" Syntax regions to ignore.

	" }

	" Clang Complete {
		"let g:clang_auto_select = 1				" Select first entry but don't insert.
		"let g:clang_complete_copen = 1				" Open quickfix on error.
		"let g:clang_close_preview = 1				" Close preview after completion.
		"let g:clang_user_options = '2>/dev/null || exit 0'	" Ignore clang errors.
		"let g:clang_complete_macros = 1				" Complete preprocessor macros and constants.
		"let g:clang_complete_patterns = 1			" Complete code patters e.g. loop constructs.
	" }

	" Clang Format {
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

	" Eclim {
		"let g:EclimFileTypeValidate = 0			" Set to 0 when syntatic should be used instead of eclim. Both can't be used at the same time. See http://eclim.org/vim/java/validate.html
	" }

	" Fugative {
		autocmd BufReadPost fugitive://* set bufhidden=delete	" Close Fugative buffers when leaving.
	" }

	" FuzzyFinder {
		let g:fuf_dataDir = '~/.vim/fuf-data'		" Where to put stored data.
		let g:fuf_keyNextMode = '<C-u>'			" How to switch seach mode. Remapped from default <C-v>
		let g:fuf_keyPrevMode = '<C-i>'			" How to switch seach mode. Remapped from default <C-y>
  	  	let g:fuf_keyPrevPattern = '<C-r>'		" Recall previous pattern. Remapp from default <C-s>

		" Open files with same keybindings as command-t.
		let g:fuf_keyOpenSplit = '<C-d>'		" How to open file in split. Does not work to use <C-s> even if keyPrevPattern is remapped, somehow.
		let g:fuf_keyOpenVsplit = '<C-v>'		" Open file in vertical split.
		let g:fuf_keyOpenTabpage = '<C-t>'		" Open in new tab.

		" Comments can't be after the mapping, that starts the fuzzyview in normal mode.
		" Launch File-mode.
		noremap <silent> ,f :FufFile<CR>
		" Launch Buffer-mode.
		noremap <silent> ,b :FufBuffer<CR>
		" Launch Dir-mode.
		noremap <silent> ,d :FufDir<CR>
		" Launch Tag-mode
		noremap <silent> ,t :FufTag<CR>
		" Launch Tag-mode with current word.
		noremap <silent> ,tw :FufTagWithCursorWord<CR>
		" Launch with Filecoverage-mode.
		noremap <silent> ,c :FufCoverageFile<CR>
	" }

	" Gist {
		let g:gist_detect_filetype = 1				" Detect filetype from name.
		let g:gist_show_privates = 1				" Let Gist -l show private gists.
		"let g:gist_clip_command = 'xclip -selection clipboard'	" Copy command.
		"let g:gist_private = 1					" Make private the default for new Gists.
		"let g:gist_open_browser_after_post = 1			" Open in browser after post.
		"let g:gist_browser_command = 'w3m %URL%'		" Browser to use.
		let g:gist_browser_command = 'firefox  %URL%'		" Browser to use.
	" }

	" Gundo {
		"nmap <silent> <F4> :GundoToggle<CR>		" Toggle Gundo.
		"let g:gundo_close_on_revert=1			" Automatically close on revert.
		"let g:gundo_preview_bottom=1			" Draw preview below current window.
	" }

	" Javacomplete2 {
		"" Required setting
		"autocmd FileType java setlocal omnifunc=javacomplete#Complete

		"" Auto-import symbol under cursor.
		"autocmd FileType java nmap <F10> <Plug>(JavaComplete-Imports-AddSmart)
		"autocmd FileType java imap <F10> <Plug>(JavaComplete-Imports-AddSmart)

		"" Add all missing imports.
		"autocmd FileType java nmap <F11> <Plug>(JavaComplete-Imports-AddMissing)
		"autocmd FileType java imap <F11> <Plug>(JavaComplete-Imports-AddMissing)

		"" Remove all unused imports.
		"autocmd FileType java nmap <F12> <Plug>(JavaComplete-Imports-RemoveUnused)
		"autocmd FileType java imap <F12> <Plug>(JavaComplete-Imports-RemoveUnused)
	" }

	" Jedi {
		"let g:jedi#use_tabs_not_buffers = 1  " Go to a tab when opening a definition.
	" }

	" NERDCommenter {
	" Swap invert comment toggle.
		"map <silent> <Leader>c<Space> <plug>NERDCommenterInvert
		"map <silent> <Leader>ci <plug>NERDCommenterToggle
	" }

	" NERDTree {
		noremap <silent> <F2> :NERDTreeToggle<CR>	" Toggle the NERDTree file browser.
		let g:NERDTreeCaseSensitiveSort=1		" Sort case sensitive.
		let g:NERDTreeMouseMode=3			" Single click opens folders and files.
		let g:NERDTreeQuitOnOpen=1			" Close tree after open.
	" }

	" OmniCppComplete {
		"let OmniCpp_ShowPrototypeInAbbr = 1 	" Show whole prototype (inc. parameters).
		"let OmniCpp_ShowScopeInAbbr = 1 	" Show the scope.
	" }

	" Powerline {
		"" Check if vim plugin exists, e.g. debian's powerline does not currently have it.
		"if isdirectory($POWERLINE_ROOT . "/bindings/vim") && (has('python') || has('python3'))
			"set rtp+=$POWERLINE_ROOT/bindings/vim
			""let g:powerline_pycmd="py3"
			"if has('python3')
				"" Pre-req: $(pip3 install powerline-status).

				"" NOTE there is a current bug in vim that it does not work well with newer pythons. https://github.com/powerline/powerline/issues/1925
				"" NOTE temporary macOS fix #1: recompile vim with python2 instead:  brew reinstall vim --with-python@2
				"" NOTE temporary macOS fix #2: run python3 silently first, then the error is not issued the second time.
				""silent! python3 1
				"" NOTE temporary macOS fix #3: preprend the first import command with silent!
				""silent! python3 from powerline.vim import setup as powerline_setup

				"python3 from powerline.vim import setup as powerline_setup
				"python3 powerline_setup()
				"python3 del powerline_setup
			"elseif has('python')
				"" Pre-req: $(pip2 install powerline-status).
				"python from powerline.vim import setup as powerline_setup
				"python powerline_setup()
				"python del powerline_setup
			"endif
		"endif
	" }

	" Rope {
		"" Remappings done in ~/.vim/ftplugin/python/maps.vim
		"let g:ropevim_guess_project = 1			" Try to guess project to open.
		"let g:ropevim_enable_autoimport = 1 		" Enable the RopeAutoImport command.
		"let g:ropevim_autoimport_underlineds = 1	" Also cache names beginning with underline with Autoimport.
		"" Which modules to generate cache for with the :RopeGenerateAutoimportCache command.
		"let g:ropevim_autoimport_modules = ["__future__", "__main__", "_dummy_thread", "_thread", "abc", "aifc", "argparse", "array", "ast", "asynchat", "asyncio", "asyncore", "atexit", "audioop", "base64", "bdb", "binascii", "binhex", "bisect", "builtins", "bz2", "cProfile", "calendar", "cgi", "cgitb", "chunk", "cmath", "cmd", "code", "codecs", "codeop", "collections", "colorsys", "compileall", "concurrent", "configparser", "contextlib", "copy", "copyreg", "crypt", "csv", "ctypes", "curses", "datetime", "dbm", "decimal", "difflib", "dis", "distutils", "doctest", "dummy_threading", "email", "encodings", "ensurepip", "enum", "errno", "faulthandler", "fcntl", "filecmp", "fileinput", "fnmatch", "formatter", "fpectl", "fractions", "ftplib", "functools", "gc", "getopt", "getpass", "gettext", "glob", "grp", "gzip", "hashlib", "heapq", "hmac", "html", "http", "imaplib", "imghdr", "imp", "importlib", "inspect", "io", "ipaddress", "itertools", "json", "keyword", "lib2to3", "linecache", "locale", "logging", "lzma", "macpath", "mailbox", "mailcap", "marshal", "math", "mimetypes", "mmap", "modulefinder", "msilib", "msvcrt", "multiprocessing", "netrc", "nis", "nntplib", "numbers", "operator", "optparse", "os", "ossaudiodev", "parser", "pathlib", "pdb", "pickle", "pickletools", "pipes", "pkgutil", "platform", "plistlib", "poplib", "posix", "pprint", "profile", "pstats", "pty", "pwd", "py_compile", "pyclbr", "pydoc", "queue", "quopri", "random", "re", "readline", "reprlib", "resource", "rlcompleter", "runpy", "sched", "select", "selectors", "shelve", "shlex", "shutil", "signal", "site", "smtpd", "smtplib", "sndhdr", "socket", "socketserver", "spwd", "sqlite3", "ssl", "stat", "statistics", "string", "stringprep", "struct", "subprocess", "sunau", "symbol", "symtable", "sys", "sysconfig", "syslog", "tabnanny", "tarfile", "telnetlib", "tempfile", "termios", "test", "textwrap", "threading", "time", "timeit", "tkinter", "token", "tokenize", "trace", "traceback", "tracemalloc", "tty", "turtle", "turtledemo", "types", "typing", "unicodedata", "unittest", "urllib", "uu", "uuid", "venv", "warnings", "wave", "weakref", "webbrowser", "winreg", "winsound", "wsgiref", "xdrlib", "xml", "xmlrpc", "zipapp", "zipfile", "zipimport", "zlib"]
	" }

	" Sideways.vim {
		"nnoremap <silent> <a :SidewaysLeft<CR>		" Move function argument to the left.
		"nnoremap <silent> >a :SidewaysRight<CR>		" Move function argument to the right.
	" }

	" Solarized {
		"call togglebg#map("<Leader>%")		" Toggle background with solarized. Not nice because it maps in insert mode too.
		call togglebg#map("<F5>")		" Toggle background with solarized.
	" }


	" Syntastic {
		" NOTE See Eclim section above: set EclimFileTypeValidate=0 as only one of Eclim and Syntastic can be enabled at the same time.

		noremap <silent> <F9> :SyntasticToggleMode<CR>					" Toggle syntastic checking.

		let g:syntastic_always_populate_loc_list = 1	" Always produce the error lists in the location list window.
		let g:syntastic_auto_loc_list = 1		" Automatically open the location list showing where errors are.
		let g:syntastic_check_on_open=0			" Don't automatically do syntax check on open buffers. Assume the file is good until write.
		let g:syntastic_check_on_wq=0			" Don't check on write-quit..

		" Do syntax check on files with exceptions (the passive ones below).
		" mode=active => files are checked when writing a buffer.
		" mode=passive => files only checked on invokation of :SyntasticCheck.
		" active_filetypes: files here are always checked even if the mode is passive. Ignored when mode=active.
		" passive_filetypes: files here are never checked even if the mode is active. Ignored when mode=passive.
		let g:syntastic_mode_map = { 'mode': 'active',
		                        \ 'active_filetypes': [],
		                        \ 'passive_filetypes': ['python'] }
		" Python, use prospector.
		let g:syntastic_python_checkers = ['prospector']

		" Java; the http://checkstyle.sourceforge.net/ checker (aur:checkstyle) might be aster than javac for big projects.
		" This requires a configuration file e.g.  http://checkstyle.sourceforge.net/google_style.html
		"let g:syntastic_java_checkstyle_classpath = '/usr/share/checkstyle/checkstyle.jar'
		"let g:syntastic_java_checkstyle_conf_file = '~/dev/google_checks.xml'
		"let g:syntastic_java_checkers = ['checkstyle']

		" For syntastic support in gradle projects:
		" 1. Add to build.gradle:
		" plugins {
		"     id "org.gradle.java"
		"     id "com.scuilion.syntastic" version "0.3.8"
		" }
		" 2. Run $(./gradlew syntastic) to generate the syntastic config.
		" 3. Enable syntastic javac config file with:
		let g:syntastic_java_javac_config_file_enabled = 1
		" Reference: https://github.com/Scuilion/gradle-syntastic-plugin

		" Recommended settings to show errors in the statusline.
		" Disabled these when using powerline statusbar.
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*
	" }

	" Tagbar {
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

	" Taglist {
		"nmap <silent> <F3> :Tlist<CR>				 	" Toggle the Tlist browser.
		""let g:Tlist_Close_On_Select        = 1			" Close list on tag selection.
		"let g:Tlist_Auto_Update             = 1			" Update newly opend files.
		"let g:Tlist_Compact_Format          = 1			" Trim spaces in GUI.
		"let g:Tlist_Auto_Highlight_Tag      = 1			" Highlight tags.
		"let g:Tlist_GainFocus_On_ToggleOpen = 1			" Move cursor to list on open.
		"let g:Tlist_Sort_Type               = "name"		" Sort by name instead of definition order.
		"let g:Tlist_Use_SingleClick         = 1			" Jump to definition with a single click.
		"let g:Tlist_Show_One_File           = 1			" Only show current buffers tags.
		"let g:Tlist_Use_Right_Window        = 1			" Display on the right.
		""let g:Tlist_Display_Prototype      = 1			" Show prototypes instead of tags.
		"let g:Tlist_Exit_OnlyWindow         = 1			" Close Vim if only Tlist open.
	" }

	" Vim Better Whitespace {
		" Use same command is the old ~/.vim/plugin/stripspaces.vim
		" Need to wrap the command in a function as we can't chain
		" commands unless they were declared to support this.
		" Reference: " https://unix.stackexchange.com/questions/144568/how-do-i-write-a-command-in-vim-to-run-multiple-commands
		function! StripWhitespaceWrapper()
			execute 'StripWhitespace'
		endfunction
		command! Ws call StripWhitespaceWrapper()|update
	" }

endif
" }

" Source local {
	"if filereadable(expand("~/.vimrc.local"))
		"source ~/.vimrc.local
	"endif
" }

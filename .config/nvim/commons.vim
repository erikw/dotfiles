" Nvim-Vim shared common config.
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
" }

" Mappings {
let mapleader = "\\"					" The key for <Leader>.
nmap <silent> <C-_> :nohlsearch<CR>			" Clear search matches highlighting. (Ctrl+/ => ^_)
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
noremap <Leader>l :set relativenumber!<CR>			" Toggle :number between absolute and line relative.
noremap <silent> <ESC>p :set paste! paste?<CR>			" Toggle 'paste' for sane pasting.
noremap <silent> <leader>p :set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>	" Paste on line after in paste-mode from register "*.
noremap <silent> <leader>P :set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>	" Paste on line before in paste-mode from register "*.

" Toggle spell with a language. {
function! ToggleSpell(lang)
	if !exists("b:old_spelllang")
		let b:old_spelllang = &spelllang
		let b:old_spellfile = &spellfile
		let b:old_dictionary = &dictionary
		let b:old_thesaurus = &thesaurus
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

" Plugin Config {
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" }

" ALE {
" Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
" Linting {
" Disabled linters:
		"\ 'sql': ['sqls'],
		"\ 'tex': ['texlab'],
let g:ale_linters = {
		\ 'go': ['gopls'],
		\ 'json': ['jsonls'],
		\ 'python': ['pyright', 'flake8'],
		\ 'ruby': ['solargraph'],
		\ 'sh': ['language_server'],
		\ 'vim': ['vimls'],
		\ }
" }

" Fixing {
" * - disabled 'trim_whitespace' and 'remove_trailing_lines' as it overlaps with the functionally already provided by vim-better-whitespace.
" python - disabled autoimport as it messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59
let g:ale_fixers = {
	\ '*': ['prettier'],
	\ 'ruby': ['rubocop'],
	\ 'python': ['autoflake', 'black', 'isort'],
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

" lexima.vim {
" Put cursor between ```-blocks in markdown files after <CR. Reference: https://github.com/cohama/lexima.vim/issues/121
call lexima#add_rule({'at': '^```\(\S*\)\%#```', 'char': '<CR>', 'input': '<CR>', 'input_after': '<CR>', 'filetype': ['markdown']})
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
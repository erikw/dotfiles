" Erik Westrup's Neovim configuration.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
" }

" Profiling {
" $ nvim --startuptime /tmp/nvim.log
" $ nvim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" Plugins {
" vim-plug data folder
call plug#begin(stdpath('data') . '/plugged')

" General {
	"Plug 'dhruvasagar/vim-table-mode'			" Create ASCII tables
	"Plug 'godlygeek/tabular'				" Create tables. Disabled: not used and have some startup time.
	"Plug 'mattn/vim-gist' | Plug 'mattn/webapi-vim'	" Post a new Gist.
	"Plug 'salsifis/vim-transpose'				" Matrix transposition of texts.
	"Plug 'scrooloose/nerdtree'				" Replaced by built-in netrw
	"Plug 'sjl/gundo.vim'					" Use 'mbbill/undotree' instead; is better: https://vi.stackexchange.com/a/13863
	"Plug 'vim-scripts/lbdbq'				" Mutt: Query lbdb for recipinents.
	"Plug 'voldikss/vim-translator'				" Async language translator.
	Plug 'bfontaine/Brewfile.vim', { 'for': 'brewfile' }	" Syntax for Brewfiles
	Plug 'danro/rename.vim'					" Provides the :Rename command
	Plug 'fidian/hexmode'					" Open binary files as a HEX dump with :Hexmode
	Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}	" Live preview markdown files in browser.
	Plug 'mbbill/undotree'					" Navigate history in a sidebar.
	Plug 'michaeljsmith/vim-indent-object'			" Operate on intendtation as text objects
	Plug 'ntpeters/vim-better-whitespace'			" Highlight and remove trailing whitespaces.
	Plug 'preservim/nerdcommenter'				" Comment source code.
	Plug 'tpope/vim-capslock'				" Software CAPSLOCK.
	Plug 'tpope/vim-fugitive'				" Git wrapper and shorthands.
	Plug 'tpope/vim-repeat'					" Extend '.' repetition for plugins like vim-surround, vim-speeddating.
	Plug 'tpope/vim-speeddating'				" Increment dates with C-a.
	Plug 'tpope/vim-surround'				" Work on surrond delimiters or its content.
	Plug 'tpope/vim-unimpaired'				"  Bracket mappings like [<space>
" }

" Development {
" Development: General {
	Plug 'AndrewRadev/sideways.vim'		" Shift function arguments left and right.
	Plug 'Townk/vim-autoclose'		" Automatically insert matching brace pairs.
	Plug 'airblade/vim-gitgutter'		" Git modified status in sign column
	Plug 'andymass/vim-matchup'		" Extend % matching. Replaces old the matchit plugin.
	Plug 'editorconfig/editorconfig-vim'	" Standard .editorconfig file in shared projects.
	Plug 'hrsh7th/nvim-cmp' | Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer'	" Autocompletion when typing with LSP backend.
	Plug 'neovim/nvim-lspconfig'		" Plug-n-play configurations for LSP server.
	Plug 'preservim/tagbar'			" Sidepane showing info from tags file.
	Plug 'rhysd/conflict-marker.vim'	" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
	Plug 'vim-scripts/argtextobj.vim'	" Make function arguments text objects that can be operated on with.
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

" UI {
	"Plug 'dstein64/nvim-scrollview'	" Visual and interactive scroll bar.
	"Plug 'vim-scripts/ScrollColors'	" Cycle though available colorschemes.
	Plug 'cormacrelf/dark-notify'		" Watch system light/dark mode changes.  Requires dark-notify(1).
	Plug 'mhinz/vim-startify'		" Start screen with recently opended files.
	Plug 'mkitt/tabline.vim'		" More informative tab titles.


" Colorschemes {
	"Plug 'mhartington/oceanic-next'
	"Plug 'morhetz/gruvbox'
	Plug 'overcache/NeoSolarized'
" }
"}

" Initialize plugin system
call plug#end()
" }

" General {
set undofile				" Save undo to file in undodir.
set shortmess=filmnrxtToO		" Abbreviate messages.
set nrformats=alpha,bin,octal,hex	" What to increment/decrement with ^A and ^X.
set hidden				" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables when saving sessions.
set undolevels=2048			" Levels of undo to keep in memory.
"set clipboard+=unnamed			" Use register "* instead of unnamed register. This means what is being yanked in vim gets put to external clipboard automatically.
set timeoutlen=1500			" Timout (ms) for mappings and keycodes.
set completeopt=longest,menu,preview	" Insert most common completion and show menu.
set omnifunc=syntaxcomplete#Complete	" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
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
set cinoptions+=g=			" Left-indent C++ access labels.
"set pastetoggle  = <Leader>p   " Toggle 'paste' for sane pasting.
" }

" GUI {
"if has('gui_running')
" TBD vimr does not support any gui-settings at the moment.
"endif
" }

" LSP {
" NOTE remember to update servers array below when adding a new LSP config.
lua << EOF
	-- require'lspconfig'.ccls.setup{}
	-- require'lspconfig'.sqls.setup{}
	-- require'lspconfig'.texlab.setup{}
	require'lspconfig'.bashls.setup{}
	require'lspconfig'.gopls.setup{}
	require'lspconfig'.jsonls.setup {}
	require'lspconfig'.pyright.setup{}
	require'lspconfig'.solargraph.setup{}
	require'lspconfig'.vimls.setup{}
EOF

" Activate & Keybindings {
" From https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'jsonls', 'pyright', 'solargraph', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
" }


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

" Searching {
set ignorecase	" Case insensitive search.
set smartcase	" Smart case search.
set nowrapscan	" Don't wrap search around file.
" }

" Spelling {
set spelllang=en_us		" Languages to do spell checking for.
set spellsuggest=best,10	" Limit spell suggestions.
" Set spellfile dynamically. Shared with Vim.
execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
execute "set thesaurus=" . "~/.vim/thesaurus/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . ".txt"
" }

" UI {
colorscheme NeoSolarized

" Adjust colors to this background.
if filereadable(expand("$XDG_CONFIG_HOME/solarizedtoggle/status"))
	let &background = readfile(expand("$XDG_CONFIG_HOME/solarizedtoggle/status"), '', 1)[0]
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

set termguicolors	" Enable 24-bit RGB. Required by NeoSolarized.
set mouse=a		" Enable mouse in all modes.
set title		" Show title in console title bar.
set number		" Show line numbers.
set showmatch		" Shortly jump to a matching bracket when match.
set cursorline		" Highlight the current line.
"set cursorcolumn	" Highlight the current column.
set wildignorecase	" Case insensitive filename completion.
set scrolljump=5	" Lines to scroll when cursor leaves screen.
set scrolloff=3		" Minimum lines to keep above and below cursor.
set splitbelow		" Open horizontal split below.
set splitright		" Open vertical split to the right.
set listchars=eol:$,space:·,tab:>-,trail:¬,extends:>,precedes:<,nbsp:.	" Characters to use for :list.

" Statusline {
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
" clang_complete {
	"let g:clang_auto_select = 1				" Select first entry but don't insert.
	"let g:clang_complete_copen = 1				" Open quickfix on error.
	"let g:clang_close_preview = 1				" Close preview after completion.
	"let g:clang_user_options = '2>/dev/null || exit 0'	" Ignore clang errors.
	"let g:clang_complete_macros = 1			" Complete preprocessor macros and constants.
	"let g:clang_complete_patterns = 1			" Complete code patters e.g. loop constructs.
" }

" dark-notify {
:lua <<EOF
	require('dark_notify').run()
EOF
" }

" fzf.vim {
" Stolen from my friend https://github.com/erikagnvall/dotfiles/blob/master/vim/init.vim
nnoremap <leader>f :FZF<space>	" Search for files in given path.
nnoremap <c-p> :Files<CR>	" Search for files starting at current directory.
nnoremap <leader>T :Tags<CR>	" Search in tags file.
nnoremap ; :Buffers<CR>		" Search open buffers.
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
set completeopt=menu,menuone,noselect

" Lua Setup {
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        --vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },

      { name = 'buffer' },
    }
  })

  -- Setup lspconfig.
  require('lspconfig')['bashls'].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
  require('lspconfig')['jsonls'].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
  require('lspconfig')['pyright'].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
  require('lspconfig')['solargraph'].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
  require('lspconfig')['vimls'].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
EOF
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
let g:AutoClosePairs = "() [] {} <> «» ` \" '"	" Pairs to auto-close.
"let g:AutoCloseProtectedRegions = ["Comment", "String", "Character"]	" Syntax regions to ignore.

noremap <silent> <Leader>ac :AutoCloseToggle<CR>				" Toggle vim-autoclose plugin mode.
" }

" vim-better-whitespace {
let g:strip_whitelines_at_eof=1		" Also strip empty lines at end of file on save.
let g:show_spaces_that_precede_tabs=1	" Highlight spaces that happens before tab.

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
"let g:startify_fortune_use_unicode = 1	" Draw fortune with Unicode instead of ASCII. Not needed with startify_custom_header.
"let g:startify_files_number = 15	" Nubmer of files to show.
" Bookmarks
let g:startify_bookmarks = [ {'v': '$XDG_CONFIG_HOME/nvim/init.vim'}, '$XDG_CONFIG_HOME/shell/commons', '$XDG_CONFIG_HOME/shell/aliases' ]


" Reference: https://vi.stackexchange.com/a/9942
let s:nvim_version = matchstr(execute('version'), 'NVIM v\zs[^\n]*')

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
  \ '    Neovim v' . s:nvim_version
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

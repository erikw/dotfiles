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

" Environment {
let g:xdg_config_home = empty($XDG_CONFIG_HOME) ? "$HOME/.config" : $XDG_CONFIG_HOME
let g:xdg_state_home = empty($XDG_STATE_HOME) ? "$HOME/.local/state" : $XDG_STATE_HOME
" }

" Plugins {
" Setup {
let g:ale_completion_enabled = 1	" Must be set before ALE is loaded.

" vim-plug data folder
call plug#begin(stdpath('data') . '/plugged')

" The python provider (pythonx.vim) checker takes alomost 1 second on startup.
" Do one of:
" * Install neovim package in used version: $ pip install neovim, then
" :checkhealth
" * Disable the provider (not used by curret plugins anyways.)
" Reference: https://www.reddit.com/r/neovim/comments/ksf0i4/slow_startup_time_when_opening_python_files_with/
let g:loaded_python3_provider = 0

" Let's disable more that is not used to gain startup time.
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_provider_provider = 0
let g:loaded_node_provider = 0
" }

" General {
	"Plug 'LucHermitte/local_vimrc' | Plug 'LucHermitte/lh-vim-lib' " Project local vim config.
	"Plug 'dhruvasagar/vim-table-mode'			" Create ASCII tables
	"Plug 'fidian/hexmode'					" Open binary files as a HEX dump with :Hexmode
	"Plug 'gennaro-tedesco/nvim-peekup'			" Register viewer and selector. TODO not working to paste
	"Plug 'godlygeek/tabular'				" Create tables. Disabled: not used and have some startup time.
	"Plug 'mattn/vim-gist' | Plug 'mattn/webapi-vim'	" Post a new Gist.
	"Plug 'salsifis/vim-transpose'				" Matrix transposition of texts.
	"Plug 'svermeulen/vim-yoink'				" Yankring implementation.
	"Plug 'voldikss/vim-translator'				" Async language translator.
	Plug 'axieax/urlview.nvim'				" Open URLs in buffer.
	Plug 'danro/rename.vim'					" Provides the :Rename command
	Plug 'folke/which-key.nvim'				" Show matching keybindings e.g. when tapping Leader.
	Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}	" Live preview markdown files in browser.
	Plug 'kyazdani42/nvim-tree.lua'				" File explorer tree
	Plug 'kylechui/nvim-surround'				" Work on surrond delimiters or its content. Like tpope/vim-surround but with TreeSitter.
	Plug 'mbbill/undotree'					" Navigate history in a sidebar. Replaces old 'mbbill/undotree'
	Plug 'michaeljsmith/vim-indent-object'			" Operate on intendtation as text objects.
	Plug 'ntpeters/vim-better-whitespace'			" Highlight and remove trailing whitespaces.
	Plug 'phaazon/hop.nvim'					" Easy motion jumps in buffer.
	Plug 'preservim/nerdcommenter'				" Comment source code.
	Plug 'tpope/vim-capslock'				" Software CAPSLOCK with <C-g>c in insert mode.
	Plug 'tpope/vim-characterize'				" 'ga' on steroid.
	Plug 'tpope/vim-repeat'					" Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
	Plug 'tpope/vim-speeddating'				" Increment dates with C-a.
	Plug 'tpope/vim-unimpaired'				" Bracket mappings like [<space>
" }

" Development {
" Development: General {
	"Plug 'github/copilot.vim'			" AI powered code completion.
	"Plug 'lukas-reineke/indent-blankline.nvim'	" Indent vertical markers.
	"Plug 'mfussenegger/nvim-dap'			" Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA config is not working (freezes nvim).
	Plug 'AndrewRadev/sideways.vim'			" Shift function arguments left and right.
	Plug 'airblade/vim-gitgutter'			" Git modified status in sign column
	Plug 'andymass/vim-matchup'			" Extend % matching.
	Plug 'editorconfig/editorconfig-vim'		" Standard .editorconfig file in shared projects.
	Plug 'godlygeek/tabular' | Plug 'preservim/vim-markdown' " Markdown utilties like automatic list indention, TOC.
	Plug 'ibhagwan/fzf-lua' | Plug 'mrjones2014/dash.nvim', { 'do': 'make install' } " Search dash.app from nvim.
	Plug 'm-demare/hlargs.nvim'			" Highlight usage of method arguments.
	Plug 'nguyenvukhang/nvim-toggler'		" Toggle values like true/false with <leader>i.
	Plug 'nvim-lua/plenary.nvim' | Plug 'andythigpen/nvim-coverage' " Show code coverage in sign column.
	Plug 'nvim-lua/plenary.nvim' | Plug 'sindrets/diffview.nvim' " Better than fugative ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " NVim interface for tree-sitter (language parser).
	Plug 'rgroli/other.nvim'			" Open related file like test.
	Plug 'rhysd/conflict-marker.vim'		" Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
	Plug 'ruanyl/vim-gh-line'			" Copy link to file on GitHub.
	Plug 'superDross/ticket.vim'			" Manage vim Sessions per git branch.
	Plug 'tpope/vim-fugitive'			" Git wrapper and shorthands.
	Plug 'wellle/targets.vim'			" Extra text objects to operate on e.g. function arguments.
	Plug 'windwp/nvim-autopairs'			" Autoclose brackets etc.
" }

" Development: LSP/Completion {
	"Plug 'neovim/nvim-lspconfig'			" Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.
	Plug 'dense-analysis/ale'			" LSP linting engine.
	Plug 'ray-x/lsp_signature.nvim'			" Method signature window, as ALE does not support it. Ref: https://www.reddit.com/r/vim/comments/jhqzsv/signature_help_via_ale/
	Plug 'liuchengxu/vista.vim'			" LSP symbols and tags viewer, like TagBar but with LSP support.
" }

" Development: DAP {
	"Plug 'mfussenegger/nvim-dap' " Debug Adapter Protocol
	"Plug 'rcarriga/nvim-dap-ui'  " UI for DAP
	"Plug 'suketa/nvim-dap-ruby'  " Config for ruby. Requries the `debug` gem. No rails support yet: https://github.com/suketa/nvim-dap-ruby/issues/25
" }

" Development: C/C++ {
	"Plug 'chazy/cscope_maps'						" More macros than autoload_cscope.vim
	"Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }
	"Plug 'vim-scripts/autoload_cscope.vim', { 'for': ['c', 'cpp'] }	" Load cscope file and define macros for using it. https://github.com/vim-scripts/autoload_cscope.vim/blob/master/plugin/autoload_cscope.vim#L81-L88
	Plug 'ludovicchabant/vim-gutentags'					" Autogenerate new tags file.
"}

" Development: Go {
	"Plug 'fatih/vim-go', { 'for': 'go' }	" Compilation commands etc.
"}

" Development: Java {
	"Plugin 'artur-shaik/vim-javacomplete2', { 'for': 'java' }	" Omni-complete for Java
	"Plugin 'erikw/jcommenter.vim', { 'for': 'java' }		" Generate javadoc.
"}

" Development: LaTeX {
	"Plug 'donRaphaco/neotex'	" Live preview PDF output from latex.
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
	Plug 'dcampos/nvim-snippy'	" Snippets engine compatible with the SnipMate format.
	Plug 'honza/vim-snippets'	" Snippet library
" }

" Syntax {
	Plug 'bfontaine/Brewfile.vim', { 'for': 'brewfile' }		" Syntax for Brewfiles
	Plug 'kalekundert/vim-nestedtext', { 'for': 'nestedtext' }	" Syntax for NestedText .nt files.
" }

" UI {
	"Plug 'RRethy/vim-illuminate'		" Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
	"Plug 'yamatsum/nvim-cursorline'	" Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
	Plug 'chentoast/marks.nvim'		" Visualize marks in the sign column.
	Plug 'cormacrelf/dark-notify'		" Watch system light/dark mode changes. Requires dark-notify(1).
	Plug 'karb94/neoscroll.nvim'		" Smoth scrolling.
	Plug 'kyazdani42/nvim-web-devicons'	" Dependency for: nvim-tree.lua, lualine.nvim, barbar.nvim
	Plug 'mhinz/vim-startify'		" Start screen with recently opended files.
	Plug 'crispgm/nvim-tabline'		" More informative tab titles.
	Plug 'nvim-lualine/lualine.nvim'	" Statusline.
	Plug 'sitiom/nvim-numbertoggle'		" Automatic relative / static line number toggling.

" Colorschemes {
	"Plug 'altercation/vim-colors-solarized'	" The one theme to rule them all.
	"Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	"Plug 'mhartington/oceanic-next'
	"Plug 'morhetz/gruvbox'
	Plug 'ishan9299/nvim-solarized-lua'		" Solarized theme that works with nvim-treesitter highlights.
" }
"}

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

" General {
set nrformats=alpha,octal,hex		" What to increment/decrement with ^A and ^X.
set tabpagemax=100			" Upper limit on number of tabs.
set hidden				" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables in sessions.
set sessionoptions-=folds		" Don't store folds in sessions.
set undofile				" Save undo to file in undodir.
set undolevels=2048			" Levels of undo to keep in memory.
set timeoutlen=500			" Timout (ms) for mappings and keycodes. Make it a bit snappier.
set shortmess=filmnrxtToOA		" Abbreviate messages. 'A' disables the attention prompt when editing a file that is already open (beware: https://superuser.com/a/1065503)
" }

" LSP {
"" NOTE remember to update servers array below when adding a new LSP config.
"lua << EOF
	"-- require'lspconfig'.ccls.setup{}
	"-- require'lspconfig'.sqls.setup{}
	"-- require'lspconfig'.texlab.setup{}
	"require'lspconfig'.bashls.setup{}
	"require'lspconfig'.gopls.setup{}
	"require'lspconfig'.jsonls.setup {}
	"require'lspconfig'.pyright.setup{}
	"require'lspconfig'.solargraph.setup{}
	"require'lspconfig'.vimls.setup{}
"EOF

"" Activate & Keybindings {
"" From https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
"lua << EOF
"local nvim_lsp = require('lspconfig')

"-- Use an on_attach function to only map the following keys
"-- after the language server attaches to the current buffer
"local on_attach = function(client, bufnr)
  "local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  "local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  "-- Enable completion triggered by <c-x><c-o>
  "buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  "-- Mappings.
  "local opts = { noremap=true, silent=true }

  "-- See `:help vim.lsp.*` for documentation on any of the below functions
  "buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  "buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  "buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  "buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  "buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  "buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  "buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  "buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  "buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  "buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  "buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  "buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  "buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  "buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  "buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  "buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  "buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

"end

"-- Use a loop to conveniently call 'setup' on multiple servers and
"-- map buffer local keybindings when the language server attaches
"local servers = { 'bashls', 'jsonls', 'pyright', 'solargraph', 'vimls' }
"for _, lsp in ipairs(servers) do
  "nvim_lsp[lsp].setup {
    "on_attach = on_attach,
    "flags = {
      "debounce_text_changes = 150,
    "}
  "}
"end
"EOF
"" }
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
" Set 'spellang' last, otherwise vim (but not nvim) complaines that ~/.vim/spell dont' exist.
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
" }

" Spelling {
set spelllang=en_us		" Languages to do spell checking for.
set spellsuggest=best,10	" Limit spell suggestions.
" Set spellfile dynamically.
execute "set spellfile=" . stdpath('config') . "/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
execute "set thesaurus=" . stdpath('config') . "/thesaurus/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . ".txt"
" }

" UI {
" Ignore if don't exist. This is the case when $(vim -c PlugInstall) the firs time. Ref: https://stackoverflow.com/a/5703164/265508
silent! colorscheme solarized

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
" }

" Plugin Config {
" ALE {
" Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
" Linting {
" Disabled linters:
		"\ 'sql': ['sqls'],
let g:ale_linters = {
		\ 'go': ['gopls'],
		\ 'javascript': ['eslint'],
		\ 'json': ['jsonls'],
		\ 'python': ['pyright', 'flake8'],
		\ 'ruby': ['solargraph', 'ruby'],
		\ 'sh': ['language_server'],
		\ 'tex': ['texlab'],
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

" copilot.vim {
"" Disable/enable per filetype
"      "\ '*': v:false, # global toggle, all on or all off.
"let g:copilot_filetypes = {
"      \ '*': v:false,
"      \ 'txt': v:false,
"      \ 'markdown': v:false,
"      \ 'sh': v:true,
"      \ 'py': v:true,
"      \ 'rb': v:true,
"      \ }

"" Remap from <tab> as this is used by snipmate.
"" Reference: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
"inoremap <silent><expr> <C-Space> copilot#Accept("")
"let g:copilot_no_tab_map = 1
" }

" dark-notify {
lua <<EOF
	require('dark_notify').run({
		onchange = function(mode)
			-- Init hlargs.nvim.
			-- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
			-- Ref: https://github.com/cormacrelf/dark-notify/issues/8
			require('hlargs').setup()
	    end
})
EOF
nmap <silent> <F5> :lua require('dark_notify').toggle()<CR> " Override mapping from above.
" }

" dash.vim {
nnoremap <Leader>d :DashWord<CR>
nnoremap <Leader>D :Dash<CR>
lua <<EOF
require('dash').setup({
  -- your config here
})
EOF
" }

" fzf.vim {
" Stolen from my friend https://github.com/erikagnvall/dotfiles/blob/master/vim/init.vim
" Comment must be on line of its own...
" Search for files in given path.
nnoremap <Leader>f :FZF<space>
" Search for files starting at current directory.
" Sublime-like shortcut 'go to file' ctrl+p.
" Disable this when using yoink; see vim-yoink section for a re-mapping for :Files
nnoremap <C-p> :Files<CR>
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

" hop.nvim {
lua <<EOF
	require'hop'.setup()
	-- Keybindings
	-- Vim Command to Lua function mapping: https://github.com/phaazon/hop.nvim/wiki/Advanced-Hop#lua-equivalents-of-hop-commands
	vim.api.nvim_set_keymap('', '<leader>h', "<cmd>lua require'hop'.hint_words()<cr>", {})
EOF
" }

" hlargs.vim {
" Due to a bug when dark-notify is enabled, do the hlargs init is done in the  dark-notify callback.
" Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
"lua <<EOF
"require('hlargs').setup()
"EOF
" }

" indent-blankline.nvim {
"lua <<EOF
"require("indent_blankline").setup {
"    use_treesitter = true,  -- use treesitter to calculate indentation.
"    show_current_context = true,  -- highlight current indent block.
"    show_current_context_start = true, -- underline first line of current indent block.
"}
"EOF
" }

" local_vimrc {
"" File names to recognize.
"let g:local_vimrc = ['.vimlocal', '_vimrc_local.vim']
"" Paths to not ask before loading.
"if exists("lh#local_vimrc")
"        call lh#local_vimrc#munge('whitelist', $HOME.'/src/github.com/erikw')
"end
" }

" lsp_signature.nvim {
lua << EOF
require "lsp_signature".setup({
	toggle_key = '<M-x>', -- toggle signature on and off in insert mode
	select_signature_key='<M-n>' , -- cycle to next signature
})
EOF
" }

" lualine.nvim {
lua <<EOF
require('lualine').setup {
  sections = {
    lualine_c = {{
	'filename',
	path = 1 -- relative path
	}},
  },
  extensions = {'fugitive', 'fzf', 'nvim-tree', 'quickfix'}
}
EOF
" }

" marks.nvim {
lua <<EOF
require'marks'.setup {}
EOF
" }

" neoscroll.nvim {
lua require('neoscroll').setup()
" }

" nerdcommenter {
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" }

" nvim-autopairs {
lua << EOF
require('nvim-autopairs').setup({
	check_ts = true, --  Use treesitter to check for a pair
	map_c_h = true, -- Map the <C-h> key to delete a pair
	map_c_w = true, -- map <c-w> to delete a pair if possible
})
EOF
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

" nvim-dap {
" Suggested mappings from *dap-mappings* https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt
"nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
"nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
"nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
"nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
"nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
"nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
"nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
"nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
"nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
" }

" nvim-dap-ruby {
"lua require('dap-ruby').setup()
" }

" nvim-dap-ui {
"lua require("dapui").setup()
" }

" nvim-numbertoggle {
" init.vim or .vimrc
lua << EOF
require("numbertoggle").setup()
EOF
" }

" nvim-snippy {
lua <<EOF
require('snippy').setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
    },
})
EOF
" }

" nvim-coverage {
lua << EOF
require("coverage").setup({
})
EOF
" }

" nvim-cursorline {
"lua << EOF
"require('nvim-cursorline').setup { }
"EOF
" }

" nvim-surround {
lua << EOF
require("nvim-surround").setup()
EOF
" }

" nvim-tabline {
lua <<EOF
require('tabline').setup({})
EOF
" }

" nvim-toggler {
lua << EOF
require('nvim-toggler').setup()
EOF
" }

" nvim-tree.lua {
"noremap <silent> <F2> :NvimTreeToggle<CR> " Toggle file explorer tree

" Global toggles until https://github.com/kyazdani42/nvim-tree.lua/issues/1493
" Could extend this by having just one Toggle function that keeps state in a
" global variable.
noremap <silent> <F2> :NvimTreeOpen<CR> " Toggle file explorer tree.
" NvimTreeCloseAll() {
function! NvimTreeCloseAll()
	let current_tab = tabpagenr()
	tabdo NvimTreeClose
	execute 'tabnext' current_tab
endfunction
" }
nnoremap <silent> <S-F2> :call NvimTreeCloseAll()<CR>	" Close NvimTree in all tabs.

lua <<EOF
require("nvim-tree").setup {
	open_on_setup = true,
	open_on_setup_file = false,
	open_on_tab = true,
	filters = { custom = { "^.git$" } },
	view = {
		width = "15%",
		side = "left",
	},
}
EOF
" }

" nvim-treesitter {
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all". Install manually with :TSINstall <parser>
  -- comment - for parsing e.g. TODO markers in comments.
  ensure_installed = { "comment", "lua", "ruby", "python", "javascript", "markdown" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
     enable = true,
   },
   indent = {
     enable = true
   },
}
EOF
" }

" other.nvim {
" init.vim or .vimrc
lua << EOF
require("other-nvim").setup({
	-- Show menu each time for multiple other files.
	rememberBuffers = false,
	mappings = {
		-- builtin mappings
		"rails",
		-- custom mappings
	},
	style = {
		width = 0.7,
	},
})

vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lx", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- Context specific bindings
vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:OtherVSplit test<CR>", { noremap = true, silent = true })
EOF
" }

" sideways.vim {
nnoremap <silent> <a :SidewaysLeft<CR>		" Move function argument to the left.
nnoremap <silent> >a :SidewaysRight<CR>		" Move function argument to the right.
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

" urlview.nvim {
lua << EOF
require("urlview").setup({
})

vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
EOF
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

" vim-fugative {
autocmd BufReadPost fugitive://* set bufhidden=delete	" Close Fugitive buffers when leaving.
" }

" vim-gist {
"let g:gist_detect_filetype = 1				" Detect filetype from name.
"let g:gist_show_privates = 1				" Let Gist -l show private gists.
"let g:gist_private = 1					" Make private the default for new Gists.
"let g:gist_open_browser_after_post = 1			" Open in browser after post.
""let g:gist_clip_command = 'xclip -selection clipboard'	" Copy command.
""let g:gist_browser_command = 'w3m %URL%'		" Browser to use.
"let g:gist_browser_command = 'firefox  %URL%'		" Browser to use.
" }

" vim-gitgutter {
set updatetime=100		" Speedier update of file status.
" }

" vim-illuminate {
"lua << EOF
"require('illuminate').configure()
"EOF
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

" vim-startify {
"let g:startify_fortune_use_unicode = 1	" Draw fortune with Unicode instead of ASCII. Not needed with startify_custom_header.
"let g:startify_files_number = 15	" Nubmer of files to show.
" Bookmarks
let g:startify_bookmarks = [
	\ {'v': g:xdg_config_home . '/nvim/init.vim'},
	\ g:xdg_config_home . '/shell/commons',
	\ g:xdg_config_home . '/shell/aliases'
	\ ]


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

" vim-yoink {
"let g:yoinkMaxItems=16			" Increase from default 10.
"let g:yoinkSyncNumberedRegisters=1	" Repurpose the registers to be a history stack!
"let g:yoinkIncludeDeleteOperations=1	" Include text delete operations in the yank history.
"let g:yoinkSyncSystemClipboardOnFocus=0	" Don't integrate with system clipboard.

"let g:yoinkSavePersistently=1		" Persist history across sessions.


"" Replace default paste with Yoink. "xp still works
"nmap p <plug>(YoinkPaste_p)
"nmap P <plug>(YoinkPaste_P)

"" Also replace the default gp with yoink paste so we can toggle paste in this case too
"nmap gp <plug>(YoinkPaste_gp)
"nmap gP <plug>(YoinkPaste_gP)

"" Cycle yankring immediately after pasting.
"nmap <c-n> <plug>(YoinkPostPasteSwapBack)
""nmap <c-p> <plug>(YoinkPostPasteSwapForward)
"" Let c-p execute fzf if we're not in paste mode.
"nmap <expr> <c-p> yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : ':Files<CR>'

"" Toggle formatted paste.
""nmap <c-=> <plug>(YoinkPostPasteToggleFormat)
" }

" vista.vim {
nmap <silent> <F3> :Vista!! <CR>	" Toggle the tag sidewindow.
let g:vista_default_executive = 'ale'	" Default executive.
let g:vista_sidebar_width = 50		" Window width.
" }

" which-key.nvim {
lua << EOF
  require("which-key").setup {
  }
EOF
" }

" undotree {
nmap <silent> <F4> :UndotreeToggle<CR>	" Toggle side pane.
let g:undotree_WindowLayout=2		" Set style to have diff window below.
let g:undotree_SetFocusWhenToggle=1	" Put cursor in undo window on open.
" }
" }

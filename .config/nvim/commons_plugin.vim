" Nvim-Vim shared common plugins.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
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
	Plug 'tpope/vim-surround'				" Work on surrond delimiters or its content. TODO replace with https://github.com/kylechui/nvim-surround ?
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
	Plug 'preservim/tagbar'				" Sidepane showing info from tags file.
	Plug 'rhysd/conflict-marker.vim'		" Navigate and edit VCS conflicts. Replace unmaintained 'vim-script/ConflictMotions'
	Plug 'vim-scripts/argtextobj.vim'		" Make function arguments text objects that can be operated on with.
	Plug 'godlygeek/tabular' | Plug 'preservim/vim-markdown' " Markdown utilties like list indention, TOC.
	Plug 'ruanyl/vim-gh-line'			" Copy lik to file on GitHub.
	Plug 'superDross/ticket.vim'
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
" }
"}

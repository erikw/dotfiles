" Erik Westrup's Neovim configuration.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
" }
" gf shourtcuts:
" ~/.config/nvim/commons_plugin.vim
" ~/.config/nvim/commons.vim

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

" Common Plugins {
" gf shourtcut: ~/.config/nvim/commons_plugin.vim
execute "source " . stdpath('config') . "/commons_plugin.vim"
" }

" General {
	Plug 'kyazdani42/nvim-tree.lua' " File explorer tree
	Plug 'kyazdani42/nvim-web-devicons' " Dependency for: nvim-tree.lua, lualine.nvim
	Plug 'nvim-lualine/lualine.nvim'  " Statusline
" }

" Development {
" Development: General {
	"Plug 'hrsh7th/nvim-cmp' | Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer' | Plug 'hrsh7th/cmp-vsnip' | Plug 'hrsh7th/vim-vsnip'	" Autocompletion when typing with LSP backend. Disabled as too fast-moving development and bugs.
	"Plug 'mfussenegger/nvim-dap'			" Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA config is not working (freezes nvim).
	"Plug 'neovim/nvim-lspconfig'			" Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.
	Plug 'github/copilot.vim'			" AI powered code completion.
	Plug 'ibhagwan/fzf-lua' | Plug 'mrjones2014/dash.nvim', { 'do': 'make install' } " Search dash.app from nvim.
	Plug 'lukas-reineke/indent-blankline.nvim'	" Indent vertical markers.
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " NVim interface for tree-sitter (language parser).
" }
" }

" UI {
	"Plug 'dstein64/nvim-scrollview'	" Visual and interactive scroll bar.
	"Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"}

" Setup - end {
" Initialize plugin system
call plug#end()
" }
" }

" Commons Config {
" gf shourtcut: ~/.config/nvim/commons.vim
execute "source " . stdpath('config') . "/commons.vim"
" }

" General {
set shortmess=filmnrxtToO		" Abbreviate messages.
"set clipboard+=unnamed			" Use register "* instead of unnamed register. This means what is being yanked in vim gets put to external clipboard automatically.
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
set cinoptions+=g=			" Left-indent C++ access labels.
"set pastetoggle  = <Leader>p   " Toggle 'paste' for sane pasting.
" }

" GUI {
"if has('gui_running')
" TBD vimr does not support any gui-settings at the moment.
"endif
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
" Ignore if don't exist. This is the case when $(nvim -c PlugInstall) Ref: https://stackoverflow.com/a/5703164/265508
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

" }

" Plugin Config {
" copilot.vim {
" Disable/enable per filetype
      "\ '*': v:false, # global toggle, all on or all off.
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'txt': v:false,
      \ 'markdown': v:false,
      \ 'sh': v:true,
      \ 'py': v:true,
      \ 'rb': v:true,
      \ }

" Remap from <tab> as this is used by snipmate.
" Reference: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
inoremap <silent><expr> <C-Space> copilot#Accept("")
let g:copilot_no_tab_map = 1
" }

" dark-notify {
:lua <<EOF
	require('dark_notify').run()
EOF
" }

" dash.vim {
nnoremap <Leader>d :DashWord<CR>
nnoremap <Leader>D :Dash<CR>
" }

" indent-blankline.nvim {
:lua <<EOF
require("indent_blankline").setup {
    use_treesitter = true,  -- use treesitter to calculate indentation.
    show_current_context = true,  -- highlight current indent block.
    show_current_context_start = true, -- underline first line of current indent block.
}
EOF
" }

" lualine.nvim {
:lua <<EOF
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

:lua <<EOF
	require("nvim-tree").setup {
		open_on_setup = true,
		open_on_setup_file = false,
		open_on_tab = true,
		filters = { custom = { "^.git$" } }
	}
EOF
" }

" nvim-treesitter {
:lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "lua", "ruby", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,
}
EOF
" }

" vim-startify {
"let g:startify_fortune_use_unicode = 1	" Draw fortune with Unicode instead of ASCII. Not needed with startify_custom_header.
"let g:startify_files_number = 15	" Nubmer of files to show.
" Bookmarks
let g:startify_bookmarks = [
	\ {'v': g:xdg_config_home . '/nvim/init.vim'},
	\ {'p': g:xdg_config_home . '/nvim/commons_plugin.vim'},
	\ {'c': g:xdg_config_home . '/nvim/commons.vim'},
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
" }

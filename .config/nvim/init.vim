" Erik Westrup's Neovim configuration.
" Modeline {
" vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
" 8 spaces for a tab render best as HTML.
" }

" Plugins: ~/.config/nvim/lua/plugins.lua

" Documentation {
" * https://learnxinyminutes.com/docs/lua/
" * https://neovim.io/doc/user/lua-guide.html
" }

" Profiling {
" $ nvim --startuptime /tmp/nvim.log
" $ nvim --startuptime /dev/stdout +qall
" Ref: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" Providers {
lua << EOF
-- The python provider (pythonx.vim) checker takes alomost 1 second on startup.
-- Do one of:
-- * Install neovim package in used version: $ pip install neovim, then
-- :checkhealth
-- * Disable the provider (not used by curret plugins anyways.)
-- Ref: https://www.reddit.com/r/neovim/comments/ksf0i4/slow_startup_time_when_opening_python_files_with/
vim.g.loaded_python3_provider = 0

-- Let's disable more that is not used to gain startup time.
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_provider_provider = 0
vim.g.loaded_node_provider = 0
EOF
" }

" Environment {
lua << EOF
vim.g.xdg_config_home = os.getenv("XDG_CONFIG_HOME") or "$HOME/.config"
--vim.g.xdg_state_home = os.getenv("XDG_STATE_HOME") or "$HOME/.local/state"
--vim.g.xdg_data_home = os.getenv("XDG_DATA_HOME") or "$HOME/.local/share"
EOF

" }

" Plugins {
lua << EOF
vim.g.ale_completion_enabled = 1	-- Must be set before ALE is loaded.
require('plugins')
EOF
" }

" Commands {
lua << EOF
vim.api.nvim_create_user_command('Wsudo', 'silent write !sudo tee % > /dev/null', {force = true, desc = "Write with extended privileges."})
-- Ref: https://stackoverflow.com/a/41003241/265508
vim.api.nvim_create_user_command('WipeReg', 'for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor', {force = true, desc = "Clear all registers."})
vim.api.nvim_create_user_command('Cdpwd', 'cd %:p:h', {force = true, desc = "Change to directory of current file."})
vim.api.nvim_create_user_command('Lcdpwd', 'lcd %:p:h', {force = true, desc = "Show the directory of current file."})
vim.api.nvim_create_user_command('Sortline', 'call setline(line("."),join(sort(split(getline("."))), " "))', {force = true, desc = "Sort words on the current line."})
vim.api.nvim_create_user_command('DisableFixers', 'execute "DisableStripWhitespaceOnSave" | execute "let g:ale_fix_on_save = 0"', {force = true, desc = "Disable all fixers. Good when editing non-owned code bases."})
EOF

lua << EOF
local function DebuggerClear()
	local current_buf = vim.fn.bufnr()
	vim.cmd("silent :bufdo exe 'g/^\\s*debugger\\s*$/d | update'")
	vim.cmd("execute 'buffer' " .. current_buf)
end

vim.api.nvim_create_user_command('DebuggerClear', DebuggerClear, {force = true, desc = "Clear all debugger statement lines in all open buffers."})
EOF

" }

" Formatting {
lua << EOF
vim.opt.linebreak = false	-- Wrap on 'breakat'-chars.
vim.opt.showbreak = '…'		-- Indicate wrapped lines.
vim.opt.smartindent = true	-- Indent smart on C-like files.
vim.opt.preserveindent = true	-- Try to preserve indent structure on changes of current line.
vim.opt.copyindent = true	-- Copy indentstructure from existing lines.

vim.opt.tabstop = 8			-- Let a tab be X spaces wide. 8 spaces for a tab render best as HTML on e.g. GithHub.
vim.opt.shiftwidth = 8			-- Tab width for auto indent and >> shifting.
vim.opt.matchpairs:append("<:>")	-- Also match <> with %.
vim.opt.formatoptions = "tcroqwnl"	-- How automatic formatting should happen.
EOF

" }

" General {
lua << EOF
vim.opt.nrformats = {'alpha' , 'octal' , 'hex' } -- What to increment/decrement with ^A and ^X.
vim.opt.tabpagemax = 100		-- Upper limit on number of tabs.
vim.opt.hidden = true			-- Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
vim.opt.undofile = true			-- Save undo to file in undodir.
vim.opt.undolevels = 2048		-- Levels of undo to keep in memory.
vim.opt.timeoutlen = 700		-- Timout (ms) for mappings and keycodes. Make it a bit snappier.
vim.opt.shortmess = "filmnrxtToOA"	-- Abbreviate messages. 'A' disables the attention prompt when editing a file that is already open (beware: https://superuser.com/a/1065503)
EOF
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
lua << EOF
vim.keymap.set('n', '<Leader>v', ':source $MYVIMRC<CR>', { silent = true, desc = 'Source init.vim.' })
vim.keymap.set('n', '<Leader>V', ':tabe $MYVIMRC<CR>', { silent = true, desc = 'Edit init.vim.' })
vim.keymap.set('n', '<C-\\>', ':tab split<CR>:exec("tag ".expand("<cword>"))<CR>', { silent = true, desc = 'Open tags definition in a new tab.' })
vim.keymap.set('n', 'g^t', ':tabfirst<CR>', { silent = true, desc = 'Go to the first tab.' })
vim.keymap.set('n', 'g$t', ':tablast<CR>', { silent = true, desc = 'Go to the last tab.' })
vim.keymap.set('n', 'Yf', ':let @" = expand("%")<CR>', { silent = true, desc = 'Yank current file name.' })
vim.keymap.set('n', 'YF', ':let @" = expand("%:p")<CR>', { silent = true, desc = 'Yank current (fully expanded) file name.' })
vim.keymap.set('n', 'gV', '`[v`]', { silent = true, desc = 'Visually select the text that was last edited/pasted' })
vim.keymap.set('c', 'w\\', ':lua vim.api.nvim_err_writeln("Using a Swedish keyboard?")<CR>', { silent = true, desc = "Prevent saving buffer to a file '\'." })


-- Toggles:
vim.keymap.set('n', '<Leader>w', ':set wrap! wrap?<CR>', { silent = true, desc = 'Toggle line wrapping.' })
vim.keymap.set('n', '<Leader>`', ':set list!<CR>', { silent = true, desc = 'Toggle listing of characters. See listchars.' })
vim.keymap.set('n', '<Leader>l', ':set relativenumber!<CR>', { silent = true, desc = 'Toggle :number between absolute and line relative' })
vim.keymap.set('n', '<ESC>p', ':set paste! paste?<CR>', { silent = true, desc = 'Toggle \'paste\' for sane pasting.' })
vim.keymap.set('n', '<Leader>p', ':set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>', { silent = true, desc = 'Paste on line after in paste-mode from register "*.' })
vim.keymap.set('n', '<Leader>P', ':set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>', { silent = true, desc = 'Paste on line before in paste-mode from register "*.' })


-- Complement 'gf'
vim.keymap.set('n', 'gfs', ':wincmd f<CR>', { silent = true, desc = 'Open path under cursor in a split.' })
vim.keymap.set('n', 'gfv', ':vertical wincmd f<CR>', { silent = true, desc = 'Open path under cursor in a vertical split.' })
vim.keymap.set('n', 'gft', ':tab wincmd f<CR>', { silent = true, desc = 'Open path under cursor in a tab.' })

-- (Ctrl+/ => ^_). Note: neovim has <c-l> doing this be default now. https://neovim.io/doc/user/vim_diff.html#nvim-features-new
--vim.keymap.set('n', '<C-_>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search matches highlighting.' })

-- NOTE replaced with tickets.vim
--vim.keymap.set('n', '<Leader>s', ':mksession! <bar> echo "Session saved"<CR>', { silent = true, desc = 'Save (force) current session.' })
--vim.keymap.set('n', '<Leader>o', ':source Session.vim <bar> echo "Session loaded"<CR>', { silent = true, desc = 'Save (force) current session.' })

--vim.keymap.set('n', 'n', 'nzz', { silent = true, desc = 'Next search result (with recentered window)' })
--vim.keymap.set('n', 'N', 'Nzz', { silent = true, desc = 'Previous search result (with recentered window)' })

-- TabWinAdjustSplit {
local function TabWinAdjustSplit()
	local current_tab = vim.fn.tabpagenr()
	vim.cmd("tabdo wincmd =")
	vim.cmd("tabnext" .. current_tab)
end
vim.keymap.set('n', '<Leader>=', TabWinAdjustSplit, { silent = true, desc = 'Ctrl+w+= in all tabs: adjust window splits equally in all tabs.' })
-- }

-- ToggleSpell {
-- Set language completely in the local buffer.
function ToggleSpell(lang)
	if not vim.b.old_spelllang then
		vim.b.old_spellfile = vim.o.spellfile
		vim.b.old_dictionary = vim.o.dictionary
		vim.b.old_thesaurus = vim.o.thesaurus
		vim.b.old_spelllang = vim.o.spelllang
	end

	local new_mode = ""
	if not vim.o.spell or lang ~= vim.o.spelllang then
		new_mode = "spell, " .. lang

		vim.opt_local.spell = true
		vim.opt_local.spelllang = lang
		vim.opt_local.spellfile = vim.fn.stdpath('config') .. '/spell/' .. vim.fn.matchstr(lang, '[a-zA-Z][a-zA-Z]') .. '.' .. vim.o.encoding .. '.add'
		vim.opt_local.dictionary = vim.fn.stdpath('config') .. '/spell/' .. lang .. '.' .. vim.o.encoding .. '.dic'
		vim.opt_local.thesaurus = vim.fn.stdpath('config') .. '/thesaurus/' .. lang .. '.txt'
	else
		new_mode = "nospell"

		vim.opt_local.spell = false
		vim.opt_local.spelllang = vim.b.old_spelllang
		vim.opt_local.spellfile = vim.b.old_spellfile
		vim.opt_local.dictionary = vim.b.old_dictionary
		vim.opt_local.thesaurus = vim.b.old_thesaurus
	end
	return new_mode
end
vim.keymap.set('n', '<F6>', ':lua print(ToggleSpell("en_us"))<CR>', { silent = true, desc = 'Toggle English spell.' })
vim.keymap.set('n', '<F7>', ':lua print(ToggleSpell("sv"))<CR>', { silent = true, desc = 'Toggle Swedish spell.' })
vim.keymap.set('n', '<F8>', ':lua print(ToggleSpell("de"))<CR>', { silent = true, desc = 'Toggle German spell.' })
-- }

-- ToggleBackgroundMode {
function ToggleBackgroundMode()
	local bg_new = vim.o.background == "light" and 'dark' or 'light'
	vim.opt.background = bg_new
	return bg_new
end
vim.keymap.set('n', '<F5>', ':lua print(ToggleBackgroundMode())', { silent = true, desc = 'Toggle between light and dark background mode.' })
-- }
EOF
" }

" Searching {
lua << EOF
vim.opt.ignorecase = true	-- Case insensitive search.
vim.opt.smartcase = true	-- Smart case search.
vim.opt.wrapscan = false	-- Don't wrap search around file.
EOF
" }

" Spelling {
lua << EOF
vim.opt.spelllang = 'en_us'		-- Languages to do spell checking for.
vim.opt.spellsuggest = 'best,10'	-- Limit spell suggestions.


-- Set spellfile dynamically.
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/' .. vim.fn.matchstr(vim.o.spelllang, '[a-zA-Z][a-zA-Z]') .. '.' .. vim.o.encoding .. '.add'
-- Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
vim.opt.thesaurus = vim.fn.stdpath('config') .. '/thesaurus/' .. vim.fn.matchstr(vim.o.spelllang, '[a-zA-Z][a-zA-Z]') .. '.txt'
EOF
" }

" UI {
lua << EOF
-- Ignore if don't exist. This is the case when $(vim -c PlugInstall) the first time. Ref: https://stackoverflow.com/a/5703164/265508
vim.cmd('silent! colorscheme solarized')
vim.opt.background = 'light' -- Be light (most likely right) be default as dark-notify toggles ugly otherwise.

-- Adjust colors to this background. NOTE replaced by dark-notify.
--local solarized_status = vim.g.xdg_state_home .. "/solarizedtoggle/status"
--if vim.fn.filereadable(solarized_status) == 1 then
--	vim.opt.background = vim.fn.readfile(solarized_status)[1]
--else
--	-- Lighter bg during night.
--	-- Source:  http://benjamintan.io/blog/2014/04/10/switch-solarized-light-slash-dark-depending-on-the-time-of-day/
--	local hour = tonumber(vim.fn.strftime("%H"))
--	if 7 <= hour and hour < 18 then
--		vim.opt.background = 'light'
--	else
--		vim.opt.background = 'dark'
--	end
--end


vim.opt.termguicolors = true	-- Enable 24-bit RGB. Required by NeoSolarized.
vim.opt.mouse = 'a'		-- Enable mouse in all modes.
vim.opt.title = true		-- Show title in console title bar.
vim.opt.number = true		-- Show line numbers.
--vim.opt.relativenumber = true	-- Show relative line numbers.
vim.opt.showmatch = true	-- Shortly jump to a matching bracket when match.
vim.opt.cursorline = true	-- Highlight the current line.
vim.opt.wildignorecase = true	-- Case insensitive filename completion.
vim.opt.scrolljump = 5		-- Lines to scroll when cursor leaves screen.
vim.opt.scrolloff = 3		-- Minimum lines to keep above and below cursor.
vim.opt.splitbelow = true	-- Open horizontal split below.
vim.opt.splitright = true	-- Open vertical split to the right.

-- Characters to use for :list.
vim.opt.listchars= { eol = '$', space = '·', tab = '>-', trail = '¬', extends = '>', precedes = '<', nbsp = '.' }
EOF


" }

" TODO move this to the 'config' function inside the packer use() method, as  nvim-surround is already configured
" Plugin Config {
" ALE {
lua << EOF
-- Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
-- Disabled linters:
		-- ['sql'] = {'sqls'},
vim.g.ale_linters = {
	['go'] = {'gopls'},
	['javascript'] = {'eslint'},
	['lua'] = {'luacheck'},
	['json'] = {'jsonls'},
	['python'] = {'pyright', 'flake8'},
	['ruby'] = {'solargraph', 'ruby'},
	['sh'] = {'language_server'},
	['tex'] = {'texlab'},
	['vim'] = {'vimls'},
	}


-- Disabled fixers:
-- - *: 'trim_whitespace' & 'remove_trailing_lines' (overlaps with the functionally already provided by vim-better-whitespace)
-- - python: autoimport (messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59)
-- - markdown: prettier (converts * to - in lists)
vim.g.ale_fixers = {
	 ['css'] = {'prettier'},
	 ['javascript'] = {'prettier', 'eslint'},
	 ['json'] = {'prettier'},
	 ['lua'] = {'stylua'},
	 ['python'] = {'autoflake', 'black', 'isort'},
	 ['ruby'] = {'rubocop'},
	 ['scss'] = {'prettier'},
	 ['typescript'] = {'prettier'},
	 ['yaml'] = {'prettier'},
	}
vim.g.ale_fix_on_save = 1

-- Completion {
vim.g.ale_completion_autoimport = 1
-- Trigger on ^x^o
vim.opt.omnifunc = 'ale#completion#OmniFunc'
-- 'longest' seems to tirgger a variation of :h ale-completion-completeopt-bug
-- See https://github.com/dense-analysis/ale/issues/1700#issuecomment-991643960
vim.opt.completeopt = {'menu', 'preview'}
-- }

-- Mappings {
-- See :help ale-commands
-- Make similar keybindings to https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
vim.keymap.set('n', 'gd', '<Plug>(ale_go_to_definition)', { silent = true, desc = 'ALE: go to definition.' })
vim.keymap.set('n', 'gr', '<Plug>(ale_find_references)', { silent = true, desc = 'ALE: find references.' })
vim.keymap.set('n', 'K', '<Plug>(ale_hover)', { silent = true, desc = 'ALE: hover.' })
vim.keymap.set('n', '<Space>rn', '<Plug>(ale_rename)', { silent = true, desc = 'ALE: rename.' })

-- Navigate between errors
vim.keymap.set('n', '<C-k>', '<Plug>(ale_previous_wrap)', { silent = true, desc = 'ALE: navigate to previous error.' })
vim.keymap.set('n', '<C-j>', '<Plug>(ale_next_wrap)', { silent = true, desc = 'ALE: navigate to next error.' })
-- }

-- Toggle command for fixers
-- Ref: https://github.com/dense-analysis/ale/issues/1353#issuecomment-424677810
vim.api.nvim_create_user_command('ALEToggleFixer', 'execute "let g:ale_fix_on_save = get(g:, \'ale_fix_on_save\', 0) ? 0 : 1"', {force = true, desc = "ALE: toggle ale_fix_on_save"})
EOF
" }

"" copilot.vim {
"lua << EOF
"-- Disable/enable per filetype
"vim.g.copilot_filetypes = {
"	['*'] = false, -- Setting to false disable for all types; can't be overriden.
"        ['txt'] = false,
"        ['markdown'] = false,
"        ['sh'] = true,
"        ['py'] = true,
"        ['rb'] = true,
"	}
"
"-- Remap from <tab> as this is used by snipmate.
"-- Ref: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
"vim.keymap.set('i', '<C-Space>', 'copilot#Accept("")', { silent = true, expr = true, desc = 'Source init.vim.' })
"vim.g.copilot_no_tab_map = 1
"EOF
"" }

"" dark-notify {
lua <<EOF
	require('dark_notify').run({
		onchange = function(mode)
			-- Init hlargs.nvim.
			-- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
			-- Ref: https://github.com/cormacrelf/dark-notify/issues/8
			require('hlargs').setup()
	    end
})
-- Override mapping from above to work without <CR>.
vim.keymap.set('n', '<F5>', ":lua require('dark_notify').toggle()<CR>", { silent = true, desc = 'Toggle dark/light mode.' })
EOF
"" }

"" dash.vim {
""nnoremap <Leader>d :DashWord<CR>
""nnoremap <Leader>D :Dash<CR>
""lua <<EOF
""require('dash').setup({
""  -- your config here
""})
""EOF
"" }

" diffview.nvim {
lua <<EOF
vim.api.nvim_create_user_command('Gdiff', ':DiffviewFileHistory %', {force = true, desc = "View diff file history of current buffer."})
EOF
" }

" fzf.vim {
lua << EOF
-- Stolen from my friend https://github.com/erikagnvall/dotfiles/blob/master/vim/init.vim
-- Comment must be on line of its own...
-- Search for files in given path.
vim.keymap.set('n', '<Leader>f', ':FZF<space>', { silent = true, desc = 'FZF: search for files in given path.' })
-- Sublime-like shortcut 'go to file' ctrl+p.
vim.keymap.set('n', '<C-p>', ':Files<CR>', { silent = true, desc = 'FZF: search for files starting at current directory.' })
vim.keymap.set('n', '<Leader>c', ':Commands<CR>', { silent = true, desc = 'FZF: search commands.' })
vim.keymap.set('n', '<Leader>T', ':Tags<CR>', { silent = true, desc = 'FZF: search in tags file' })
vim.keymap.set('n', '<Leader>b', ':Buffers<CR>', { silent = true, desc = 'FZF: search open buffers.' })
-- Ref: https://medium.com/@paulodiovani/vim-buffers-windows-and-tabs-an-overview-8e2a57c57afa).
vim.keymap.set('n', '<Leader>t', ':Windows<CR>', { silent = true, desc = 'FZF: search open tabs.' })
vim.keymap.set('n', '<Leader>H', ':History<CR>', { silent = true, desc = 'FZF: search history of opended files' })
vim.keymap.set('n', '<Leader>m', ':Maps<CR>', { silent = true, desc = 'FZF: search mappings.' })
vim.keymap.set('n', '<Leader>g', ':Rg<CR>', { silent = true, desc = 'FZF: search with rg (aka live grep).' })
EOF

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
"" }

" hlargs.vim {
" Due to a bug when dark-notify is enabled, do the hlargs init is done in the  dark-notify callback.
" Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
"lua <<EOF
"require('hlargs').setup()
"EOF
" }

"" indent-blankline.nvim {
""lua <<EOF
""require("indent_blankline").setup {
""    use_treesitter = true,  -- use treesitter to calculate indentation.
""    show_current_context = true,  -- highlight current indent block.
""    show_current_context_start = true, -- underline first line of current indent block.
""}
""EOF
"" }

"" local_vimrc {
""" File names to recognize.
""let g:local_vimrc = ['.vimlocal', '_vimrc_local.vim']
""" Paths to not ask before loading.
""if exists("lh#local_vimrc")
""        call lh#local_vimrc#munge('whitelist', $HOME.'/src/github.com/erikw')
""end
"" }

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
  inactive_sections = {
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
lua <<EOF
-- Align line-wise comment delimiters flush left instead of following code indentation
vim.g.NERDDefaultAlign = 'left'
EOF
" }

" nvim-autopairs {
lua << EOF
local npairs = require("nvim-autopairs")
npairs.setup({
	check_ts = true, --  Use treesitter to check for a pair
	map_c_h = true, -- Map the <C-h> key to delete a pair
	map_c_w = true, -- map <c-w> to delete a pair if possible
})

-- Ref: https://github.com/windwp/nvim-autopairs/wiki/Endwise
-- Could use https://github.com/RRethy/nvim-treesitter-endwise instead
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
EOF
" }

"" nvim-cmp {
""set completeopt=menu,menuone,noselect
"
""" Lua Setup {
"" Copy and paste latest setup from https://github.com/hrsh7th/nvim-cmp#setup
"" Not possible to comment out as lua code is interpreted still somehow.
"" The essential custom part is kept here:
"  "-- Setup lspconfig.
"  "require('lspconfig')['bashls'].setup {
"    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
"    "}
"  "require('lspconfig')['jsonls'].setup {
"    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
"    "}
"  "require('lspconfig')['pyright'].setup {
"    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
"    "}
"  "require('lspconfig')['solargraph'].setup {
"    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
"    "}
"  "require('lspconfig')['vimls'].setup {
"    "capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
"  "}
"
"" INSERT CONFIG FROM README HERE.
""" }
"" }

"" nvim-dap {
"" Suggested mappings from *dap-mappings* https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt
""nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
""nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
""nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
""nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
""nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
""nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
""nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
""nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
""nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
"" }

"" nvim-dap-ruby {
""lua require('dap-ruby').setup()
"" }

"" nvim-dap-ui {
""lua require("dapui").setup()
"" }

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

"" nvim-cursorline {
""lua << EOF
""require('nvim-cursorline').setup { }
""EOF
"" }

" nvim-peekup {
lua <<EOF
-- Paste selection to register ", so that it can be pasted directly with 'p'.
-- Ref: https://github.com/gennaro-tedesco/nvim-peekup/issues/27
require('nvim-peekup.config').on_keystroke["paste_reg"] = '"'
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
lua <<EOF
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle file explorer tree. When open_on_tab=true, syncs toggle globally acoss tabs.' })

require("nvim-tree").setup {
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
lua << EOF
vim.keymap.set('n', '<a', ':SidewaysLeft<CR>', { silent = true, desc = 'Move function argument to the left.' })
vim.keymap.set('n', '>a', ':SidewaysRight<CR>', { silent = true, desc = 'Move function argument to the right.' })
EOF
" }

" tickets.vim {
lua << EOF
-- Alternatives that also support per-branch saving to some extent:
-- * https://piet.me/branch-based-sessions-in-vim/
-- * https://github.com/dhruvasagar/vim-prosession
-- * https://github.com/wting/gitsessions.vim
-- * https://github.com/rmagatti/auto-session

vim.g.auto_ticket = 0  -- Automatically load tickets when starting vim without file arguments.

-- Save current session.
vim.keymap.set('n', '<C-M-s>', ':execute ":SaveSession" <bar> echo "Session saved"<CR>', { silent = true, desc = 'Save current tickets.vim session.' })
vim.keymap.set('n', '<C-M-o>', ':execute ":OpenSession" <bar> echo "Session loaded"<CR>', { silent = true, desc = 'Open saved tickets.vim session.' })
EOF
" }

" urlview.nvim {
lua << EOF
require("urlview").setup({
})

vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
EOF
" }

" vim-better-whitespace {
lua << EOF
vim.g.strip_whitelines_at_eof = 1	-- Also strip empty lines at end of file on save.
vim.g.show_spaces_that_precede_tabs = 1	-- Highlight spaces that happens before tab.
vim.g.strip_whitespace_on_save  =  1	-- Activate by default.
vim.g.strip_whitespace_confirm = 0	-- Don't ask for permission.

-- Filetypes to ignore even when strip_whitespace_on_save=1
--vim.g.better_whitespace_filetypes_blacklist = ['<filetype1>', '<filetype2>', '<etc>']

vim.api.nvim_create_user_command('Ws', ":execute 'StripWhitespace' | update", {force = true, desc = ":w with StripWhitespace."})
vim.api.nvim_create_user_command('Wqs', ":execute 'StripWhitespace' | wq", {force = true, desc = ":wq with StripWhitespace."})
vim.api.nvim_create_user_command('Wqas', ":execute 'bufdo StripWhitespace' | wqa", {force = true, desc = ":wqa with StripWhitespace."})
EOF
" }

"" vim-gist {
""let g:gist_detect_filetype = 1				" Detect filetype from name.
""let g:gist_show_privates = 1				" Let Gist -l show private gists.
""let g:gist_private = 1					" Make private the default for new Gists.
""let g:gist_open_browser_after_post = 1			" Open in browser after post.
"""let g:gist_clip_command = 'xclip -selection clipboard'	" Copy command.
"""let g:gist_browser_command = 'w3m %URL%'		" Browser to use.
""let g:gist_browser_command = 'firefox  %URL%'		" Browser to use.
"" }

" vim-gitgutter {
lua << EOF
vim.opt.updatetime = 100	-- Speedier update of file status.
EOF
" }

"" vim-illuminate {
""lua << EOF
""require('illuminate').configure()
""EOF
"" }

"" vim-instant-markdown {
"let g:instant_markdown_autostart=1
"
"" Blocklist certain paths for previewing files (recursively).
"" See https://github.com/instant-markdown/vim-instant-markdown/issues/198
"" Did not work to put this in .vimlocal file, as it's loaded too late.
"augroup InstantMarkdownGroup
"  autocmd!
"  " [1-9]*.md - PR body by gh(1) have file names with this pattern.
"  au! BufReadPre,BufNewFile,BufEnter,BufFilePre ~/src/github.com/erikw/hackerrank-solutions/*.md,~/src/github.com/erikw/leetcode-solutions/*.md,[1-9]*.md let g:instant_markdown_autostart=0
"augroup END
"" }

"" vim-markdown {
"let g:vim_markdown_folding_disabled = 1		" No fold by default
"let g:vim_markdown_toc_autofit = 1		" Make :Toc smaller
"let g:vim_markdown_follow_anchor = 1		" Let ge follow #anchors
"let g:vim_markdown_new_list_item_indent = 2	" Bullent space indents.
"" }

" vim-startify {
lua << EOF
--vim.g.startify_fortune_use_unicode = 1	-- Draw fortune with Unicode instead of ASCII. Not needed with startify_custom_header.
--vim.g.startify_files_number = 15		-- Nubmer of files to show.

-- Bookmarks
vim.g.startify_bookmarks = {
	 {['v'] = vim.g.xdg_config_home .. '/nvim/init.vim'},
	 {['p'] = vim.g.xdg_config_home .. '/nvim/lua/plugins.lua'},
	 vim.g.xdg_config_home .. '/shell/commons',
	 vim.g.xdg_config_home .. '/shell/aliases',
	}

local nver = vim.version()
local semnver = nver.major .. '.' .. nver.minor .. '.' .. nver.patch
local ascii = {
   '    ##############..... ##############',
   '    ##############......##############',
   '      ##########..........##########',
   '      ##########........##########',
   '      ##########.......##########',
   '      ##########.....##########..',
   '      ##########....##########.....',
   '    ..##########..##########.........',
   '  ....##########.#########.............',
   '    ..##################.............',
   '      ################.............',
   '      ##############.............',
   '      ############.............',
   '      ##########.............',
   '      ########.............',
   '      ######    .........',
   '                  .....',
   '                    .',
   '    Neovim v' .. semnver
  }
vim.g.startify_custom_header = ascii
EOF
" }

" vista.vim {
lua << EOF
vim.keymap.set('n', '<F3>', ':Vista!! <CR>', { silent = true, desc = 'Toggle Vista tag sidewindow.' })
vim.g.vista_default_executive = 'ale'	-- Default executive.
vim.g.vista_sidebar_width = 50		-- Window width.
EOF
" }

"" which-key.nvim {
""lua << EOF
""  require("which-key").setup {
""  }
""EOF
"" }

" undotree {
lua << EOF
vim.keymap.set('n', '<F4>', ':UndotreeToggle<CR>', { silent = true, desc = 'Toggle Undotree side pane.' })
vim.g.undotree_WindowLayout = 2		-- Set style to have diff window below.
vim.g.undotree_SetFocusWhenToggle = 1	-- Put cursor in undo window on open.
EOF
" }
" }

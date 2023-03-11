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

-- -- ToggleBackgroundMode {
-- NOPE replaced by dark-notify mapping.
-- function ToggleBackgroundMode()
--	local bg_new = vim.o.background == "light" and 'dark' or 'light'
--	vim.opt.background = bg_new
--	return bg_new
-- end
-- vim.keymap.set('n', '<F5>', ':lua print(ToggleBackgroundMode())', { silent = true, desc = 'Toggle between light and dark background mode.' })
-- -- }
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

" vim-gitgutter {
lua << EOF
vim.opt.updatetime = 100	-- Speedier update of file status.
EOF
" }

" vim-illuminate {
"lua << EOF
"require('illuminate').configure()
"EOF
" }

" vim-instant-markdown {
lua << EOF
vim.g.instant_markdown_autostart = 1

-- Blocklist certain paths for previewing files (recursively).
-- See https://github.com/instant-markdown/vim-instant-markdown/issues/198
-- [1-9]*.md - PR body by gh(1) have file names with this pattern.
local augroup_imark= vim.api.nvim_create_augroup('InstantMarkdownGroup', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile', 'BufEnter', 'BufFilePre' }, {
  pattern = '*/src/github.com/erikw/hackerrank-solutions/*.md,*/src/github.com/erikw/leetcode-solutions/*.md,[1-9]*.md',
  group = augroup_imark,
  command = 'let g:instant_markdown_autostart=0',
})
EOF
" }

" vim-markdown {
lua << EOF
vim.g.vim_markdown_folding_disabled = 1		-- No fold by default
vim.g.vim_markdown_toc_autofit = 1		-- Make :Toc smaller
vim.g.vim_markdown_follow_anchor = 1		-- Let ge follow #anchors
vim.g.vim_markdown_new_list_item_indent = 2	-- Bullent space indents.
EOF
" }

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

" which-key.nvim {
"lua << EOF
"  require("which-key").setup {
"  }
"EOF
" }

" undotree {
lua << EOF
vim.keymap.set('n', '<F4>', ':UndotreeToggle<CR>', { silent = true, desc = 'Toggle Undotree side pane.' })
vim.g.undotree_WindowLayout = 2		-- Set style to have diff window below.
vim.g.undotree_SetFocusWhenToggle = 1	-- Put cursor in undo window on open.
EOF
" }
" }

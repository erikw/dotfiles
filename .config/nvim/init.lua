-- Erik Westrup's Neovim configuration.
-- Plugins: ~/.config/nvim/lua/plugins.lua
-- Modeline {
-- vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=8 shiftwidth=8:
-- 8 spaces for a tab render best as HTML.
-- }

-- Documentation {
-- * https://learnxinyminutes.com/docs/lua/
-- * https://neovim.io/doc/user/lua-guide.html
-- }

-- Profiling {
-- $ nvim --startuptime /tmp/nvim.log
-- $ nvim --startuptime /dev/stdout +qall
-- Ref: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
-- }

-- Providers {
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
-- }

-- Environment {
vim.g.xdg_config_home = os.getenv("XDG_CONFIG_HOME") or "$HOME/.config"
--vim.g.xdg_state_home = os.getenv("XDG_STATE_HOME") or "$HOME/.local/state"
--vim.g.xdg_data_home = os.getenv("XDG_DATA_HOME") or "$HOME/.local/share"
-- }

-- Plugins {
require("plugins")
-- }

-- Commands {
vim.api.nvim_create_user_command(
	"Wsudo",
	"silent write !sudo tee % > /dev/null",
	{ force = true, desc = "Write with extended privileges." }
)
-- Ref: https://stackoverflow.com/a/41003241/265508
vim.api.nvim_create_user_command(
	"WipeReg",
	"for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor",
	{ force = true, desc = "Clear all registers." }
)
vim.api.nvim_create_user_command("Cdpwd", "cd %:p:h", { force = true, desc = "Change to directory of current file." })
vim.api.nvim_create_user_command("Lcdpwd", "lcd %:p:h", { force = true, desc = "Show the directory of current file." })
vim.api.nvim_create_user_command(
	"Sortline",
	'call setline(line("."),join(sort(split(getline("."))), " "))',
	{ force = true, desc = "Sort words on the current line." }
)
vim.api.nvim_create_user_command(
	"DisableFixers",
	'execute "DisableStripWhitespaceOnSave" | execute "let g:ale_fix_on_save = 0"',
	{ force = true, desc = "Disable all fixers. Good when editing non-owned code bases." }
)

local function DebuggerClear()
	local current_buf = vim.fn.bufnr()
	vim.cmd("silent :bufdo exe 'g/^\\s*debugger\\s*$/d | update'")
	vim.cmd("execute 'buffer' " .. current_buf)
end

vim.api.nvim_create_user_command(
	"DebuggerClear",
	DebuggerClear,
	{ force = true, desc = "Clear all debugger statement lines in all open buffers." }
)

-- }

-- Formatting {
vim.opt.linebreak = false -- Wrap on 'breakat'-chars.
vim.opt.showbreak = "…" -- Indicate wrapped lines.
vim.opt.smartindent = true -- Indent smart on C-like files.
vim.opt.preserveindent = true -- Try to preserve indent structure on changes of current line.
vim.opt.copyindent = true -- Copy indentstructure from existing lines.

vim.opt.tabstop = 8 -- Let a tab be X spaces wide. 8 spaces for a tab render best as HTML on e.g. GithHub.
vim.opt.shiftwidth = 8 -- Tab width for auto indent and >> shifting.
vim.opt.matchpairs:append("<:>") -- Also match <> with %.
vim.opt.formatoptions = "tcroqwnl" -- How automatic formatting should happen.
-- }

-- General {
vim.opt.nrformats = { "alpha", "octal", "hex" } -- What to increment/decrement with ^A and ^X.
vim.opt.tabpagemax = 100 -- Upper limit on number of tabs.
vim.opt.hidden = true -- Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
vim.opt.undofile = true -- Save undo to file in undodir.
vim.opt.undolevels = 2048 -- Levels of undo to keep in memory.
vim.opt.timeoutlen = 700 -- Timout (ms) for mappings and keycodes. Make it a bit snappier.
vim.opt.shortmess = "filmnrxtToOA" -- Abbreviate messages. 'A' disables the attention prompt when editing a file that is already open (beware: https://superuser.com/a/1065503)
-- }

-- Mappings {
vim.keymap.set("n", "<Leader>v", ":luafile $MYVIMRC<CR>", { silent = true, desc = "Source init.lua." })
vim.keymap.set("n", "<Leader>V", ":tabe $MYVIMRC<CR>", { silent = true, desc = "Edit init.lua." })
vim.keymap.set(
	"n",
	"<C-\\>",
	':tab split<CR>:exec("tag ".expand("<cword>"))<CR>',
	{ silent = true, desc = "Open tags definition in a new tab." }
)
vim.keymap.set("n", "g^t", ":tabfirst<CR>", { silent = true, desc = "Go to the first tab." })
vim.keymap.set("n", "g$t", ":tablast<CR>", { silent = true, desc = "Go to the last tab." })
vim.keymap.set("n", "Yf", ':let @" = expand("%")<CR>', { silent = true, desc = "Yank current file name." })
vim.keymap.set(
	"n",
	"YF",
	':let @" = expand("%:p")<CR>',
	{ silent = true, desc = "Yank current (fully expanded) file name." }
)
vim.keymap.set("n", "gV", "`[v`]", { silent = true, desc = "Visually select the text that was last edited/pasted" })
vim.keymap.set(
	"c",
	"w\\",
	':lua vim.api.nvim_err_writeln("Using a Swedish keyboard?")<CR>',
	{ silent = true, desc = "Prevent saving buffer to a file ''." }
)

-- Toggles:
vim.keymap.set("n", "<Leader>w", ":set wrap! wrap?<CR>", { silent = true, desc = "Toggle line wrapping." })
vim.keymap.set(
	"n",
	"<Leader>`",
	":set list!<CR>",
	{ silent = true, desc = "Toggle listing of characters. See listchars." }
)
vim.keymap.set(
	"n",
	"<Leader>l",
	":set relativenumber!<CR>",
	{ silent = true, desc = "Toggle :number between absolute and line relative" }
)
vim.keymap.set("n", "<ESC>p", ":set paste! paste?<CR>", { silent = true, desc = "Toggle 'paste' for sane pasting." })
vim.keymap.set(
	"n",
	"<Leader>p",
	':set paste<CR>o<ESC>:normal "*p<CR>:set nopaste<CR>',
	{ silent = true, desc = 'Paste on line after in paste-mode from register "*.' }
)
vim.keymap.set(
	"n",
	"<Leader>P",
	':set paste<CR>O<ESC>:normal "*P<CR>:set nopaste<CR>',
	{ silent = true, desc = 'Paste on line before in paste-mode from register "*.' }
)

-- Complement 'gf'
vim.keymap.set("n", "gfs", ":wincmd f<CR>", { silent = true, desc = "Open path under cursor in a split." })
vim.keymap.set(
	"n",
	"gfv",
	":vertical wincmd f<CR>",
	{ silent = true, desc = "Open path under cursor in a vertical split." }
)
vim.keymap.set("n", "gft", ":tab wincmd f<CR>", { silent = true, desc = "Open path under cursor in a tab." })

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
vim.keymap.set(
	"n",
	"<Leader>=",
	TabWinAdjustSplit,
	{ silent = true, desc = "Ctrl+w+= in all tabs: adjust window splits equally in all tabs." }
)
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
		vim.opt_local.spellfile = vim.fn.stdpath("config")
			.. "/spell/"
			.. vim.fn.matchstr(lang, "[a-zA-Z][a-zA-Z]")
			.. "."
			.. vim.o.encoding
			.. ".add"
		vim.opt_local.dictionary = vim.fn.stdpath("config") .. "/spell/" .. lang .. "." .. vim.o.encoding .. ".dic"
		vim.opt_local.thesaurus = vim.fn.stdpath("config") .. "/thesaurus/" .. lang .. ".txt"
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
vim.keymap.set("n", "<F6>", ':lua print(ToggleSpell("en_us"))<CR>', { silent = true, desc = "Toggle English spell." })
vim.keymap.set("n", "<F7>", ':lua print(ToggleSpell("sv"))<CR>', { silent = true, desc = "Toggle Swedish spell." })
vim.keymap.set("n", "<F8>", ':lua print(ToggleSpell("de"))<CR>', { silent = true, desc = "Toggle German spell." })
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
-- }

-- Searching {
vim.opt.ignorecase = true -- Case insensitive search.
vim.opt.smartcase = true -- Smart case search.
vim.opt.wrapscan = false -- Don't wrap search around file.
-- }

-- Spelling {
vim.opt.spelllang = "en_us" -- Languages to do spell checking for.
vim.opt.spellsuggest = "best,10" -- Limit spell suggestions.

-- Set spellfile dynamically.
vim.opt.spellfile = vim.fn.stdpath("config")
	.. "/spell/"
	.. vim.fn.matchstr(vim.o.spelllang, "[a-zA-Z][a-zA-Z]")
	.. "."
	.. vim.o.encoding
	.. ".add"
-- Use a thesaurus file. Could load all, but that makes lookup slower. Instead let ToggleSpell() set per language.
vim.opt.thesaurus = vim.fn.stdpath("config")
	.. "/thesaurus/"
	.. vim.fn.matchstr(vim.o.spelllang, "[a-zA-Z][a-zA-Z]")
	.. ".txt"
-- }

-- UI {
-- Ignore if don't exist. This is the case when $(vim -c PlugInstall) the first time. Ref: https://stackoverflow.com/a/5703164/265508
vim.cmd("silent! colorscheme solarized")
vim.opt.background = "light" -- Be light (most likely right) be default as dark-notify toggles ugly otherwise.

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

vim.opt.termguicolors = true -- Enable 24-bit RGB. Required by NeoSolarized.
vim.opt.mouse = "a" -- Enable mouse in all modes.
vim.opt.title = true -- Show title in console title bar.
vim.opt.number = true -- Show line numbers.
--vim.opt.relativenumber = true	-- Show relative line numbers.
vim.opt.showmatch = true -- Shortly jump to a matching bracket when match.
vim.opt.cursorline = true -- Highlight the current line.
vim.opt.wildignorecase = true -- Case insensitive filename completion.
vim.opt.scrolljump = 5 -- Lines to scroll when cursor leaves screen.
vim.opt.scrolloff = 3 -- Minimum lines to keep above and below cursor.
vim.opt.splitbelow = true -- Open horizontal split below.
vim.opt.splitright = true -- Open vertical split to the right.

-- Characters to use for :list.
vim.opt.listchars = { eol = "$", space = "·", tab = ">-", trail = "¬", extends = ">", precedes = "<", nbsp = "." }
-- }

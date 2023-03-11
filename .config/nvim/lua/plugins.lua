-- Modeline {
-- vi: foldmarker={,} foldmethod=marker foldlevel=0:
-- }
-- TODO foldmarkers
-- init: ~/.config/nvim/init.lua

-- Bootstrap {
-- Bootstrapping of packer.nvim. Ref: https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()
-- }

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- General {
	--use('dhruvasagar/vim-table-mode')			-- Create ASCII tables
	--use('fidian/hexmode')						-- Open binary files as a HEX dump with :Hexmode
	--use('folke/which-key.nvim')				-- Show matching keybindings e.g. when tapping Leader.
	--use('godlygeek/tabular')					-- Create tables. Disabled: not used and have some startup time.
	--use('voldikss/vim-translator')			-- Async language translator.
	use("axieax/urlview.nvim") -- Open URLs in buffer.
	use("danro/rename.vim") -- Provides the :Rename command
	use("gennaro-tedesco/nvim-peekup") -- Register viewer and selector.
	use({ "instant-markdown/vim-instant-markdown", ft = "markdown", run = "yarn install" })
	use({ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } }) -- File explorer tree

	-- Work on surrond delimiters or its content. Like tpope/vim-surround but with TreeSitter.
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup()
		end,
	})
	use("mbbill/undotree") -- Navigate history in a sidebar. Replaces old 'mbbill/undotree'
	use("michaeljsmith/vim-indent-object") -- Operate on intendtation as text objects.
	use("ntpeters/vim-better-whitespace") -- Highlight and remove trailing whitespaces.
	use("phaazon/hop.nvim") -- Easy motion jumps in buffer.
	use("preservim/nerdcommenter") -- Comment source code.
	use("tpope/vim-capslock") -- Software CAPSLOCK with <C-g>c in insert mode.
	use("tpope/vim-characterize") -- 'ga' on steroid.
	use("tpope/vim-repeat") -- Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
	use("tpope/vim-speeddating") -- Increment dates with C-a.
	use("tpope/vim-unimpaired") -- Bracket mappings like [<space>
	-- " }

	-- Development {
	-- Development: General {
	-- AI powered code completion.
	--use({
	--    "github/copilot.vim",
	--    config = function()
	--        -- Disable/enable per filetype
	--        vim.g.copilot_filetypes = {
	--            ["*"] = false, -- Setting to false disable for all types; can't be overriden.
	--            ["txt"] = false,
	--            ["markdown"] = false,
	--            ["sh"] = true,
	--            ["py"] = true,
	--            ["rb"] = true,
	--        }

	--        -- Remap from <tab> as this is used by snipmate.
	--        -- Ref: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
	--        vim.keymap.set(
	--            "i",
	--            "<C-Space>",
	--            'copilot#Accept("")',
	--            { silent = true, expr = true, desc = "Source init.vim." }
	--        )
	--        vim.g.copilot_no_tab_map = 1
	--    end,
	--})

	--use('ibhagwan/fzf-lua' | use('mrjones2014/dash.nvim', { 'do': 'make install' } " Search dash.app from nvim. Currently broken: https://github.com/mrjones2014/dash.nvim/issues/137

	-- Search dash.app from nvim. Currently broken: https://github.com/mrjones2014/dash.nvim/issues/137
	--use({
	--    "mrjones2014/dash.nvim",
	--    run = "make install",
	--    requires = { "ibhagwan/fzf-lua" },
	--    config = function()
	--        require("dash").setup()
	--        vim.keymap.set("n", "<Leader>d", ":DashWord<CR>", { silent = true, desc = "Dash: lookup word." })
	--        vim.keymap.set("n", "<Leader>D", ":Dash<CR>", { silent = true, desc = "Dash" })
	--    end,
	--})

	--use('lukas-reineke/indent-blankline.nvim')	-- Indent vertical markers.
	--use('mfussenegger/nvim-dap')			-- Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA config is not working (freezes nvim).
	use("AndrewRadev/sideways.vim") -- Shift function arguments left and right.
	use("airblade/vim-gitgutter") -- Git modified status in sign column
	use("andymass/vim-matchup") -- Extend % matching.
	use("editorconfig/editorconfig-vim") -- Standard .editorconfig file in shared projects.
	use({ "preservim/vim-markdown", requires = { "godlygeek/tabular" } }) -- Markdown utilties like automatic list indention, TOC.
	use({ "m-demare/hlargs.nvim", requires = { "nvim-treesitter/nvim-treesitter" } }) -- Highlight usage of method arguments.
	use("nguyenvukhang/nvim-toggler") -- Toggle values like true/false with <leader>i.

	-- Show code coverage in sign column.
	use({
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("coverage").setup()
		end,
	})

	-- Better than fugative ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			vim.api.nvim_create_user_command(
				"Gdiff",
				":DiffviewFileHistory %",
				{ force = true, desc = "View diff file history of current buffer." }
			)
		end,
	})

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- NVim interface for tree-sitter (language parser).
	use("rgroli/other.nvim") -- Open related file like test.
	use("rhysd/conflict-marker.vim") -- Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
	use("ruanyl/vim-gh-line") -- Copy link to file on GitHub.
	use("superDross/ticket.vim") -- Manage vim Sessions per git branch.
	use("tpope/vim-fugitive") -- Git wrapper and shorthands.
	use("wellle/targets.vim") -- Extra text objects to operate on e.g. function arguments.
	use("windwp/nvim-autopairs") -- Autoclose brackets etc.
	-- " }

	-- Development: LSP/Completion {
	--use('neovim/nvim-lspconfig')			-- Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.
	--

	-- LSP linting engine.
	use({
		"dense-analysis/ale",
		config = function()
			-- Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
			-- Disabled linters:
			-- ['sql'] = {'sqls'},
			vim.g.ale_linters = {
				["go"] = { "gopls" },
				["javascript"] = { "eslint" },
				["lua"] = { "luacheck" },
				["json"] = { "jsonls" },
				["python"] = { "pyright", "flake8" },
				["ruby"] = { "solargraph", "ruby" },
				["sh"] = { "language_server" },
				["tex"] = { "texlab" },
				["vim"] = { "vimls" },
			}

			-- Disabled fixers:
			-- - *: 'trim_whitespace' & 'remove_trailing_lines' (overlaps with the functionally already provided by vim-better-whitespace)
			-- - python: autoimport (messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59)
			-- - markdown: prettier (converts * to - in lists)
			vim.g.ale_fixers = {
				["css"] = { "prettier" },
				["javascript"] = { "prettier", "eslint" },
				["json"] = { "prettier" },
				["lua"] = { "stylua" },
				["python"] = { "autoflake", "black", "isort" },
				["ruby"] = { "rubocop" },
				["scss"] = { "prettier" },
				["typescript"] = { "prettier" },
				["yaml"] = { "prettier" },
			}
			vim.g.ale_fix_on_save = 1

			-- Completion {
			vim.g.ale_completion_autoimport = 1
			-- Trigger on ^x^o
			vim.opt.omnifunc = "ale#completion#OmniFunc"
			-- 'longest' seems to tirgger a variation of :h ale-completion-completeopt-bug
			-- See https://github.com/dense-analysis/ale/issues/1700#issuecomment-991643960
			vim.opt.completeopt = { "menu", "preview" }
			-- }

			-- Mappings {
			-- See :help ale-commands
			-- Make similar keybindings to https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
			vim.keymap.set(
				"n",
				"gd",
				"<Plug>(ale_go_to_definition)",
				{ silent = true, desc = "ALE: go to definition." }
			)
			vim.keymap.set("n", "gr", "<Plug>(ale_find_references)", { silent = true, desc = "ALE: find references." })
			vim.keymap.set("n", "K", "<Plug>(ale_hover)", { silent = true, desc = "ALE: hover." })
			vim.keymap.set("n", "<Space>rn", "<Plug>(ale_rename)", { silent = true, desc = "ALE: rename." })

			-- Navigate between errors
			vim.keymap.set(
				"n",
				"<C-k>",
				"<Plug>(ale_previous_wrap)",
				{ silent = true, desc = "ALE: navigate to previous error." }
			)
			vim.keymap.set(
				"n",
				"<C-j>",
				"<Plug>(ale_next_wrap)",
				{ silent = true, desc = "ALE: navigate to next error." }
			)
			-- }

			-- Toggle command for fixers
			-- Ref: https://github.com/dense-analysis/ale/issues/1353#issuecomment-424677810
			vim.api.nvim_create_user_command(
				"ALEToggleFixer",
				"execute \"let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1\"",
				{ force = true, desc = "ALE: toggle ale_fix_on_save" }
			)
		end,
	})

	use("ray-x/lsp_signature.nvim") -- Method signature window, as ALE does not support it. Ref: https://www.reddit.com/r/vim/comments/jhqzsv/signature_help_via_ale/
	use("liuchengxu/vista.vim") -- LSP symbols and tags viewer, like TagBar but with LSP support.
	-- " }

	-- Development: DAP {
	--use('mfussenegger/nvim-dap') -- Debug Adapter Protocol
	--use('rcarriga/nvim-dap-ui')  -- UI for DAP
	--use('suketa/nvim-dap-ruby')  -- Config for ruby. Requries the `debug` gem. No rails support yet: https://github.com/suketa/nvim-dap-ruby/issues/25
	-- " }

	-- Development: C/C++ {
	use("ludovicchabant/vim-gutentags") -- Autogenerate new tags file.
	-- "}
	--
	-- Development: Go {
	--use{'fatih/vim-go', ft = { 'go' } }	-- Compilation commands etc.
	-- "}
	--
	-- Development: Java {
	--use{'erikw/jcommenter.vim', ft = { 'java' } }		-- Generate javadoc.
	-- "}
	--
	-- Development: LaTeX {
	--use{'donRaphaco/neotex', ft = { 'tex' }	-- Live preview PDF output from latex.
	-- " }
	--
	-- Development: Python {
	--use{'python-rope/ropevim', ft = { 'python' } }	-- Refactoring with rope library.
	--use{'fisadev/vim-isort', ft = { 'python' } }	    -- Sort imports
	-- "}
	--
	-- Development: Swift {
	--use{'keith/swift.vim', ft = { 'switft' } }	    -- Syntax files for Switch
	-- "}
	--
	-- Development: Web {
	use({ "ap/vim-css-color", ft = { "css", "scss" } }) -- Display CSS colors.
	-- " }

	-- " }
	-- " }
	-- }

	-- Navigation {
	-- * Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
	-- * Commands: https://github.com/junegunn/fzf.vim#commands
	use({
		"junegunn/fzf.vim",
		requires = { "junegunn/fzf", run = ":call fzf#install()" },
	})
	-- " }

	-- Snippets {
	use("dcampos/nvim-snippy") -- Snippets engine compatible with the SnipMate format.
	use("honza/vim-snippets") -- Snippet library
	-- " }
	--
	-- Syntax {
	use({ "bfontaine/Brewfile.vim", ft = { "brewfile" } }) -- Syntax for Brewfiles
	use({ "kalekundert/vim-nestedtext", ft = { "nestedtext" } }) -- Syntax for NestedText .nt files.
	-- " }

	-- UI {
	--use('RRethy/vim-illuminate')			-- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
	--use('yamatsum/nvim-/ursorline')		-- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
	--use('sitiom/nvim-numbertoggle')		-- Automatic relative / static line number toggling. Disabled as of https://github.com/sitiom/nvim-numbertoggle/issues/15
	use("chentoast/marks.nvim") -- Visualize marks in the sign column.

	-- Watch system light/dark mode changes. Requires dark-notify(1).
	use({
		"cormacrelf/dark-notify",
		config = function()
			require("dark_notify").run({
				onchange = function()
					-- Init hlargs.nvim.
					-- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
					-- Ref: https://github.com/cormacrelf/dark-notify/issues/8
					--require("hlargs").setup()
				end,
			})
			vim.keymap.set(
				"n",
				"<F5>",
				":lua require('dark_notify').toggle()<CR>",
				{ silent = true, desc = "Toggle dark/light mode." }
			)
		end,
	})

	use({ "crispgm/nvim-tabline", requires = { "nvim-tree/nvim-web-devicons" } }) -- More informative tab titles
	use("karb94/neoscroll.nvim") -- Smoth scrolling.
	use("mhinz/vim-startify") -- Start screen with recently opended files.

	-- Statusline.
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Colorschemes {
	--use('folke/tokyonight.nvim')
	--use('mhartington/oceanic-next')
	--use('morhetz/gruvbox')
	use("ishan9299/nvim-solarized-lua") -- Solarized theme that works with nvim-treesitter highlights.
	-- " }
	-- "}

	-- Auto set up conf after cloning packer.nvim. Must be after the use():es.
	-- Ref: https://github.com/wbthomason/packer.nvim#bootstrapping
	if packer_bootstrap then
		require("packer").sync()
	end

	-- Auto-compile Packer for lazy-loading each time this file is changed.
	-- Ref: https://github.com/wbthomason/packer.nvim#quickstart
	local augroup_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		pattern = "plugins.lua",
		group = augroup_packer,
		command = "source <afile> | PackerCompile",
	})
end)

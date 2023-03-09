-- Modeline {
-- vi: foldmarker={,} foldmethod=marker foldlevel=0:
-- }
--
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

-- TODO check README of all .nvim plugins, to see if they have sample packer instructions for optimized loading.
-- General {
--	--use('LucHermitte/local_vimrc') | use('LucHermitte/lh-vim-lib' " Project local vim config.
--	--use('dhruvasagar/vim-table-mode')			-- Create ASCII tables
--	--use('fidian/hexmode')						-- Open binary files as a HEX dump with :Hexmode
--	--use('folke/which-key.nvim')				-- Show matching keybindings e.g. when tapping Leader.
--	--use('godlygeek/tabular')					-- Create tables. Disabled: not used and have some startup time.
--	--use('salsifis/vim-transpose')				-- Matrix transposition of texts.
--	--use('voldikss/vim-translator')			-- Async language translator.
	use('axieax/urlview.nvim')					-- Open URLs in buffer.
	use('danro/rename.vim')						-- Provides the :Rename command
	use('gennaro-tedesco/nvim-peekup')			-- Register viewer and selector.
    use {'instant-markdown/vim-instant-markdown', ft='markdown', run='yarn install'}
    use {'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } } -- File explorer tree

    -- Work on surrond delimiters or its content. Like tpope/vim-surround but with TreeSitter.
    use{ "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end
    }
	use('mbbill/undotree')					    -- Navigate history in a sidebar. Replaces old 'mbbill/undotree'
	use('michaeljsmith/vim-indent-object')		-- Operate on intendtation as text objects.
	use('ntpeters/vim-better-whitespace')		-- Highlight and remove trailing whitespaces.
	use('phaazon/hop.nvim')					    -- Easy motion jumps in buffer.
	use('preservim/nerdcommenter')				-- Comment source code.
	use('tpope/vim-capslock')				    -- Software CAPSLOCK with <C-g>c in insert mode.
	use('tpope/vim-characterize')				-- 'ga' on steroid.
	use('tpope/vim-repeat')					    -- Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
	use('tpope/vim-speeddating')				-- Increment dates with C-a.
	use('tpope/vim-unimpaired')				    -- Bracket mappings like [<space>
-- " }
--
-- Development {
-- Development: General {
--	--use('github/copilot.vim')			-- AI powered code completion.
--	--use('ibhagwan/fzf-lua' | use('mrjones2014/dash.nvim', { 'do': 'make install' } " Search dash.app from nvim. Currently broken: https://github.com/mrjones2014/dash.nvim/issues/137
--	--use('lukas-reineke/indent-blankline.nvim')	-- Indent vertical markers.
--	--use('mfussenegger/nvim-dap')			-- Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA config is not working (freezes nvim).
    use('AndrewRadev/sideways.vim')			-- Shift function arguments left and right.
--	use('airblade/vim-gitgutter')			-- Git modified status in sign column
--	use('andymass/vim-matchup')			-- Extend % matching.
--	use('editorconfig/editorconfig-vim')		-- Standard .editorconfig file in shared projects.
--	use('godlygeek/tabular' | use('preservim/vim-markdown' " Markdown utilties like automatic list indention, TOC.
    use { 'm-demare/hlargs.nvim', requires = { 'nvim-treesitter/nvim-treesitter' } } -- Highlight usage of method arguments.
--	use('nguyenvukhang/nvim-toggler')		-- Toggle values like true/false with <leader>i.
--	use('nvim-lua/plenary.nvim' | use('andythigpen/nvim-coverage' " Show code coverage in sign column.
--	use('nvim-lua/plenary.nvim' | use('sindrets/diffview.nvim' " Better than fugative ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }  -- NVim interface for tree-sitter (language parser).
--	use('rgroli/other.nvim')			-- Open related file like test.
--	use('rhysd/conflict-marker.vim')		-- Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
--	use('ruanyl/vim-gh-line')			-- Copy link to file on GitHub.
--	use('superDross/ticket.vim')			-- Manage vim Sessions per git branch.
--	use('tpope/vim-fugitive')			-- Git wrapper and shorthands.
--	use('wellle/targets.vim')			-- Extra text objects to operate on e.g. function arguments.
--	use('windwp/nvim-autopairs')			-- Autoclose brackets etc.
-- " }
--
-- Development: LSP/Completion {
--	--use('neovim/nvim-lspconfig')			-- Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.
--	use('dense-analysis/ale')			-- LSP linting engine.
--	use('ray-x/lsp_signature.nvim')			-- Method signature window, as ALE does not support it. Ref: https://www.reddit.com/r/vim/comments/jhqzsv/signature_help_via_ale/
--	use('liuchengxu/vista.vim')			-- LSP symbols and tags viewer, like TagBar but with LSP support.
-- " }
--
-- Development: DAP {
--	--use('mfussenegger/nvim-dap') " Debug Adapter Protocol
--	--use('rcarriga/nvim-dap-ui')  " UI for DAP
--	--use('suketa/nvim-dap-ruby')  " Config for ruby. Requries the `debug` gem. No rails support yet: https://github.com/suketa/nvim-dap-ruby/issues/25
-- " }
--
-- Development: C/C++ {
--	--use('chazy/cscope_maps')						-- More macros than autoload_cscope.vim
--	--use('rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }
--	--use('vim-scripts/autoload_cscope.vim', { 'for': ['c', 'cpp'] }	-- Load cscope file and define macros for using it. https://github.com/vim-scripts/autoload_cscope.vim/blob/master/plugin/autoload_cscope.vim#L81-L88
--	use('ludovicchabant/vim-gutentags')					-- Autogenerate new tags file.
-- "}
--
-- Development: Go {
--	--use('fatih/vim-go',) { 'for': 'go' }	-- Compilation commands etc.
-- "}
--
-- Development: Java {
--	--Plugin) 'artur-shaik/vim-javacomplete2', { 'for': 'java' }	-- Omni-complete for Java
--	--Plugin 'erikw/jcommenter.vim', { 'for': 'java' }		-- Generate javadoc.
-- "}
--
-- Development: LaTeX {
--	--use('donRaphaco/neotex')	-- Live preview PDF output from latex.
-- " }
--
-- Development: Python {
--	--Plugin 'davidhalter/jedi-vim', { 'for': 'python' }	-- Autocompletion using jedi library.
--	--Plugin 'python-rope/ropevim', { 'for': 'python' }	-- Refactoring with rope library.
--	--Plugin 'fisadev/vim-isort', { 'for': 'python' }	-- Sort imports
-- "}
--
-- Development: Swift {
--	--Plugin 'keith/swift.vim', { 'for': 'switft' }	-- Syntax files for Switch
-- "}
--
-- Development: Web {
--	use('ap/vim-css-color', { 'for': ['css', 'scss'] }	-- Display CSS colors in vim.
-- " }
--
-- " }
--
-- Navigation {
--	-- FZF - Fuzzy finding
--	-- - Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
--	-- - Commands: https://github.com/junegunn/fzf.vim#commands
--	use('junegunn/fzf', { 'do': { -> fzf#install() } } | use('junegunn/fzf.vim'
-- " }
--
-- Snippets {
--	use('dcampos/nvim-snippy')	-- Snippets engine compatible with the SnipMate format.
--	use('honza/vim-snippets')	-- Snippet library
-- " }
--
-- Syntax {
--	use('bfontaine/Brewfile.vim', { 'for': 'brewfile' }		-- Syntax for Brewfiles
--	use('kalekundert/vim-nestedtext', { 'for': 'nestedtext' }	-- Syntax for NestedText .nt files.
-- " }
--
-- UI {
--	--use('RRethy/vim-illuminate')		-- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
--	--use('sitiom/nvim-numbertoggle')		-- Automatic relative / static line number toggling. Disabled as of https://github.com/sitiom/nvim-numbertoggle/issues/15
--	--use('yamatsum/nvim-cursorline')	-- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
--	use('chentoast/marks.nvim')		-- Visualize marks in the sign column.
    use('cormacrelf/dark-notify')		-- Watch system light/dark mode changes. Requires dark-notify(1).
--	use('crispgm/nvim-tabline')		-- More informative tab titles.
--	use('karb94/neoscroll.nvim')		-- Smoth scrolling.
--	use('kyazdani42/nvim-web-devicons')	-- Dependency for: nvim-tree.lua, lualine.nvim, barbar.nvim
--	use('mhinz/vim-startify')		-- Start screen with recently opended files.
--	use('nvim-lualine/lualine.nvim')	-- Statusline.
--
-- Colorschemes {
--	--use('altercation/vim-colors-solarized')	-- The one theme to rule them all.
--	--use('folke/tokyonight.nvim', { 'branch': 'main' }
--	--use('mhartington/oceanic-next'
--	--use('morhetz/gruvbox'
    use('ishan9299/nvim-solarized-lua')		-- Solarized theme that works with nvim-treesitter highlights.
-- " }
-- "}
--

	-- Auto  set up conf after cloning packer.nvim. Must be after the use()s
	if packer_bootstrap then
		require("packer").sync()
	end
end)

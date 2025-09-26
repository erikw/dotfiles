-- Spec doc: https://lazy.folke.io/spec
return {

    --{'folke/tokyonight.nvim'),
    --{'mhartington/oceanic-next'),
    --{'morhetz/gruvbox'),

	-- Solarized theme that works with nvim-treesitter highlights.
   {
	"ishan9299/nvim-solarized-lua",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme solarized]])
		vim.opt.background = "light" -- Be light (most likely right) be default as dark-notify toggles ugly otherwise.

	 end,
   },



    --{'yamatsum/nvim-/ursorline'},    -- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
    --{'sitiom/nvim-numbertoggle'},    -- Automatic relative / static line number toggling. Disabled as of https://github.com/sitiom/nvim-numbertoggle/issues/15
    --{"RRethy/vim-illuminate"}, -- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8


    -- Watch system light/dark mode changes. Requires dark-notify(1).
    {
        "cormacrelf/dark-notify",
	event = "VimEnter", -- start after UI is ready
        config = function()
            require("dark_notify").run({
                --onchange = function()
                    -- Init hlargs.nvim.
                    -- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
                    -- Ref: https://github.com/cormacrelf/dark-notify/issues/8
                    --require("hlargs").setup()
                --end,
            })
            vim.keymap.set("n", "<F5>", ":lua require('dark_notify').toggle()<CR>", { silent = true, desc = "Toggle dark/light mode." })
        end,
    },

    -- Visualize marks in the sign column.
    {
        "chentoast/marks.nvim",
        opts = {}
    },

    -- More informative tab titles.
    {
        "crispgm/nvim-tabline",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Smoth scrolling.
    {
        "karb94/neoscroll.nvim",
        opts = {},
    },

    -- The fastest greeter plugin.
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function()
            local startify = require("alpha.themes.startify")

	      startify.file_icons.provider = "devicons"

            -- Add bookmarks buttons. Ref: https://github.com/goolord/alpha-nvim/issues/14
            startify.section.bottom_buttons.val = {
                -- Preserving the button from https://github.com/goolord/alpha-nvim/blob/dafa11a6218c2296df044e00f88d9187222ba6b0/lua/alpha/themes/startify.lua#LL208C13-L208C47
                startify.button("q", "Quit", "<cmd>q <CR>"),

                startify.file_button(vim.fn.stdpath("config") .. "/init.lua", "v"),
                startify.file_button(vim.fn.stdpath("config") .. "/lua/plugins/general.lua", "vg"),
                startify.file_button(vim.fn.stdpath("config") .. "/lua/plugins/development.lua", "vd"),
                startify.file_button(vim.fn.stdpath("config") .. "/lua/plugins/syntax.lua", "vs"),
                startify.file_button(vim.fn.stdpath("config") .. "/lua/plugins/ui.lua", "vu"),
                startify.file_button(vim.g.xdg_config_home .. "/shell/commons", "c"),
                startify.file_button(vim.g.xdg_config_home .. "/shell/aliases", "a"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile", "b"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile.cypress", "bc"),
            }
            require("alpha").setup(startify.config)
        end,
    },

    -- Statusline.
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
	event = "VeryLazy", -- load later for faster startup
        opts = {
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- relative path
                        },
                    },
                },
                inactive_sections = {
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- relative path
                        },
                    },
                },
                extensions = { "fugitive", "fzf", "nvim-tree", "quickfix" },
            }
    },
}

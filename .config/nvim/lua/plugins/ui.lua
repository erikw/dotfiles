-- Spec doc: https://lazy.folke.io/spec
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

return {
    -- Themes {{
    --{'folke/tokyonight.nvim'),
    --{'mhartington/oceanic-next'),
    --{'morhetz/gruvbox'),

    -- Solarized theme that works with nvim-treesitter highlights.
    {
        "maxmx03/solarized.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            vim.o.termguicolors = true
            -- vim.o.background = "light"
            require("solarized").setup(opts)
            vim.cmd.colorscheme("solarized")
        end,
    },
    -- }}

    --{'sitiom/nvim-numbertoggle'},    -- Automatic relative / static line number toggling. Disabled as of https://github.com/sitiom/nvim-numbertoggle/issues/15

    -- Visualize marks in the sign column.
    {
        "chentoast/marks.nvim",
        event = "BufReadPre",
        opts = {},
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
        event = "BufReadPre",
        opts = {},
    },

    -- The fastest greeter startup screen plugin.
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
                startify.file_button(vim.g.xdg_config_home .. "/zsh/.zshrc", "zr"),
                startify.file_button(vim.g.xdg_config_home .. "/zsh/.zprofile", "zp"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile", "b"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile.cypress", "bc"),
            }
            require("alpha").setup(startify.config)
        end,
    },

    -- Statusline.
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy", -- load later for faster startup
        opts = {
            sections = {
                lualine_c = {
                    {
                        "filename",
                        path = 1, -- relative path
                    },
                    -- aerial breadcrumb: shows current symbol context (e.g. MyClass > myMethod).
                    -- aerial is lazy-loaded on command; this component safely no-ops until then.
                    { "aerial" },
                },
                lualine_x = {
                    -- nvim_diagnostic covers ALL diagnostic sources: LSP, nvim-lint, etc.
                    -- (nvim-lint writes to vim.diagnostic, so nvim_lint is not a separate source.)
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
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
            extensions = { "fugitive", "nvim-tree", "quickfix" },
        },
    },
}

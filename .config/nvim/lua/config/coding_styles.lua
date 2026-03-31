-- Shared coding style helpers for ftplugin files.
-- Usage: require("config.coding_styles").spaces(4)
--        require("config.coding_styles").tabs(8)
local M = {}

local function set_indent_width(n)
    vim.opt_local.tabstop = n
    vim.opt_local.shiftwidth = n
end

-- Space-based indentation (expandtab = true).
function M.spaces(n)
    set_indent_width(n)
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = n
    vim.opt_local.smarttab = true
    vim.opt_local.shiftround = true
end

-- Tab-based indentation (expandtab = false, explicit to prevent global leakage).
-- smarttab is intentionally omitted: it is a global option and a no-op when
-- tabstop == shiftwidth, which is always the case here.
function M.tabs(n)
    set_indent_width(n)
    vim.opt_local.expandtab = false
    vim.opt_local.softtabstop = 0  -- disable softtabstop for pure-tab indentation
end

return M

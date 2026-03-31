-- Bullet list indentation.
-- Placed in after/ftplugin/ so this runs after lazy-loaded ft-triggered plugins
-- (e.g. vim-markdown) whose own ftplugins would otherwise overwrite these values.
require("config.coding_styles").spaces(2)

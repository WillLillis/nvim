vim.g.mapleader = " "

require("lillis.options")
require("lillis.keymaps")
require("lillis.autocmds")
require("lillis.floaterminal")
require("lillis.plugins")
-- Statusline loads after plugins so the colorscheme is already set when
-- we register our mode-color highlights (otherwise kanagawa's
-- ColorScheme autocmd clobbers them on first load).
require("lillis.statusline")

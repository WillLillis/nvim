local telescope = require('telescope')
local builtin = require('telescope.builtin')
local resolver = require('telescope.config.resolve')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

telescope.setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_ivy {
            }
        },
        fzf = {},
        file_browser = {
            --theme = "ivy",
            layout_strategy = 'horizontal',
            layout_config = { height = 0.95, width = 0.95, preview_width = resolver.resolve_width(0.6) },
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
        },
        nvim_web_devicons = {},
    },
}

vim.api.nvim_set_keymap(
    "n",
    "<leader>fb",
    ":Telescope file_browser<CR>",
    { noremap = true }
)
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
    "n",
    "<leader>fc",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true }
)
-- open file brower in the ~/projects directory
vim.api.nvim_set_keymap(
    "n",
    "<leader>fp",
    ":Telescope file_browser path=~/projects/<CR>",
    { noremap = true }
)
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension "file_browser"
telescope.load_extension("ui-select")

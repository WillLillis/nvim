local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


telescope.setup {
    extensions = {
        fzf = {},
        file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
        },
        nvim_web_devicons = {},
    },
    layout_config = {
        vertical = {
            preview_width = 1.0,
        }
    },
}

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
    "n",
    "<space>fb",
    ":Telescope file_browser<CR>",
    { noremap = true }
)
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension "file_browser"

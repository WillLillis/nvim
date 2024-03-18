local telescope = require('telescope')
local builtin = require('telescope.builtin')
local resolver = require('telescope.config.resolve')
vim.keymap.set('n', '<leader>pf', builtin.find_files,
    { desc = "[pf] find Project Files" })
vim.keymap.set('n', '<C-p>', builtin.git_files,
    { desc = "<C-p> find git files" })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "[ps] Project Search" })

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

vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>",
    { desc = "[fb] File browser in current working directory" })

vim.keymap.set('n', '<leader>fc', ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { desc = "[fc] File browser in current buffer's directory" })

vim.keymap.set('n', '<leader>fp', ":Telescope file_browser path=~/projects/<CR>",
    { desc = "[fp] File browser in ~/projects" })

vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzy search in the current buffer' })
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension "file_browser"
telescope.load_extension("ui-select")

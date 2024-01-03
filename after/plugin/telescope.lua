local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

--local fb_actions = require "telescope._extensions.file_browser.actions"

telescope.setup {
    extensions = {
        fzf = {},
        file_browser = {},
        nvim_web_devicons = {},
    }
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension "file_browser"

return telescope

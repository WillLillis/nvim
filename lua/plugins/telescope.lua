return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "debugloop/telescope-undo.nvim" },
        },
        lazy = false,
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')
            local resolver = require('telescope.config.resolve')
            local open_with_trouble = require("trouble.sources.telescope").open
            local add_to_trouble = require("trouble.sources.telescope").add

            telescope.setup {
                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
                        n = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_ivy {}
                    },
                    fzf = {},
                    file_browser = {
                        layout_strategy = 'horizontal',
                        layout_config = { height = 0.95, width = 0.95, preview_width = resolver.resolve_width(0.6) },
                        hijack_netrw = true,
                        hidden = { file_browser = true, folder_browser = true },
                    },
                    nvim_web_devicons = {},
                    undo = {},
                },
            }

            telescope.load_extension('fzf')
            telescope.load_extension('file_browser')
            telescope.load_extension('ui-select')
            telescope.load_extension('undo')

            vim.keymap.set('n', '<leader>pf', builtin.find_files,
                { desc = "[pf] find Project Files" })
            vim.keymap.set('n', '<C-p>', builtin.git_files,
                { desc = "<C-p> find git files" })
            vim.keymap.set('n', '<leader>ps', function()
                builtin.live_grep()
            end, { desc = "[ps] Project Search" })
            vim.keymap.set('n', '<leader>td', ":Telescope diagnostics<CR>",
                { desc = "[td] Telescope diagnostics" })
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
            vim.keymap.set('n', '<leader>U', ":Telescope undo<CR>",
                { desc = '[u] Browse undo tree' })
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        lazy = false
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = false
    },
    {
        "debugloop/telescope-undo.nvim",
        lazy = false
    },
}

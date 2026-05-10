return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
        current_line_blame = true,
        update_debounce = 0,
        on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>tb', ":Gitsigns blame<CR>",
                { desc = "[tb] Toggle Blame for the current file" })
        end,
    },
}

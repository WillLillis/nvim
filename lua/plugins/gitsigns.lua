return {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
            update_debounce = 0,
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>tb', ":Gitsigns blame<CR>",
                    { desc = "[tb] Toggle Blame for the current file" })
            end,
        })
    end,
}

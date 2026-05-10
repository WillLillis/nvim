return {
    src = "https://github.com/yorickpeterse/nvim-window",
    config = function()
        require('nvim-window').setup({
            chars = {
                'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
                'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
            },
            normal_hl = 'NvimWindowHighlights',
            hint_hl = 'Bold',
            border = 'rounded',
            render = 'float',
        })

        vim.keymap.set("n", "<leader>w", "<cmd>lua require('nvim-window').pick()<CR>",
            { desc = "nvim-window: Jump to window" })
    end,
}

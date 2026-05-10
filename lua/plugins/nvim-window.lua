return {
    "yorickpeterse/nvim-window",
    keys = {
        { "<leader>w", "<cmd>lua require('nvim-window').pick()<CR>", desc = "nvim-window: Jump to window" },
    },
    lazy = false,
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
    end,
}

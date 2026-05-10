return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    name = "kanagawa",
    config = function()
        require('kanagawa').setup({
            compile = true,
            transparent = true,
            background = {
                dark = "wave",
                light = "lotus"
            },
        })
        vim.cmd("colorscheme kanagawa-dragon")
    end,
}

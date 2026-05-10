return {
    src = "https://github.com/rebelot/kanagawa.nvim",
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

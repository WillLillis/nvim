return {
    -- Local dev checkout - switch back to remote once upstream PR merges
    -- src = "https://github.com/nvimdev/lspsaga.nvim",
    dir = "/home/lillis/projects/lspsaga.nvim",
    config = function()
        require("lspsaga").setup({
            lightbulb = { enable = false },
        })
    end,
}

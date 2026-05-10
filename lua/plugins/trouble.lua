return {
    src = "https://github.com/folke/trouble.nvim",
    deps = {
        "https://github.com/nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("trouble").setup()
    end,
}

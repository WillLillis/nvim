return {
    "folke/trouble.nvim",
    dependencies = { "nvim-web-devicons" },
    lazy = false,
    config = function()
        require("trouble").setup()
    end,
}

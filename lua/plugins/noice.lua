return {
    src = "https://github.com/folke/noice.nvim",
    deps = {
        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({})
    end,
}

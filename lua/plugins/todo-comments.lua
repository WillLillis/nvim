return {
    src = "https://github.com/folke/todo-comments.nvim",
    deps = {
        "https://github.com/nvim-lua/plenary.nvim",
    },
    config = function()
        require("todo-comments").setup({ signs = true })
    end,
}

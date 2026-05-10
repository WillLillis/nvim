return {
    src = "https://github.com/dmtrKovalenko/fff.nvim",
    config = function()
        require("fff").setup({})
        vim.keymap.set("n", "<leader>ff", function()
            require("fff").find_files()
        end, { desc = "Toggle FFF" })
    end,
}

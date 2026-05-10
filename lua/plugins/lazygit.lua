return {
    src = "https://github.com/kdheepak/lazygit.nvim",
    deps = {
        "https://github.com/nvim-lua/plenary.nvim",
    },
    config = function()
        vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
        require("telescope").load_extension("lazygit")
    end,
}

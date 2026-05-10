return {
    src = "https://github.com/mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[u] toggle Undotree" })
    end,
}

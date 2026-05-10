return {
    "mbbill/undotree",
    lazy = false,
    keys = {
        { "<leader>u", function() vim.cmd.UndotreeToggle() end, desc = "[u] toggle Undotree" },
    },
}

return {
    src = "https://github.com/akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            shading_factor = 0.3,
            direction = "float",
            persist_mode = false,
            auto_scroll = false,
        })

        vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

        vim.keymap.set("n", "<leader>1",
            function() require("toggleterm").toggle(1, 0, "float") end, { desc = "Terminal 1" })
        vim.keymap.set("n", "<leader>2",
            function() require("toggleterm").toggle(2, 0, "float") end, { desc = "Terminal 2" })
        vim.keymap.set("n", "<leader>3",
            function() require("toggleterm").toggle(3, 0, "float") end, { desc = "Terminal 3" })
        vim.keymap.set("n", "<leader>4",
            function() require("toggleterm").toggle(4, 0, "float") end, { desc = "Terminal 4" })
        vim.keymap.set("n", "<leader>5",
            function() require("toggleterm").toggle(5, 0, "float") end, { desc = "Terminal 5" })
        vim.keymap.set("n", "<leader>Tn", "<cmd>ToggleTermSetName<cr>", { desc = "Set Terminal Name" })
        vim.keymap.set("n", "<leader>Ts", "<cmd>TermSelect<cr>", { desc = "Select Terminal" })
    end,
}

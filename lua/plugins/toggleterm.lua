return {
    "akinsho/toggleterm.nvim",
    init = function()
        vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
    ---@type ToggleTermConfig
    opts = {
        shading_factor = 0.3,
        direction = "float",
        persist_mode = false,
        auto_scroll = false,
    },
    keys = {
        {
            "<leader>1",
            function() require("toggleterm").toggle(1, 0, "float") end,
            desc = "Terminal 1",
        },
        {
            "<leader>2",
            function() require("toggleterm").toggle(2, 0, "float") end,
            desc = "Terminal 2",
        },
        {
            "<leader>3",
            function() require("toggleterm").toggle(3, 0, "float") end,
            desc = "Terminal 3",
        },
        {
            "<leader>4",
            function() require("toggleterm").toggle(4, 0, "float") end,
            desc = "Terminal 4",
        },
        {
            "<leader>5",
            function() require("toggleterm").toggle(5, 0, "float") end,
            desc = "Terminal 5",
        },
        {
            "<leader>Tn",
            "<cmd>ToggleTermSetName<cr>",
            desc = "Set Terminal Name",
        },
        {
            "<leader>Ts",
            "<cmd>TermSelect<cr>",
            desc = "Select Terminal",
        },
    },
}

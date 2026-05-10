return {
    "dmtrKovalenko/fff.nvim",
    dir = "/home/lillis/projects/fff.nvim/",
    dev = true,
    lazy = false,
    build = "cargo build --release",
    opts = {},
    keys = {
        {
            "<leader>ff",
            function()
                require("fff").find_files()
            end,
            desc = "Toggle FFF",
        },
        move_up = { '<Up>', '<C-p>', '<C-k>' },
        close = { '<Esc>', '<C-c>' },
        select = '<CR>',
    },
}

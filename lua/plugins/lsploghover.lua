return {
    src = "https://github.com/WillLillis/lsploghover.nvim",
    config = function()
        local log = require("lsploghover")
        vim.keymap.set('n', '<leader>st', function() log.start() end, { desc = "[st] STart log time stamp" })
        vim.keymap.set('n', '<leader>sh', function() log.show_logs() end, { desc = "[sh] SHow logs" })
        log.setup()
    end,
}

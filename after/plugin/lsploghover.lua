local log = require("lsploghover")

vim.keymap.set('n', '<leader>st', function() log.start() end, { desc = "STart log time stamp" })
vim.keymap.set('n', '<leader>sh', function() log.show_logs() end, { desc = "SHow logs" })

log.setup()

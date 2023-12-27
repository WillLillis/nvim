local log = require("lsploghover")

vim.keymap.set('n', '<leader>st', function() log.start() end)
vim.keymap.set('n', '<leader>sh', function() log.show_logs() end)

log.setup()

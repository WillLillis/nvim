local dap, dapui = require("dap"), require("dapui")

dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { "-i", "dap" }
}

dap.configurations.rust = {
    {
        type = 'gdb',
        name = 'Debug',
        request = 'launch',
        program = function()
            -- TODO: Try to auto detect cwd()/target/debug/<file-name>
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
        preLaunchTask = {
            command = "cargo",
            args = { "run" },
            type = "shell"
        }
    },
}

-- Make sure you compile with -g !!!!
dap.configurations.c = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
}

-- TODO: Rethink these...
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F7>', function() dap.step_into() end)
vim.keymap.set('n', '<F8>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { desc = "[b] toggle Breakpoint" })
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end, { desc = "[B] set Breakpoint"} )
vim.keymap.set('n', '<Leader>lp',
    function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "[lp] Log Point message" } )
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "[dr] open REPL" } )
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "[dl] run Last" } )
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

-- Dap UI hooks

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("dap")
require("dapui").setup()

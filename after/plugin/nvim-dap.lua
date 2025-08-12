local dap, dapui = require("dap"), require("dapui")


dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { "-i", "dap" }
}

dap.adapters.lldb_zig = {
    type = 'executable',
    -- Use jacobly0's fork
    command = '/home/lillis/projects/llvm-project/build/bin/lldb-dap',
    args = {}
}

dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
}

dap.configurations.rust = {
    {
        type = 'lldb',
        name = 'Debug',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = vim.fn.getcwd(),
        -- stopOnEntry = false,
        args = {},
        runInTerminal = false,
        initCommands = function()
            -- Find out where to look for the pretty printer Python module.
            local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
            assert(
                vim.v.shell_error == 0,
                'failed to get rust sysroot using `rustc --print sysroot`: '
                .. rustc_sysroot
            )
            local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
            local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

            return {
                ([[!command script import '%s']]):format(script_file),
                ([[command source '%s']]):format(commands_file),
            }
        end,
    },
}

-- Make sure you compile with -g !!!!
-- TODO: Compile with -gdwarf-4?
dap.configurations.c = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
}

-- Make sure you compile with -g !!!!
-- TODO: Compile with -gdwarf-4?
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
        initCommands = function()
            local lldb_python_path = vim.fn.trim(vim.fn.system 'lldb -P')
            assert(
                vim.v.shell_error == 0,
                'failed to get lldb ptyhong path using `lldb -P`: '
                .. lldb_python_path
            )
            local init_file = lldb_python_path .. '/lldb/formatters/cpp/__init__.py'
            return {
                ([[!command script import '%s']]):format(init_file),
            }
        end
    },
}

dap.configurations.zig = {
    {
        name = 'Launch',
        type = 'lldb_zig',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        initCommands = function()
            return {
                [[command script import /home/lillis/projects/zig/tools/lldb_pretty_printers.py]],
                -- Only used for llvm backend:
                -- [[type category enable zig.lang]],
                -- [[type category enable zig.std]]
            }
        end,
    },
}

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_into() end)
vim.keymap.set('n', '<F7>', function() dap.step_over() end)
vim.keymap.set('n', '<F8>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { desc = "[b] toggle Breakpoint" })
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end, { desc = "[B] set Breakpoint" })
vim.keymap.set('n', '<Leader>lp',
    function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "[lp] Log Point message" })
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "[dr] open REPL" })
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "[dl] run Last" })
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
-- Eval var under cursor
vim.keymap.set('n', '<Leader>?', function()
    require('dapui').eval(nil, { enter = true, context = "hover" }) -- false positive from lsp about required fields here?
end)
vim.keymap.set('n', '<Leader>aw', function()
    require('dapui').elements.watches.add(vim.fn.expand('<cword>'))
end, { desc = "[aw] Add Watch under cursor" })
vim.keymap.set('n', '<Leader>ca', function()
    dapui.close()
end, { desc = "[ca] Close All dapui windows" })
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
require("nvim-dap-virtual-text").setup({})

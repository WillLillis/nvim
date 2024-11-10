local dap, dapui = require("dap"), require("dapui")


dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { "-i", "dap" }
}
-- Move over utils file?

--- Returns the time a file was last modified, or nil if something went wrong
--- @param path string
--- @return integer|nil
local function get_modified_timestamp(path)
    -- TODO: See if there's an analogous command to use on Windows
    local f = io.popen(string.format("stat -c %%Y %s", path))
    if not f then
        return nil
    end

    local last_modified = f:read()
    if not last_modified then
        return nil
    else
        return tonumber(last_modified)
    end
end

--- Returns the path to the debug build of the current rust project, if possible
--- Opens a floating window warning the user if the current buffer was modifed
--- after the last build
--- @return string|nil
local function get_rust_bin()
    local project_dirs = vim.lsp.buf.list_workspace_folders()
    if not project_dirs or #project_dirs == 0 or not project_dirs[1] then
        return nil
    end
    local project_dir = project_dirs[1]

    local name_start = string.len(project_dir) - (string.find(string.reverse(project_dir), '/') - 2)
    local bin_name = string.sub(project_dir, name_start)
    local bin_path = project_dir .. "/target/debug/" .. bin_name

    local bin_last_modified = get_modified_timestamp(bin_path)
    if bin_last_modified == nil then
        return nil
    else
        local buf_path = vim.api.nvim_buf_get_name(0)
        local buf_last_modified = get_modified_timestamp(buf_path)
        if buf_last_modified == nil then
            return nil
        end

        if buf_last_modified > bin_last_modified then
            -- Better way to do this?
            vim.lsp.util.open_floating_preview({ "# WARNING\nCurrent buffer modified since last build" },
                "markdown", {})
        end

        return bin_path
    end
end

dap.configurations.rust = {
    {
        type = 'gdb',
        name = 'Debug',
        request = 'launch',
        program = function()
            local bin_path = get_rust_bin()
            if bin_path == nil then
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            else
                return bin_path
            end
        end,
        cwd = vim.fn.getcwd(),
        -- stopOnEntry = false,
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

-- TODO: Better executable file detection, as in what I did with rust
dap.configurations.zig = {
    {
        name = 'Launch',
        type = 'gdb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = { "build-exe", "/home/lillis/projects/test_zig/src/main.zig" },
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
    require('dapui').eval(nil, { enter = true }) -- false positive from lsp about required fields here?
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
require("nvim-dap-virtual-text").setup({})

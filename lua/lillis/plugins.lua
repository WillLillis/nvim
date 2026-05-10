-- Build hooks fire on install/update and need to run before the plugin's
-- config function (otherwise compiled artifacts may be missing on first load).
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("lillis-pack-build", { clear = true }),
    callback = function(ev)
        local kind = ev.data.kind
        if kind ~= "install" and kind ~= "update" then return end

        local name = ev.data.spec.name
        local path = ev.data.path

        if name == "telescope-fzf-native.nvim" then
            vim.system({ "make" }, { cwd = path }):wait()
        elseif name == "LuaSnip" then
            if vim.fn.has("win32") == 0 and vim.fn.executable("make") == 1 then
                vim.system({ "make", "install_jsregexp" }, { cwd = path }):wait()
            end
        elseif name == "nvim-treesitter" then
            vim.schedule(function()
                if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
                pcall(vim.cmd, "TSUpdate")
            end)
        elseif name == "fff.nvim" then
            -- Plugin's own download helper: tries a prebuilt binary first,
            -- falls back to `cargo build --release`. We need to packadd the
            -- plugin first since the download module isn't on the runtime
            -- path yet at install-event time.
            if not ev.data.active then vim.cmd.packadd("fff.nvim") end
            require("fff.download").download_or_build_binary()
        end
    end,
})

-- Explicit load order. Foundation plugins (colorscheme, devicons) load first
-- so later UI plugins see them. LSP/completion bundles are grouped together.
local manifest = {
    "colorscheme",
    "web-devicons",

    "treesitter",

    "lsp",
    "lspsaga",
    "lsploghover",
    "rustaceanvim",
    "crates",

    "completion",

    "telescope",
    "trouble",
    "lazygit",

    "noice",
    "which-key",

    "comment",
    "todo-comments",
    "harpoon",
    "undotree",
    "gitsigns",
    -- fff: disabled. Rebuilding the Rust binary fails because zlob 1.3.3
    -- requires zig APIs (std.Options.signal_stack_size, std.Io.Threaded)
    -- that aren't in zig 0.15.2 stable, and the prebuilt fff release was
    -- compiled against nvim 0.12 LuaJIT ABI so it segfaults on 0.13.
    -- Re-enable when fff publishes a 0.13-compatible release or zlob
    -- catches up to a stable zig.
    -- "fff",

    "vim-tmux-navigator",

    "toggleterm",

    "dap",
}

local modules = {}
for _, name in ipairs(manifest) do
    modules[name] = require("plugins." .. name)
end

local specs = {}
for _, name in ipairs(manifest) do
    local m = modules[name]
    if m.src then
        local spec = { src = m.src }
        if m.name then spec.name = m.name end
        if m.version then spec.version = m.version end
        table.insert(specs, spec)
    end
    if m.dir then
        vim.opt.rtp:prepend(m.dir)
    end
    if m.deps then
        for _, dep in ipairs(m.deps) do
            table.insert(specs, type(dep) == "string" and { src = dep } or dep)
        end
    end
end

vim.pack.add(specs, { confirm = false })

for _, name in ipairs(manifest) do
    local m = modules[name]
    if m.config then m.config() end
end

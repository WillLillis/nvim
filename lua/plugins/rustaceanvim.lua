return {
    src = "https://github.com/mrcjkb/rustaceanvim",
    version = vim.version.range("^5"),
    config = function()
        vim.g.rustaceanvim = {
            tools = {},
            server = {
                on_attach = function(client, bufnr)
                    -- Workaround for diagnostics dissapearing on save in certain crates
                    vim.keymap.set('n', '<leader>cc', ':RustLsp flyCheck<CR>',
                        { desc = "[cc] cargo flycheck" })
                end,
                default_settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = true,
                        cargo = {
                            targetDir = true,
                            buildScripts = { enable = true },
                            features = "all",
                            cfgs = { "debug_assertions", "trace_events" },
                        },
                        check = {
                            command = "clippy",
                            targetDir = true,
                            features = "all",
                        },
                    },
                },
            },
            dap = {},
        }
    end,
}

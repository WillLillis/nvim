return {
    "mrcjkb/rustaceanvim",
    version = '^5',
    lazy = false,
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
                        },
                        check = {
                            targetDir = true,
                            features = "all",
                        },
                    },
                },
            },
            dap = {},
        }
    end
}

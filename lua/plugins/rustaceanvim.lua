return {
    src = "https://github.com/mrcjkb/rustaceanvim",
    version = vim.version.range("^5"),
    config = function()
        -- Per-project rust-analyzer flag overrides, keyed by the project
        -- directory name. Projects not listed use the defaults below
        -- (features = "all", rust-analyzer's built-in cfgs).
        --
        --   subspy:  the watch-server tracing module is gated behind
        --            `--cfg trace_events`; add it (alongside r-a's default
        --            cfgs) so those blocks aren't greyed out in-editor.
        --   git2-rs: `features = "all"` turns on libgit2-sys's `unstable-sha256`,
        --            whose 4-arg FFI bindings don't match the default-feature
        --            call sites (spurious E0061s). Pin it to the feature set
        --            subspy actually builds against.
        local project_overrides = {
            subspy = { cfgs = { "debug_assertions", "miri", "trace_events" } },
            ["git2-rs"] = { features = { "vendored-libgit2" } },
        }

        vim.g.rustaceanvim = {
            tools = {},
            server = {
                on_attach = function(client, bufnr)
                    -- Workaround for diagnostics dissapearing on save in certain crates
                    vim.keymap.set('n', '<leader>cc', ':RustLsp flyCheck<CR>',
                        { desc = "[cc] cargo flycheck" })
                end,
                -- Settings shared by every project. The per-project feature/cfg
                -- flags are injected by `settings` below.
                default_settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = true,
                        cargo = {
                            targetDir = true,
                            buildScripts = { enable = true },
                        },
                        check = {
                            command = "clippy",
                            targetDir = true,
                        },
                    },
                },
                -- Inject the per-project flags so each project sees only the
                -- features/cfgs that actually apply to it.
                settings = function(project_root, default_settings)
                    local ra = default_settings["rust-analyzer"]
                    local name = project_root and vim.fs.basename(project_root)
                    local override = (name and project_overrides[name]) or {}
                    local features = override.features or "all"
                    ra.cargo.features = features
                    ra.check.features = features
                    ra.cargo.cfgs = override.cfgs -- nil => rust-analyzer's defaults
                    return default_settings
                end,
            },
            dap = {},
        }
    end,
}

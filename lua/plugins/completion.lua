return {
    src = "https://github.com/saghen/blink.cmp",
    -- Pin to a tagged release; blink auto-downloads the prebuilt fuzzy
    -- library matching the tag, so no Rust toolchain is required at runtime.
    version = "v1.10.2",
    deps = {
        "https://github.com/L3MON4D3/LuaSnip",
        "https://github.com/rafamadriz/friendly-snippets",
    },
    config = function()
        local luasnip = require("luasnip")
        local types = require("luasnip.util.types")

        require("luasnip.loaders.from_vscode").lazy_load()

        luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_ops = {
                [types.choiceNode] = {
                    active = { virt_text = { { "<-", "Error" } } },
                },
            },
        })

        -- User-defined snippets
        local s = luasnip.s
        local i = luasnip.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        luasnip.add_snippets("xml", {
            s("<d", fmt(
                "<directive name=\"{}\" tool=\"fasm\">\n\t<description>{}</description>\n</directive>",
                { i(1, "Name"), i(2, "") }
            )),
        })
        luasnip.add_snippets("all", {
            s("lsp", fmt("LSPLOGHOVER<{}>", { i(1, "Log") })),
        })

        require("blink.cmp").setup({
            -- Keymaps preserve the muscle memory from the old nvim-cmp setup.
            keymap = {
                preset = "none",
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-y>"] = { "select_and_accept", "fallback" },
                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                -- LuaSnip jumps (matches old config)
                ["<C-l>"] = {
                    function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                            return true
                        end
                    end,
                    "fallback",
                },
                ["<C-k>"] = {
                    function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                            return true
                        end
                    end,
                    "fallback",
                },
            },

            appearance = { nerd_font_variant = "mono" },

            snippets = { preset = "luasnip" },

            sources = {
                default = { "lsp", "snippets", "path", "buffer" },
                per_filetype = {
                    -- crates.nvim serves completions through its in-process LSP
                    -- (lsp.completion = true in plugins/crates.lua), so crate
                    -- completions arrive via blink's built-in "lsp" source. There
                    -- is no separate "crates" provider to register.
                    toml = { "lsp", "path", "snippets", "buffer" },
                },
            },

            completion = {
                accept = { auto_brackets = { enabled = false } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                menu = {
                    border = "rounded",
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
            },

            signature = { enabled = true },

            -- Cmdline completion replaces the old wilder.nvim setup.
            cmdline = {
                enabled = true,
                keymap = { preset = "inherit" },
                completion = {
                    menu = { auto_show = true },
                    list = { selection = { preselect = false } },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
        })
    end,
}

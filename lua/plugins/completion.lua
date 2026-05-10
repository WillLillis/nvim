return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                },
            },
        },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local types = require("luasnip.util.types")

        luasnip.config.set_config {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_ops = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "<-", "Error" } },
                    },
                },
            },
        }

        vim.keymap.set({ "i" }, "<C-K>", function() luasnip.expand() end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, { silent = true })

        local snippet = luasnip.s
        local i = luasnip.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        luasnip.add_snippets("xml", {
            snippet("<d",
                fmt(
                    "<directive name=\"{}\" tool=\"fasm\">\n\t<description>{}</description>\n</directive>",
                    {
                        i(1, "Name"),
                        i(2, ""),
                    })
            ),
        })

        luasnip.add_snippets("all", {
            snippet("lsp",
                fmt(
                    "LSPLOGHOVER<{}>",
                    {
                        i(1, "Log"),
                    })
            ),
        })

        local SPACE_ELLIPSIS = ' …'
        local MAX_LABEL_WIDTH = 30

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },
            formatting = {
                format = function(entry, vim_item)
                    local m = vim_item.menu or ""
                    vim_item.menu = string.sub(m, 1, MAX_LABEL_WIDTH) .. SPACE_ELLIPSIS
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-y>'] = cmp.mapping.confirm { select = true },
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-k>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'crates' },
            },
        }
    end,
}

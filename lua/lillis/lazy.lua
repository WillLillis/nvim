-- Bootstrap lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        name = "kanagawa",
        config = function()
            require('kanagawa').setup({
                compile = true,
                transparent = true,
                -- theme = "dragon", -- Load "wave" theme when 'background' option is not set
                background = {     -- map the value of 'background' option to a theme
                    dark = "wave", -- dragon
                    light = "lotus"
                },
            })
            -- vim.cmd("colorscheme kanagawa-dragon") -- Darker but worse contrast
            vim.cmd("colorscheme kanagawa-wave")
            -- vim.cmd("colorscheme kanagawa")
        end,
    },

    -- Developing
    {
        -- "~/plugins/lsploghover.nvim"
        "WillLillis/lsploghover.nvim",
        lazy = true
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        name = "dap",
        lazy = true,
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        setup = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        }
    },

    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        },

        config = function()
            require("telescope").load_extension("lazygit")
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { "nvim-neotest/nvim-nio" }
    },

    {
        "christoomey/vim-tmux-navigator"
    },

    {
        "yorickpeterse/nvim-window",
        keys = {
            { "<leader>w", "<cmd>lua require('nvim-window').pick()<CR>", desc = "nvim-window: Jump to window" },
        },
        lazy = true,
    },

    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
            }
        end
    },

    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway
        vim.keymap.set("n", "<leader>tm", function() vim.cmd("Markview toggle") end,
            { desc = "[tm] Toggle markdown view" }),

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",

            "nvim-tree/nvim-web-devicons"
        }
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "debugloop/telescope-undo.nvim" },
        },
        lazy = true
    },

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        lazy = false
    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = false
    },

    {
        "debugloop/telescope-undo.nvim",
        lazy = false
    },

    {
        "nvim-tree/nvim-web-devicons",
        name = "devicons",
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        lazy = true
    },

    -- Wildmenu stuff
    { 'gelguy/wilder.nvim', opts = {}, lazy = false, },

    -- {
    --     "m4xshen/hardtime.nvim",
    --     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },afplll
    --     opts = {},
    -- },
    --
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
        lazy = false
    },

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = true },
        lazy = true
    },

    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = true,
    },

    {
        "theprimeagen/harpoon",
        lazy = true
    },

    {
        "mbbill/undotree",
        lazy = false
    },

    {
        "theprimeagen/vim-be-good",
        lazy = true
    },

    {
        "b0o/schemastore.nvim",
        lazy = true
    },

    {
        "mrcjkb/rustaceanvim",
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },

    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                'nvimdev/lspsaga.nvim',
                opts = {
                    lightbulb = { enable = false }
                },
                dependencies = {
                    'nvim-treesitter/nvim-treesitter',
                    'nvim-tree/nvim-web-devicons',
                }
            },

            -- Useful status updates for LSP.
            { 'j-hui/fidget.nvim', opts = {} },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end,
                        { desc = "gd Goto Definition" })
                    vim.keymap.set('n', "<leader>D", function() require('telescope.builtin').lsp_type_definitions() end,
                        { desc = "[D] goto type Definition" })
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                        { desc = "K hover support" })
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                        { desc = "[vws] View Workspace Symbols" })
                    vim.keymap.set("n", "<leader>vs", function() vim.lsp.buf.document_symbol() end,
                        { desc = "[vd] View document Symbols" })
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
                        { desc = "[vd] View Diagnostic" })
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
                        { desc = "[d goto next Diagnostic" })
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
                        { desc = "]d goto previous Diagnostic" })
                    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
                        { desc = "[vca] View Code Actions" })
                    vim.keymap.set('n', '<leader>vrr', function() require('telescope.builtin').lsp_references() end,
                        { desc = "[vrr] View References" })
                    -- vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end,
                    vim.keymap.set("n", "<leader>rn",
                        function()
                            vim.api.nvim_command([[:Lspsaga rename]])
                            local keys = vim.api.nvim_replace_termcodes('<ESC>A', true, false, true)
                            vim.api.nvim_feedkeys(keys, 'm', false)
                        end, { silent = true, desc = "[rn] Rename symbol" })
                    -- vim.keymap.set("n", "<leader>rn", function() require('lspsaga').lua.lspsaga.rename.new() end,
                    -- { desc = "[rn] Rename symbol" })
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                        { desc = "<C-h> signature Help" })
                    vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.format() end,
                        { desc = "[fr] Format" })

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP Specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                clangd = {},
                gopls = {},
                pyright = {},
                -- rust_analyzer = {
                -- Handled by rustaceanvim
                -- },
                -- Don't think these settings are correct...
                jsonls = {
                    settings = {
                        capabilities = capabilities,
                        json = {
                            schemas = require('schemastore').json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`tsserver`) will work just fine
                -- tsserver = {},
                --

                -- Handled by folke/lazydev.nvim
                -- lua_ls = {
                --
                -- },
            }

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            --
            --  You can press `g?` for help in this menu
            require('mason').setup()

            -- Better place for this?
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "sagarename",
                command = "nnoremap <buffer><silent> <ESC> <cmd>close!<CR>",
            })

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
            'saadparwaiz1/cmp_luasnip',

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}
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
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert {
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete {},

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    --['<C-h>'] = cmp.mapping(function()
                    ['<C-k>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),

                    -- For more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            }
        end,
    },
})

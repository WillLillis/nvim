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
                background = {  -- map the value of 'background' option to a theme
                    dark = "wave", -- dragon
                    light = "lotus"
                },
            })
            -- vim.cmd("colorscheme kanagawa-dragon") -- Darker but worse contrast
            -- vim.cmd("colorscheme kanagawa-wave")
            vim.cmd("colorscheme kanagawa")
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
        lazy = true
    },

    {
        "rcarriga/nvim-dap-ui",
        lazy = true
    },

    {
        "folke/neodev.nvim",
        name = "neodev",
        lazy = true
    },

    {
        "christoomey/vim-tmux-navigator"
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
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
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

    {
        "folke/trouble.nvim",
        name = "trouble",
        dependencies = { "nvim-web-devicons" },
        lazy = true
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
        "nvim-treesitter/nvim-treesitter",
        lazy = true
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
        "rush-rs/tree-sitter-asm",
        lazy = true
    },

    {
        "rafamadriz/friendly-snippets",
        lazy = true
    },

    {
        "b0o/schemastore.nvim",
        lazy = true
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
        lazy = true
    }
})

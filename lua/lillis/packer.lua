-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Developing
    use "~/plugins/lsploghover.nvim"
    --use "WillLillis/lsploghover.nvim"

    -- Debugging
    use 'mfussenegger/nvim-dap'

    use 'rcarriga/nvim-dap-ui'

    use {
        'folke/neodev.nvim',
        as = 'neodev'
    }

    use 'christoomey/vim-tmux-navigator'

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
            }
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    use { 'nvim-telescope/telescope-ui-select.nvim' }

    use({
        'rebelot/kanagawa.nvim',
        as = 'kanagawa',
        config = function()
            vim.cmd('colorscheme kanagawa')
        end
    })

    use({
        'nvim-tree/nvim-web-devicons',
        as = 'nvim-web-devicons',
    })

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            { 'nvim-tree/nvim-web-devicons', opt = true },
        }
    }

    use({
        'folke/trouble.nvim',
        as = 'trouble',
        requres = { 'nvim-web-devicons' },
    })

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use({
        'rust-lang/rust.vim',
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('theprimeagen/vim-be-good')
    use('rush-rs/tree-sitter-asm')

    use('rafamadriz/friendly-snippets')

    use "b0o/schemastore.nvim"

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)

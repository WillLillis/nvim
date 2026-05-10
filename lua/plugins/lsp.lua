return {
    src = "https://github.com/neovim/nvim-lspconfig",
    deps = {
        "https://github.com/williamboman/mason.nvim",
        "https://github.com/williamboman/mason-lspconfig.nvim",
        "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
        "https://github.com/folke/lazydev.nvim",
        "https://github.com/j-hui/fidget.nvim",
    },
    config = function()
        require("lazydev").setup({
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        })
        require("fidget").setup({})

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lillis-lsp-attach', { clear = true }),
            callback = function(event)
                vim.keymap.set("n", "<C-w>[", function()
                    vim.cmd("vsplit")
                    vim.cmd("wincmd l")
                    require('telescope.builtin').lsp_definitions()
                end, { desc = "C-w] Goto Definition (vertical split)" })
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
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end,
                    { desc = "[d goto next Diagnostic" })
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end,
                    { desc = "]d goto previous Diagnostic" })
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
                    { desc = "[vca] View Code Actions" })
                vim.keymap.set('n', '<leader>vr',
                    function() require('telescope.builtin').lsp_references({ include_current_line = true }) end,
                    { desc = "[vr] View References" })
                vim.keymap.set("n", "<leader>rn",
                    function()
                        vim.api.nvim_command([[:Lspsaga rename]])
                        local keys = vim.api.nvim_replace_termcodes('<ESC>_', true, false, true)
                        vim.api.nvim_feedkeys(keys, 'm', false)
                    end, { silent = true, desc = "[rn] Rename symbol" })
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                    { desc = "<C-h> signature Help" })
                vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.format() end,
                    { desc = "[fr] Format" })

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

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.workspace = capabilities.workspace or {}
        capabilities.workspace.didChangeWatchedFiles = {
            dynamicRegistration = true,
        }
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
            clangd = {},
        }

        require('mason').setup()

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sagarename",
            command = "nnoremap <buffer><silent> <ESC> <cmd>close!<CR>",
        })

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }
    end,
}

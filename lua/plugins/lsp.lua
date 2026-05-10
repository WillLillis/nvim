-- LSP orchestration. No nvim-lspconfig, no mason - servers are installed
-- via the system package manager (paru / cargo / local builds) and
-- configured directly via the builtin vim.lsp.config / vim.lsp.enable APIs
-- (Neovim 0.11+).
return {
    deps = {
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

        -- Buffer-local keymaps and autocmds set up when any LSP attaches.
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

        -- Lspsaga rename buffer: ESC closes
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sagarename",
            command = "nnoremap <buffer><silent> <ESC> <cmd>close!<CR>",
        })

        -- Register .tsg files as grammar_dsl filetype (used by ts_grammar_ls)
        vim.filetype.add({ extension = { tsg = "grammar_dsl" } })

        -- Default capabilities for all servers - cmp adds completion-related
        -- extras on top of the protocol baseline.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.workspace = capabilities.workspace or {}
        capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        vim.lsp.config('*', { capabilities = capabilities })

        -- Per-server configurations.
        vim.lsp.config('clangd', {
            cmd = { 'clangd' },
            filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
            root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
        })

        vim.lsp.config('lua_ls', {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = {
                '.luarc.json', '.luarc.jsonc', '.luacheckrc',
                '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git',
            },
        })

        vim.lsp.config('zls', {
            cmd = { '/home/lillis/projects/zls/zig-out/bin/zls' },
            filetypes = { 'zig', 'zir' },
            root_markers = { 'zls.json', 'build.zig', '.git' },
        })

        vim.lsp.config('bashls', {
            cmd = { 'bash-language-server', 'start' },
            filetypes = { 'bash', 'sh' },
            root_markers = { '.git' },
        })

        vim.lsp.config('jsonls', {
            cmd = { 'vscode-json-languageserver', '--stdio' },
            filetypes = { 'json', 'jsonc' },
            root_markers = { '.git' },
        })

        vim.lsp.config('taplo', {
            cmd = { 'taplo', 'lsp', 'stdio' },
            filetypes = { 'toml' },
            root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
        })

        vim.lsp.config('ts_ls', {
            cmd = { 'typescript-language-server', '--stdio' },
            filetypes = {
                'javascript', 'javascriptreact', 'javascript.jsx',
                'typescript', 'typescriptreact', 'typescript.tsx',
            },
            root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
        })

        vim.lsp.config('neocmake', {
            cmd = { 'neocmakelsp', '--stdio' },
            filetypes = { 'cmake' },
            root_markers = { '.git' },
        })

        vim.lsp.config('asm_lsp', {
            cmd = { '/home/lillis/projects/asm-lsp/target/release/asm-lsp' },
            filetypes = { 'asm' },
            root_markers = { '.asm-lsp.toml', '.git' },
        })

        vim.lsp.config('ts_query_ls', {
            cmd = { '/home/lillis/projects/ts_query_ls/target/debug/ts_query_ls' },
            filetypes = { 'query' },
            root_markers = { 'queries' },
            settings = {
                parser_install_directories = {
                    vim.fs.joinpath(
                        vim.fn.stdpath('data'),
                        '/site/pack/core/opt/nvim-treesitter/parser/'
                    ),
                },
                parser_aliases = {
                    ecma = 'javascript',
                },
                language_retrieval_patterns = {
                    'languages/src/([^/]+)/[^/]+\\.scm$',
                },
            },
        })

        vim.lsp.config('ts_grammar_ls', {
            cmd = { '/home/lillis/projects/ts_grammar_ls/target/release/ts_grammar_ls' },
            filetypes = { 'grammar_dsl' },
            root_markers = { 'grammar.tsg' },
        })

        vim.lsp.enable({
            'clangd',
            'lua_ls',
            'zls',
            'bashls',
            'jsonls',
            'taplo',
            'ts_ls',
            'neocmake',
            'asm_lsp',
            'ts_query_ls',
            'ts_grammar_ls',
        })
    end,
}

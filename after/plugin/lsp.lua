require("neodev").setup({
    -- Options go here, idk
})

local lsp = require("lsp-zero")

lsp.preset("recommended")

--lsp.ensure_installed({
--  'tsserver',
--  'eslint',
--  'lua_ls',
--  'rust_analyzer',
--  'clangd',
--})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vs", function() vim.lsp.buf.document_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() require('telescope.builtin').lsp_references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})

require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'tsserver',
        'rust_analyzer',
        -- 'asm-lsp',
        'clangd',
    },
    handlers = {
        lsp.default_setup,
    },
})

require("lspconfig").groovyls.setup {
    on_attach = lsp.on_attach,
    filetypes = { "groovy" },
    classpath = {
        "/home/lillis/.local/share/nvim/mason/packages/groovy-language-server/build/libs",
        "/home/lillis/.sdkman/candidates/groovy/current/lib",
        "/home/lillis/.sdkman/candidates/groovy/current/src/subprojects/groovy-groovydoc/src/test/groovy/org/codehaus/groovy/tools/groovydoc/testfiles/alias/lib",
        --"/path/where/the/files/are/located/lib",
        --"/second/path/where/the/files/are/located/lib",
    }
}

require('lspconfig').jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

lsp.setup()

return {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        vim.filetype.add({ extension = { tsg = "grammar_dsl" } })

        vim.api.nvim_create_autocmd('User', {
            pattern = 'TSUpdate',
            callback = function()
                require('nvim-treesitter.parsers').grammar_dsl = {
                    install_info = {
                        path = '/home/lillis/projects/grammars/tree-sitter-grammar-dsl',
                        queries = 'queries',
                    },
                }
            end,
        })
    end,
}

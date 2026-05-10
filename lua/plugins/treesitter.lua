return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Register .tsg files as grammar_dsl filetype
        vim.filetype.add({ extension = { tsg = "grammar_dsl" } })

        -- Register the custom parser for nvim-treesitter
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

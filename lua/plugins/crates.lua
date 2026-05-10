return {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
        require('crates').setup {
            completion = {
                cmp = {
                    enabled = true,
                },
                crates = {
                    enabled = true,
                    max_results = 8,
                    min_chars = 2,
                }
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            }
        }
    end
}

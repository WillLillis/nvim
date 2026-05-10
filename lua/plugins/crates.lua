return {
    src = "https://github.com/saecki/crates.nvim",
    version = "stable",
    config = function()
        require('crates').setup({
            completion = {
                -- Use blink.cmp's source instead of nvim-cmp.
                blink = { use_custom_kind = true },
                crates = {
                    enabled = true,
                    max_results = 8,
                    min_chars = 2,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        })
    end,
}

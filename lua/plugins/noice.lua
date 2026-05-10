return {
    src = "https://github.com/folke/noice.nvim",
    deps = {
        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/rcarriga/nvim-notify",
    },
    config = function()
        -- Make builtin cmdline completion show as a popup (Tab to invoke).
        vim.opt.wildmode = "longest:full,full"
        vim.opt.wildoptions = "pum"

        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
        })
    end,
}

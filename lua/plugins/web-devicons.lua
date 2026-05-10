return {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "devicons",
    config = function()
        require('nvim-web-devicons').setup({
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh"
                }
            },
            color_icons = true,
            default = true,
            strict = true,
            override_by_filename = {
                [".gitignore"] = {
                    icon = "",
                    color = "#f1502f",
                    name = "Gitignore"
                },
            },
            override_by_extension = {
                ["log"] = {
                    icon = "",
                    color = "#81e043",
                    name = "Log"
                },
                ["s"] = {
                    icon = "",
                    color = "#c31818",
                    name = "ASM",
                },
                ["asm"] = {
                    icon = "",
                    color = "#c31818",
                    name = "ASM",
                }
            },
        })
    end,
}

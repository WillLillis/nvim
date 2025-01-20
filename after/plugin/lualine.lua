local msg = ""

local get_msg = function()
    return msg
end

require('lualine').setup({
    options = { theme = "codedark" },
    sections = {
        lualine_x = {
            {
                get_msg,
                cond = function()
                    local noice_api = require("noice").api.status.mode
                    if noice_api.has() then
                        msg = noice_api.get()
                        return string.find(msg, "recording") ~= nil
                    end
                    return false
                end,
                color = { fg = "#ff9e64" },
            },
            'encoding', 'fileformat', 'filetype',
        },
    },
})

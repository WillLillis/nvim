return {
    src = "https://github.com/gelguy/wilder.nvim",
    config = function()
        local wilder = require('wilder')

        wilder.setup({
            modes = { ':', '/', '?' },
            next_key = '<C-n>',
            previous_key = '<C-p>',
            accept_key = '<C-y>',
            reject_key = ' ',
        })

        wilder.set_option('pipeline', {
            wilder.branch(
                wilder.python_file_finder_pipeline({
                    file_command = { 'find', '.', '-type', 'f', '-printf', '%P\n' },
                    dir_command = { 'find', '.', '-type', 'd', '-printf', '%P\n' },
                    filters = { 'fuzzy_filter', 'difflib_sorter' },
                }),
                wilder.cmdline_pipeline(),
                wilder.python_search_pipeline()
            ),
        })

        local gradient = {
            '#f4468f', '#fd4a85', '#ff507a', '#ff566f', '#ff5e63',
            '#ff6658', '#ff704e', '#ff7a45', '#ff843d', '#ff9036',
            '#f89b31', '#efa72f', '#e6b32e', '#dcbe30', '#d2c934',
            '#c8d43a', '#bfde43', '#b6e84e', '#aff05b'
        }

        for i, fg in ipairs(gradient) do
            gradient[i] = wilder.make_hl('WilderGradient' .. i, 'Pmenu',
                { { a = 1 }, { a = 1 }, { foreground = fg } })
        end

        wilder.set_option('renderer', wilder.popupmenu_renderer({
            highlights = {
                gradient = gradient,
            },
            highlighter = wilder.highlighter_with_gradient({
                wilder.basic_highlighter(),
            }),
            left = { ' ', wilder.popupmenu_devicons() },
            right = { ' ', wilder.popupmenu_scrollbar() },
            max_height = 15,
        }))
    end,
}

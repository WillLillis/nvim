-- Terminal stuff
vim.api.nvim_command("autocmd TermOpen * startinsert") -- starts in insert mode
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber")

-- Line wrapping for LaTeX and Markdown files
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.md', '*.tex' },
    -- group = group, -- Need to RTFM
    command = 'setlocal wrap'
})

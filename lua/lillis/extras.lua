-- Terminal stuff
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber")
vim.api.nvim_command("autocmd TermOpen * startinsert") -- starts in insert mode

-- Line wrapping for LaTeX and Markdown files
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.md', '*.tex' },
    -- group = group, -- Need to RTFM
    command = 'setlocal wrap'
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('lillis-highlight-yank', { clear = true }),
    callback = function ()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'query',
  callback = function(ev)
    if vim.bo[ev.buf].buftype == 'nofile' then
      return
    end
    vim.lsp.start {
      name = 'ts_query_ls',
      cmd = { '/home/lillis/projects/ts_query_ls/target/debug/ts_query_ls' },
      root_dir = vim.fs.root(0, { 'queries' }),
      settings = {
        parser_install_directories = {
          -- If using nvim-treesitter with lazy.nvim
          vim.fs.joinpath(
            vim.fn.stdpath('data'),
            '/lazy/nvim-treesitter/parser/'
          ),
        },
        parser_aliases = {
          ecma = 'javascript',
        },
        language_retrieval_patterns = {
          'languages/src/([^/]+)/[^/]+\\.scm$',
        },
      },
    }
  end,
})

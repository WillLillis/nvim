vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- Define the function to compile LaTeX
local function compile_latex()
    local current_dir = vim.fn.expand('%:p:h') -- Get the current buffer's directory
    local cmd = string.format("if pdflatex %s/main.tex ; then xpdf main.pdf -title %s/main.tex & else fi", current_dir, current_dir)
    vim.fn.system(cmd)
end
-- latex compile
vim.keymap.set("n", "<leader>tex", function()
    compile_latex()
end, { noremap = true, silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("v", "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "leader<k>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "leader<j>", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod + x %<CR>", { silent = true })

-- Define a custom command ":W" that executes ":w"
vim.cmd('command! -nargs=0 W w')
-- Map the key sequence ":W" to the custom command
vim.keymap.set('c', ':W', ':W<CR>', { noremap = true, silent = true })

-- Remap to toggle on the Trouble plugin window
vim.keymap.set("n", "<leader>tr", function() require("trouble").toggle() end)

-- Exit terminal mode with Esc
vim.api.nvim_exec([[
  autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
]], false)

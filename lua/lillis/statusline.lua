-- Builtin statusline. Mode + git branch/diff + file + diagnostics, then
-- right-aligned recording / encoding / filetype-with-icon / line:col /
-- line-percentage. Uses kanagawa-dragon palette for mode colors.

local M = {}

-- ─── Mode ────────────────────────────────────────────────────────────────
-- Each mode entry: { label, mode-hl, caret-hl }. The caret-hl carries the
-- mode's bg as its fg with the section bg behind it, which produces the
-- Powerline triangle transition into the section block.
local mode_map = {
    ['n']    = { 'NORMAL',   'StatuslineModeNormal',   'StatuslineCaretNormal' },
    ['no']   = { 'O-PEND',   'StatuslineModeNormal',   'StatuslineCaretNormal' },
    ['i']    = { 'INSERT',   'StatuslineModeInsert',   'StatuslineCaretInsert' },
    ['ic']   = { 'INSERT',   'StatuslineModeInsert',   'StatuslineCaretInsert' },
    ['v']    = { 'VISUAL',   'StatuslineModeVisual',   'StatuslineCaretVisual' },
    ['V']    = { 'V-LINE',   'StatuslineModeVisual',   'StatuslineCaretVisual' },
    ['\22']  = { 'V-BLOCK',  'StatuslineModeVisual',   'StatuslineCaretVisual' },
    ['s']    = { 'SELECT',   'StatuslineModeVisual',   'StatuslineCaretVisual' },
    ['S']    = { 'S-LINE',   'StatuslineModeVisual',   'StatuslineCaretVisual' },
    ['c']    = { 'COMMAND',  'StatuslineModeCommand',  'StatuslineCaretCommand' },
    ['r']    = { 'PROMPT',   'StatuslineModeCommand',  'StatuslineCaretCommand' },
    ['R']    = { 'REPLACE',  'StatuslineModeReplace',  'StatuslineCaretReplace' },
    ['t']    = { 'TERMINAL', 'StatuslineModeTerminal', 'StatuslineCaretTerminal' },
}

-- Powerline triangle glyphs (Nerd Font / Powerline-patched).
local CARET_RIGHT = '\u{E0B0}' --
local CARET_LEFT  = '\u{E0B2}' --

function _G.lillis_mode()
    local entry = mode_map[vim.fn.mode()]
        or { vim.fn.mode():upper(), 'StatuslineModeNormal', 'StatuslineCaretNormal' }
    -- Mode badge, then a right-pointing Powerline caret rendered with the
    -- mode color as fg and section bg behind it.
    return string.format('%%#%s# %s %%#%s#%s%%#StatuslineSection#',
        entry[2], entry[1], entry[3], CARET_RIGHT)
end

-- ─── Git branch + diff ───────────────────────────────────────────────────
function _G.lillis_branch()
    local b = vim.b.gitsigns_status_dict
    if b and b.head and b.head ~= "" then
        return '  ' .. b.head -- nf-oct-git_branch
    end
    return ''
end

function _G.lillis_diff()
    local b = vim.b.gitsigns_status_dict
    if not b then return '' end
    local parts = {}
    if b.added and b.added > 0 then
        table.insert(parts, string.format('%%#StatuslineDiffAdd#+%d', b.added))
    end
    if b.changed and b.changed > 0 then
        table.insert(parts, string.format('%%#StatuslineDiffChange#~%d', b.changed))
    end
    if b.removed and b.removed > 0 then
        table.insert(parts, string.format('%%#StatuslineDiffDelete#-%d', b.removed))
    end
    if #parts == 0 then return '' end
    return '  %#StatuslineSep#│%#StatuslineSection# ' .. table.concat(parts, ' ') .. '%#StatuslineSection#'
end

-- ─── Diagnostics ─────────────────────────────────────────────────────────
function _G.lillis_diag()
    local counts = { 0, 0, 0, 0 } -- error, warn, info, hint
    for _, d in ipairs(vim.diagnostic.get(0)) do
        counts[d.severity] = counts[d.severity] + 1
    end
    local out = {}
    if counts[1] > 0 then table.insert(out, string.format('%%#StatuslineDiagError# E%d ', counts[1])) end
    if counts[2] > 0 then table.insert(out, string.format('%%#StatuslineDiagWarn# W%d ', counts[2])) end
    if counts[3] > 0 then table.insert(out, string.format('%%#StatuslineDiagInfo# I%d ', counts[3])) end
    if counts[4] > 0 then table.insert(out, string.format('%%#StatuslineDiagHint# H%d ', counts[4])) end
    if #out == 0 then return '' end
    return ' ' .. table.concat(out, '') .. '%*'
end

-- ─── Recording ───────────────────────────────────────────────────────────
function _G.lillis_recording()
    local rec = vim.fn.reg_recording()
    if rec ~= "" then return '%#StatuslineRecording# [REC @' .. rec .. '] %*' end
    return ''
end

-- ─── Position (fixed width so it doesn't jump while scrolling) ──────────
function _G.lillis_pos()
    return string.format(' %4d:%-3d ', vim.fn.line('.'), vim.fn.col('.'))
end

-- ─── Cursor progress: Top / Bot / NN% (always 3 chars wide) ────────────
-- Cursor-based (matches lualine's `progress` component, not vim's %P
-- which is viewport-based and shows "Bot" when the LAST visible line is
-- the bottom of the file - feels off when scrolling).
function _G.lillis_pct()
    local cur = vim.fn.line('.')
    local total = vim.fn.line('$')
    if cur == 1 then return ' Top ' end
    if cur >= total then return ' Bot ' end
    return string.format(' %2d%% ', math.floor(cur / total * 100))
end

-- ─── Filetype with icon (web-devicons) ───────────────────────────────────
-- web-devicons returns a highlight group with the icon's fg color but
-- its own bg (transparent/default), which produces a visible bg seam
-- against StatuslineSection. We synthesize a combined group per icon-hl
-- (cached) that uses the devicon's fg with StatuslineSection's bg.
local ft_hl_cache = {}
local function get_ft_combined_hl(icon_hl)
    if ft_hl_cache[icon_hl] then return ft_hl_cache[icon_hl] end
    local combined = 'StatuslineFt_' .. icon_hl
    local icon_fg = (vim.api.nvim_get_hl(0, { name = icon_hl, link = false }) or {}).fg
    local section_bg = (vim.api.nvim_get_hl(0, { name = 'StatuslineSection', link = false }) or {}).bg
    vim.api.nvim_set_hl(0, combined, { fg = icon_fg, bg = section_bg })
    ft_hl_cache[icon_hl] = combined
    return combined
end

function _G.lillis_filetype()
    local ft = vim.bo.filetype
    if ft == '' then return '' end
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
        local icon, icon_hl = devicons.get_icon_by_filetype(ft, { default = true })
        if icon and icon_hl then
            local combined = get_ft_combined_hl(icon_hl)
            return string.format(' %%#%s#%s %%#StatuslineSection#%s ', combined, icon, ft)
        end
    end
    return ' ' .. ft .. ' '
end

-- ─── Layout ──────────────────────────────────────────────────────────────
-- A single section background runs the entire middle of the statusline
-- (between the mode badge on the left and the cursor/percentage block
-- on the right). Diagnostics and recording are inline with colored fg
-- against the same section bg for visual consistency.
vim.opt.statusline = table.concat({
    '%{%v:lua.lillis_mode()%}',
    '%#StatuslineSection#',
    '%{v:lua.lillis_branch()}',
    '%{%v:lua.lillis_diff()%} ',
    ' %f %m %r ',
    '%{%v:lua.lillis_diag()%}',
    '%#StatuslineSection#',
    '%=',
    '%{%v:lua.lillis_recording()%}',
    '%#StatuslineSection# %{&fileencoding} ',
    '%{%v:lua.lillis_filetype()%}',
    '%{v:lua.lillis_pct()}',
    '%#StatuslineCaretNormal#' .. CARET_LEFT,
    '%#StatuslineModeNormal#%{v:lua.lillis_pos()}',
}, '')

-- ─── Highlight groups (kanagawa-dragon palette) ──────────────────────────
local function set_hl()
    -- Mode badges (left edge + right percentage block)
    vim.api.nvim_set_hl(0, 'StatuslineModeNormal',   { fg = '#181616', bg = '#8a9a7b', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineModeInsert',   { fg = '#181616', bg = '#8ba4b0', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineModeVisual',   { fg = '#181616', bg = '#a292a3', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineModeCommand',  { fg = '#181616', bg = '#c4b28a', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineModeReplace',  { fg = '#181616', bg = '#c4746e', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineModeTerminal', { fg = '#181616', bg = '#8ea4a2', bold = true })
    -- Subtle section background for branch/encoding/filetype/line:col
    vim.api.nvim_set_hl(0, 'StatuslineSection',      { fg = '#c5c9c5', bg = '#2a2929' })
    -- Powerline carets between mode badges and section: caret fg = mode bg,
    -- caret bg = section bg. Renders as a colored triangle on dark.
    vim.api.nvim_set_hl(0, 'StatuslineCaretNormal',   { fg = '#8a9a7b', bg = '#2a2929' })
    vim.api.nvim_set_hl(0, 'StatuslineCaretInsert',   { fg = '#8ba4b0', bg = '#2a2929' })
    vim.api.nvim_set_hl(0, 'StatuslineCaretVisual',   { fg = '#a292a3', bg = '#2a2929' })
    vim.api.nvim_set_hl(0, 'StatuslineCaretCommand',  { fg = '#c4b28a', bg = '#2a2929' })
    vim.api.nvim_set_hl(0, 'StatuslineCaretReplace',  { fg = '#c4746e', bg = '#2a2929' })
    vim.api.nvim_set_hl(0, 'StatuslineCaretTerminal', { fg = '#8ea4a2', bg = '#2a2929' })
    -- Subtle separator between branch and diff stats
    vim.api.nvim_set_hl(0, 'StatuslineSep',          { fg = '#54546d', bg = '#2a2929' })
    -- Git diff stats: green/yellow/red on section bg
    vim.api.nvim_set_hl(0, 'StatuslineDiffAdd',      { fg = '#8a9a7b', bg = '#2a2929', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineDiffChange',   { fg = '#c4b28a', bg = '#2a2929', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineDiffDelete',   { fg = '#c4746e', bg = '#2a2929', bold = true })
    -- Diagnostics (colored fg on section bg so the bar reads as one unit)
    vim.api.nvim_set_hl(0, 'StatuslineDiagError',    { fg = '#c4746e', bg = '#2a2929', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineDiagWarn',     { fg = '#c4b28a', bg = '#2a2929', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineDiagInfo',     { fg = '#8ba4b0', bg = '#2a2929', bold = true })
    vim.api.nvim_set_hl(0, 'StatuslineDiagHint',     { fg = '#8a9a7b', bg = '#2a2929', bold = true })
    -- Recording (orange fg on section bg)
    vim.api.nvim_set_hl(0, 'StatuslineRecording',    { fg = '#ff9e64', bg = '#2a2929', bold = true })
end
set_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        set_hl()
        ft_hl_cache = {} -- combined ft hl colors must be rebuilt against new section bg
    end,
})

-- Force statusline redraw for transient state changes.
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave', 'ModeChanged', 'DiagnosticChanged' }, {
    callback = function() vim.cmd.redrawstatus() end,
})

return M

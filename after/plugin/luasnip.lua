if not pcall(require, "luasnip") then
    return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config {
    history = true,

    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,

    ext_ops = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "<-", "Error" } },
            },
        },
    },
}

vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

-- For iterating
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<Return>",
    { desc = "[[s]] Source luasnip.lua file" })

-- create snippet
-- s(context, nodes, condition, ...)
local snippet = ls.s

-- TODO: Write about this.
--  Useful for dynamic nodes and choice nodes
local snippet_from_nodes = ls.sn

-- This is the simplest node.
--  Creates a new text node. Places cursor after node by default.
--  t { "this will be inserted" }
--
--  Multiple lines are by passing a table of strings.
--  t { "line 1", "line 2" }
local t = ls.text_node

-- Insert Node
--  Creates a location for the cursor to jump to.
--      Possible options to jump to are 1 - N
--      If you use 0, that's the final place to jump to.
--
--  To create placeholder text, pass it as the second argument
--      i(2, "this is placeholder text")
local i = ls.insert_node

-- Function Node
--  Takes a function that returns text
local f = ls.function_node

-- This a choice snippet. You can move through with <c-l> (in my config)
--   c(1, { t {"hello"}, t {"world"}, }),
--
-- The first argument is the jump position
-- The second argument is a table of possible nodes.
--  Note, one thing that's nice is you don't have to include
--  the jump position for nodes that normally require one (can be nil)
local c = ls.choice_node

local d = ls.dynamic_node

local rep = require("luasnip.extras").rep

-- TODO: Document what I've learned about lambda
local l = require("luasnip.extras").lambda

local events = require "luasnip.util.events"

local fmt = require("luasnip.extras.fmt").fmt
-- ls.add_snippets("all", {
--     -- basic, don't need to know anything else
--     --    arg 1: string
--     --    arg 2: a node
--     snippet("simple", t "wow, you were right!"),
--
-- })

-- Snippet for writing an XML file for asm-lsp
ls.add_snippets("xml", {
    snippet("<D",
        fmt(
            "<Directive name=\"{}\" md_displaytext=\".{}{}\" url_fragment=\"{}\" md_description=\"{}\">\n</Directive>",
            {
                i(1, "Name"),
                rep(1),
                i(2, "Markdown Display Text"),
                i(3, "URL Fragment"),
                i(4, "Markdown Description"),
            })
    ),
})

ls.add_snippets("all", {
    snippet("lsp",
        fmt(
            "LSPLOGHOVER<{}>",
            {
                i(1, "Log"),
            })
    ),
})

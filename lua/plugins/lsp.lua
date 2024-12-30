local l = require 'lspconfig'
local langs = {
  "ts_ls", "svelte", "nushell", "basedpyright", "nil_ls", "vala_ls",
  "bashls", "tailwindcss", "astro", "ruff_lsp", "lua_ls", "marksman"
}

for _, x in pairs(langs) do
  l[x].setup {}
end

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.g.autoformat = false
-- Set clipboard to use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Remap 'c', 'C', 'd', 'D', 'x' and 'X' to save text in a custom register
vim.keymap.set("n", "c", '"cc')
vim.keymap.set("v", "c", '"cc')
vim.keymap.set("n", "C", '"cC')
vim.keymap.set("v", "C", '"cC')

vim.keymap.set("n", "d", '"dd')
vim.keymap.set("v", "d", '"dd')
vim.keymap.set("n", "D", '"dD')
vim.keymap.set("v", "D", '"dD')

vim.keymap.set("n", "x", '"xx')
vim.keymap.set("v", "x", '"xx')
vim.keymap.set("n", "X", '"xX')
vim.keymap.set("v", "X", '"xX')

vim.diagnostic.config({update_in_insert = true})

return {}

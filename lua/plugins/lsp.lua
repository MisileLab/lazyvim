local l = require 'lspconfig'
local langs = {
  "ts_ls", "svelte", "nushell", "basedpyright", "nil_ls", "vala_ls",
  "nushell", "bashls", "tailwindcss", "astro", "ruff", "lua_ls", "marksman", "zls",
  "clangd", "hls", "jsonls", "gopls", "kotlin_language_server",
  "ruby_lsp", "rust_analyzer", "metals", "taplo", "yamlls", "svelte", "ts_ls"
}

for _, x in pairs(langs) do
  l[x].setup {}
end

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.g.autoformat = false
vim.b.autoformat = false
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

local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

local function text_format(symbol)
  local res = {}

  local round_start = { '', 'SymbolUsageRounding' }
  local round_end = { '', 'SymbolUsageRounding' }

  -- Indicator that shows if there are any other symbols in the same line
  local stacked_functions_content = symbol.stacked_count > 0
      and ("+%s"):format(symbol.stacked_count)
      or ''

  if symbol.references then
    local usage = symbol.references <= 1 and 'usage' or 'usages'
    local num = symbol.references == 0 and 'no' or symbol.references
    table.insert(res, round_start)
    table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
    table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if symbol.definition then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
    table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if symbol.implementation then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
    table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if stacked_functions_content ~= '' then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { ' ', 'SymbolUsageImpl' })
    table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  return res
end

return {
  {"nvim-treesitter", enabled = true},
  {"nvim-treesitter-textobjects", enabled = false},
  -- https://github.com/geldata/edgedb-vim/pull/12
  {"florisbosch/edgedb-vim", version = false},
  {"LhKipp/nvim-nu", version = false},
  {
    'Wansmer/symbol-usage.nvim',
    event = 'BufReadPre', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require('symbol-usage').setup({
        text_format = text_format,
      })
    end
  },
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "openai",
      -- auto_suggestions_provider = "openai",
      providers = {
        copilot = {
          model = "gpt-4.1"
        },
        openai = {
          model = "gpt-4.1-nano"
        }
      },
      behaviour = {
        auto_suggestions = true;
      },
      web_search_engine = {
        provider = "tavily"
      }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "folke/snacks.nvim", -- for input provider snacks
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            verbose = false
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}

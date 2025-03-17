vim.keymap.set("n", "<leader>gC", ":CoAuthor<CR>")

return {
  {
    {
      "LazyVim/LazyVim",
      version = false,
      opts = {
        colorscheme = "catppuccin";
      }
    },
    { "folke/lazy.nvim",       version = false },
    { "wakatime/vim-wakatime", lazy = false, version = false },
    {
      "2kabhishek/nerdy.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim"
      },
      cmd = "Nerdy",
      version = false
    },
    { "neovim/nvim-lspconfig",
      opts = {
        diagnostics = {
          update_in_insert = true
        }
      },
      version = false
    },
    {"2kabhishek/co-author.nvim", version = false},
    {"m4xshen/hardtime.nvim", version = false, dependencies = { "MunifTanjim/nui.nvim" }, opts = {}},
    {"akinsho/git-conflict.nvim", version = false, config = true}
  }
}

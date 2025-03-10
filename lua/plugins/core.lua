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
    { "wakatime/vim-wakatime", lazy = false },
    {
      "2kabhishek/nerdy.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim"
      },
      cmd = "Nerdy"
    },
    { "neovim/nvim-lspconfig",
      opts = {
        diagnostics = {
          update_in_insert = true
        }
      }
    },
    {"2kabhishek/co-author.nvim"}
  }
}

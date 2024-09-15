return {

  -- Getting LSP and formatter from Mason.
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "bash-language-server", "beautysh" } },
  },

  -- Setting up LSP.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { bashls = {} },
    },
  },

  -- Setting up formatter.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "beautysh" },
      },
    },
  },
}

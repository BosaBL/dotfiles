return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "hyprls")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { hyprls = {} },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "hyprlang", "rasi" } },
  },
}

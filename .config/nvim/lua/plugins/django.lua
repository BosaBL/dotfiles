return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "django-template-lsp", "djlint" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        html = { "djlint" },
        htmldjango = { "djlint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        htmldjango = { "djlint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        djlsp = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Method",
        ft = "python",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Class",
        ft = "python",
      },
    },
    opts = {
      justMyCode = false,
    },
    config = function(_, opts)
      if vim.fn.has("win32") == 1 then
        require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"), opts)
      else
        require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"), opts)
      end
    end,
  },
}

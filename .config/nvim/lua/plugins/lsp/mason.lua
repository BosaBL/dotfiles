return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
      ensure_installed = {
        "bash-language-server",
        "css-lsp",
        "dockerfile-language-server",
        "eslint-lsp",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "markdownlint-cli2",
        "pyright",
        "rust-analyzer",
        "vtsls",
        "ruff",
        "texlab",
      },
    },
  },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "eslint_d",
        "prettier",
        "tex-fmt",
      },
    },
  },
}

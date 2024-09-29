return {
  "uga-rosa/ccc.nvim",
  lazy = false,
  opts = {
    -- Your preferred settings
    -- Example: enable highlighter
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  keys = {
    { "<leader>ccp", "<cmd>CccPick<cr>", desc = "Color picker" },
    { "<leader>ccc", "<cmd>CccConvert<cr>", desc = "Color convert" },
    { "<leader>cct", "<cmd>CccHighlighterEnable<cr>", desc = "Color picker" },
  },
}

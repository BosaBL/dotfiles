return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      os_name = require("utils.get_os").get_os()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      -- Vimtex configuration
      if os_name ~= "windows" then
        vim.g.vimtex_view_method = "zathura"
      else
        vim.g.vimtex_view_general_viewer = "SumatraPDF"
        vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
      end
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 1,
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "--shell-escape",
        },
      }
      vim.g.vimtex_view_automatic = 0 -- Set to 0 since we handle it with autocmd

      -- Enable word wrapping for tex and bib files.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "bib" },
        callback = function(event)
          vim.opt_local.wrap = true
        end,
      })

      local au_group = vim.api.nvim_create_augroup("vimtex_events", {})

      -- Forward-search on each successful compilation
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventCompileSuccess",
        group = au_group,
        callback = function(args)
          vim.cmd("VimtexView")
        end,
      })
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtext" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "tex-fmt" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["tex"] = { "tex-fmt" },
      },
    },
  },
}

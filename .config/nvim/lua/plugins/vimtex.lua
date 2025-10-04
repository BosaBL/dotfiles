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
        vim.g.vimtex_view_method = "zathura_simple"
      else
        vim.g.vimtex_view_general_viewer = "SumatraPDF"
        vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
      end

      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_indent_enabled = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "--shell-escape",
        },
      }

      -- Enable word wrapping for tex and bib files.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "bib" },
        callback = function(event)
          vim.opt_local.wrap = true
        end,
      })

      local au_group = vim.api.nvim_create_augroup("vimtex_events", {})

      -- Clean on exit
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventQuit",
        group = au_group,
        command = "VimtexClean",
      })

      -- Focus the terminal after inverse search
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventViewReverse",
        group = au_group,
        command = "call b:vimtex.viewer.xdo_focus_vim()",
      })

      -- Forward-search on save
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventCompileSuccess",
        group = au_group,
        callback = function(args)
          -- For some reason, vimtex opens the PDF viewer twice
          -- when compoling for the first time, so we start forward search
          -- only after the first compile.
          if vim.g.vimtex_first_compile then
            vim.cmd("VimtexView")
          else
            vim.g.vimtex_first_compile = true
          end
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

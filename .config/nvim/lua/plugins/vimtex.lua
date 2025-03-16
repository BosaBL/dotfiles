return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

    -- Vimtex configuration
    vim.g["vimtex_compiler_method"] = "latexmk"
    vim.g["vimtex_view_method"] = "zathura"
    vim.g["vimtex_view_general_method"] = "zathura"
    vim.g["vimtex_compiler_progname"] = "nvr"
    vim.g["vimtex_quickfix_open_on_warning"] = 0
    vim.g["vimtex_compiler_latexmk"] = {
      executable = "latexmk",
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "--shell-escape",
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "bib" },
      callback = function(event)
        vim.opt_local.wrap = true
      end,
    })
  end,

  keys = {
    { "<localLeader>l", "", desc = "+vimtext" },
  },
}

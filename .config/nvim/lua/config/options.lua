-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Vimtex configuration
vim.g["vimtex_compiler_method"] = "latexmk"
vim.g["vimtex_view_method"] = "zathura"
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

-- Leader remaps
vim.g.maplocalleader = " "

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.del("<Leader>l")
local map = LazyVim.safe_keymap_set

map("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode using jj" })
map("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode using jk" })

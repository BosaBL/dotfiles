-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local os_name = require("utils.get_os").get_os()

-- Leader remaps
vim.g.maplocalleader = " "

-- vim.g.lazyvim_picker = "snacks"
vim.g.root_spec = { "cwd" }

-- setup pwsh if on windows.
if os_name == "windows" then
	LazyVim.terminal.setup("pwsh")
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function(arg)
					vim.opt.relativenumber = true
				end,
			},
			{
				event = "file_open_requested",
				handler = function()
					-- auto close
					-- vim.cmd("Neotree close")
					-- OR
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
	},
}

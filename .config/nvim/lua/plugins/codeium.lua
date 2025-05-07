return {

	-- codeium
	{
		"Exafunction/windsurf.nvim",
		opts = {
			enable_cmp_source = vim.g.ai_cmp,
			virtual_text = {
				enabled = not vim.g.ai_cmp,
				key_bindings = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
		config = function(_, opts)
			require("codeium").setup(opts)
		end,
	},

	-- add ai_accept action
	{
		"Exafunction/windsurf.nvim",
		opts = function()
			LazyVim.cmp.actions.ai_accept = function()
				if require("codeium.virtual_text").get_current_completion_item() then
					LazyVim.create_undo()
					vim.api.nvim_input(require("codeium.virtual_text").accept())
					return true
				end
			end
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))
		end,
	},

	vim.g.ai_cmp and {
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "windsurf.nvim", "saghen/blink.compat" },
		opts = {
			sources = {
				compat = { "codeium" },
				providers = {
					codeium = {
						kind = "Codeium",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	} or nil,
}

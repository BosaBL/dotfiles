return {
	{
		"garymjr/nvim-snippets",
		enabled = false,
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function(_, opts)
					require("luasnip.loaders.from_lua").lazy_load({ paths = { "./luasnip/" } })
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		opts = {
			history = true,
			store_selection_keys = "<Tab>",
			enable_autosnippets = true,
			update_events = "TextChanged,TextChangedI",
			delete_check_events = "TextChanged",
		},
	},
	{
		"saghen/blink.cmp",
		opts = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_next", "snippet_backward", "fallback" },
			},
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			completion = {
				list = { selection = { preselect = false } },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}

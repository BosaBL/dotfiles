return {
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
}

return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
		config = function(_, opts)
			require("luasnip.loaders.from_lua").load({ paths = "./luasnip/" })
			require("luasnip").config.set_config(opts)
		end,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				"nvim-cmp",
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
				},
				opts = function(_, opts)
					opts.snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					}
					table.insert(opts.sources, { name = "luasnip" })
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
		"garymjr/nvim-snippets",
		enabled = false,
	},
}

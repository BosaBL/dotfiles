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
					require("luasnip.loaders.from_vscode").lazy_load({ exclude = "tex" })
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
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
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
			sources = {
				default = { "lsp", "path", "luasnip", "buffer" },
			},
		},
	},
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			opts.sources.default = vim.tbl_filter(function(p)
				return p ~= "snippets"
			end, opts.sources.default)
		end,
	},
}

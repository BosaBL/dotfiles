return {
	"saghen/blink.cmp",
	opts = {
		keymap = {
			preset = "enter",
			["<C-k>"] = { "select_prev", "fallback_to_mappings" },
			["<C-j>"] = { "select_next", "fallback_to_mappings" },
		},
		completion = {
			list = {
				selection = {
					preselect = function(ctx)
						return not require("blink.cmp").snippet_active({ direction = 1 })
					end,
				},
			},
		},
	},
}

return {
	"saghen/blink.cmp",
	opts = {
		keymap = {
			preset = "enter",
			["<C-k>"] = { "select_prev", "fallback_to_mappings" },
			["<C-j>"] = { "select_next", "fallback_to_mappings" },
		},
		signature = { enabled = true },
		completion = {
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
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

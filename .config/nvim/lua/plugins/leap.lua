return {
	"ggandor/leap.nvim",
	enabled = true,
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
		{
			"gS",
			mode = { "n", "x", "o" },
			function()
				require("leap.remote").action()
			end,
			desc = "Leap remote",
		},
		{
			"ga",
			mode = { "n", "x", "o" },
			function()
				require("leap.treesitter").select()
			end,
			desc = "Leap treesitter select",
		},
	},
}

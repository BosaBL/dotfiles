return {
	"rafamadriz/friendly-snippets",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load({
			exclude = { "latex", "tex", "plaintex", "python", "javascript" },
		})
	end,
}

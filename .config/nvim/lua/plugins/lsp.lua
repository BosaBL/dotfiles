return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			pyright = {
				settings = {
					pyright = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
		},
	},
}

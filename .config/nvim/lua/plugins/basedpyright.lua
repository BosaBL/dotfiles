return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              autoImportCompletions = true,
            },
          },
        },
      },
    },
  },
}

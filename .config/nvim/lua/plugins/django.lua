return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        htmldjango = { "djlint" },
        html = { "djlint" },
      },
      formatters = {
        djlint = {
          command = "djlint",
          args = { "--profile=django", "--reformat", "-" },
          sdtin = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        html = { "djlint" },
        htmldjango = { "djlint" },
      },
      linters = {
        djlint = {
          args = {
            "--profile=django",
            "--linter-output-format",
            "{line}:{code}: {message}",
            "-",
          },
        },
      },
    },
  },
}

return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = { "tex", "plaintex", "bib" },
			root = { ".latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml" },
		})
	end,

	-- Add BibTeX/LaTeX to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.highlight = opts.highlight or {}
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "bibtex" })
			end
			if type(opts.highlight.disable) == "table" then
				vim.list_extend(opts.highlight.disable, { "latex" })
			else
				opts.highlight.disable = { "latex" }
			end
		end,
	},
	{
		"lervag/vimtex",
		lazy = false, -- lazy-loading will disable inverse search
		config = function()
			vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
			vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

			-- Vimtex configuration
			vim.g["vimtex_compiler_method"] = "latexmk"
			vim.g["vimtex_view_method"] = "zathura"
			vim.g["vimtex_view_general_method"] = "zathura"
			vim.g["vimtex_compiler_progname"] = "nvr"
			vim.g["vimtex_quickfix_open_on_warning"] = 0
			vim.g["vimtex_compiler_latexmk"] = {
				executable = "latexmk",
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"--shell-escape",
				},
			}
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "tex", "bib" },
				callback = function(event)
					vim.opt_local.wrap = true
				end,
			})
			local augroup = vim.api.nvim_create_augroup("VimtexGroup", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "VimtexEventCompileSuccess",
				group = augroup,
				command = "VimtexView",
			})
		end,
		keys = {
			{ "<localLeader>l", "", desc = "+vimtext" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				texlab = {
					keys = {
						{ "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
					},
				},
			},
		},
	},
}

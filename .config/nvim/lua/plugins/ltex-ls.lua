local dictionary_file_path = vim.fn.stdpath("config") .. "/spell/es.utf-8.spl"
local words = {}
for word in io.lines(dictionary_file_path) do
	table.insert(words, word)
end

return {
	-- "neovim/nvim-lspconfig",
	-- opts = {
	-- 	servers = {
	-- 		ltex = {
	-- 			settings = {
	-- 				-- https://valentjn.github.io/ltex/settings.html
	-- 				ltex = {
	-- 					dictionary = {
	-- 						["es"] = words,
	-- 					},
	-- 					language = "es",
	-- 					additionalRules = {
	-- 						enablePickyRules = true,
	-- 						motherTongue = "es",
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}

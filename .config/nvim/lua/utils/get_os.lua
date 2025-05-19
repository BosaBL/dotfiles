local M = {}

function M.get_os()
	if vim.fn.has("mac") == 1 then
		return "macos"
	elseif vim.fn.has("unix") == 1 then
		return "linux"
	elseif vim.fn.has("win32") == 1 then
		return "windows"
	else
		return "unknown"
	end
end

return M

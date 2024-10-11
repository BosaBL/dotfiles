local ls = require("luasnip")
local M = {}
s = ls.snippet
sn = ls.snippet_node
t = ls.text_node
i = ls.insert_node
f = ls.function_node
c = ls.choice_node
d = ls.dynamic_node
r = ls.restore_node
l = require("luasnip.extras").lambda
rep = require("luasnip.extras").rep
p = require("luasnip.extras").partial
m = require("luasnip.extras").match
n = require("luasnip.extras").nonempty
dl = require("luasnip.extras").dynamic_lambda
fmt = require("luasnip.extras.fmt").fmt
fmta = require("luasnip.extras.fmt").fmta
types = require("luasnip.util.types")
conds = require("luasnip.extras.conditions")
conds_expand = require("luasnip.extras.conditions.expand")

function M.get_ISO_8601_date()
	return os.date("%Y-%m-%d")
end

function M.get_visual(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else
		return sn(nil, i(1, ""))
	end
end

return M

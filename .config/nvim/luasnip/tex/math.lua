local helpers = require("helpers.funcs")
local get_visual = helpers.get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
-- Return snippet tables
return {
  -- SUPERSCRIPT
  s(
    { trig = "([%w%)%]%}])'", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT
  s(
    { trig = "([%w%)%]%}]);", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s(
    { trig = "([%w%)%]%}])__", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^{<>}_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- TEXT SUBSCRIPT
  s(
    { trig = "sd", snippetType = "autosnippet", wordTrig = false },
    fmta("_{\\mathrm{<>}}", { d(1, get_visual) }),
    { condition = tex.in_mathzone }
  ),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  s(
    { trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  s(
    { trig = "([%w%)%]%}]):([%w])", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- EULER'S NUMBER SUPERSCRIPT SHORTCUT
  s(
    { trig = "([^%a])ee", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>e^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ZERO SUBSCRIPT SHORTCUT
  s(
    { trig = "([%a%)%]%}])00", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("0"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- MINUS ONE SUPERSCRIPT SHORTCUT
  s(
    { trig = "([%a%)%]%}])11", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("-1"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- J SUBSCRIPT SHORTCUT (since jk triggers snippet jump forward)
  s(
    { trig = "([%a%)%]%}])JJ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("j"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s(
    { trig = "([%a%)%]%}])%+%+", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("+"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- COMPLEMENT SUPERSCRIPT
  s(
    { trig = "([%a%)%]%}])CC", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("\\complement"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
  s(
    { trig = "([%a%)%]%}])%*%*", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("*"),
    }),
    { condition = tex.in_mathzone }
  ),
  -- VECTORBOLD, i.e. \vb
  s(
    { trig = "([^%a])vb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\vb*{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- VECTOR ARROW, i.e. \vb
  s(
    { trig = "([^%a])va", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\va*{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- UNIT VECTOR WITH HAT, i.e. \vu*
  s(
    { trig = "([^%a])vu", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\vu*{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SI UNITX
  s(
    { trig = "SI", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\SI{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- MATRIX, i.e. pmatrix
  s(
    { trig = "([^%a])pmatrix", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
        \begin{pmatrix}{<>}
        <>
        \end{pmatrix}
        ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- MATRIX, i.e. bmatrix
  s(
    { trig = "([^%a])bmatrix", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
        \begin{bmatrix}{<>}
        <>
        \end{bmatrix}
        ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- MATRIX, i.e. vmatrix
  s(
    { trig = "([^%a])vmatrix", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
        \begin{vmatrix}{<>}
        <>
        \end{vmatrix}
        ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- MATRIX, i.e. amatrix
  s(
    { trig = "([^%a])amatrix", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
        \begin{amatrix}{<>}
        <>
        \end{amatrix}
        ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- FRACTION
  s(
    { trig = "([^%a])ff", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE
  s(
    { trig = "([^%a])abs", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\abs{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SQUARE ROOT
  s(
    { trig = "([^%\\])sq", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\sqrt{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BINOMIAL SYMBOL
  s(
    { trig = "([^%\\])bnn", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\binom{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- LOGARITHM WITH BASE SUBSCRIPT
  s(
    { trig = "([^%a%\\])ll", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\log_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with denominator only
  s(
    { trig = "([^%a])dv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\dv{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator and denominator
  s(
    { trig = "([^%a])fdv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\dv{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator, denominator, and higher-order argument
  s(
    { trig = "([^%a])powdv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\dv[<>]{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      i(3),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with denominator only
  s(
    { trig = "([^%a])pdv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\pdv{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with numerator and denominator
  s(
    { trig = "([^%a])fpdv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\pdv{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with numerator, denominator, and higher-order argument
  s(
    { trig = "([^%a])powpdv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\pdv[<>]{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      i(3),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with lower limit
  s(
    { trig = "([^%a])suM", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\sum_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with upper and lower limit
  s(
    { trig = "([^%a])summ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\sum_{<>}^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL with upper and lower limit
  s(
    { trig = "([^%a])intt", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\int_{<>}^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL from positive to negative infinity
  s(
    { trig = "([^%a])intf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\int_{\\infty}^{\\infty}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BOXED command
  s(
    { trig = "([^%a])bb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>\\boxed{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  --
  -- BEGIN STATIC SNIPPETS
  --

  -- DIFFERENTIAL, i.e. \diff
  s(
    { trig = "dd", snippetType = "autosnippet", priority = 2000 },
    fmta("\\dd{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BASIC INTEGRAL SYMBOL, i.e. \int
  s({ trig = "in1", snippetType = "autosnippet" }, {
    t("\\int"),
  }, { condition = tex.in_mathzone }),
  -- DOUBLE INTEGRAL, i.e. \iint
  s({ trig = "in2", snippetType = "autosnippet" }, {
    t("\\iint"),
  }, { condition = tex.in_mathzone }),
  -- TRIPLE INTEGRAL, i.e. \iiint
  s({ trig = "in3", snippetType = "autosnippet" }, {
    t("\\iiint"),
  }, { condition = tex.in_mathzone }),
  -- CLOSED SINGLE INTEGRAL, i.e. \oint
  s({ trig = "oi1", snippetType = "autosnippet" }, {
    t("\\oint"),
  }, { condition = tex.in_mathzone }),
  -- CLOSED DOUBLE INTEGRAL, i.e. \oiint
  s({ trig = "oi2", snippetType = "autosnippet" }, {
    t("\\oiint"),
  }, { condition = tex.in_mathzone }),
  -- GRADIENT OPERATOR, i.e. \grad
  s({ trig = "gdd", snippetType = "autosnippet" }, {
    t("\\grad "),
  }, { condition = tex.in_mathzone }),
  -- CURL OPERATOR, i.e. \curl
  s({ trig = "cll", snippetType = "autosnippet" }, {
    t("\\curl "),
  }, { condition = tex.in_mathzone }),
  -- DIVERGENCE OPERATOR, i.e. \divergence
  s({ trig = "DI", snippetType = "autosnippet" }, {
    t("\\div "),
  }, { condition = tex.in_mathzone }),
  -- LAPLACIAN OPERATOR, i.e. \laplacian
  s({ trig = "laa", snippetType = "autosnippet" }, {
    t("\\laplacian "),
  }, { condition = tex.in_mathzone }),
  -- PARALLEL SYMBOL, i.e. \parallel
  s({ trig = "||", snippetType = "autosnippet" }, {
    t("\\parallel"),
  }, { condition = tex.in_mathzone }),
  -- CDOTS, i.e. \cdots
  s({ trig = "cdd", snippetType = "autosnippet" }, {
    t("\\cdots"),
  }, { condition = tex.in_mathzone }),
  -- LDOTS, i.e. \ldots
  s({ trig = "ldd", snippetType = "autosnippet" }, {
    t("\\ldots"),
  }, { condition = tex.in_mathzone }),
  -- EQUIV, i.e. \equiv
  s({ trig = "eqq", snippetType = "autosnippet" }, {
    t("\\equiv "),
  }, { condition = tex.in_mathzone }),
  -- SETMINUS, i.e. \setminus
  s({ trig = "stm", snippetType = "autosnippet" }, {
    t("\\setminus "),
  }, { condition = tex.in_mathzone }),
  -- SUBSET, i.e. \subset
  s({ trig = "sbb", snippetType = "autosnippet" }, {
    t("\\subset "),
  }, { condition = tex.in_mathzone }),
  -- APPROX, i.e. \approx
  s({ trig = "px", snippetType = "autosnippet" }, {
    t("\\approx "),
  }, { condition = tex.in_mathzone }),
  -- PROPTO, i.e. \propto
  s({ trig = "pt", snippetType = "autosnippet" }, {
    t("\\propto "),
  }, { condition = tex.in_mathzone }),
  -- COLON, i.e. \colon
  s({ trig = "::", snippetType = "autosnippet" }, {
    t("\\colon "),
  }, { condition = tex.in_mathzone }),
  -- IMPLIES, i.e. \implies
  s({ trig = ">>", snippetType = "autosnippet" }, {
    t("\\implies "),
  }, { condition = tex.in_mathzone }),
  -- DOT PRODUCT, i.e. \cdot
  s({ trig = ",.", snippetType = "autosnippet" }, {
    t("\\cdot "),
  }, { condition = tex.in_mathzone }),
  -- CROSS PRODUCT, i.e. \times
  s({ trig = "xx", snippetType = "autosnippet" }, {
    t("\\times "),
  }, { condition = tex.in_mathzone }),
  -- INFINITY i.e. \infty
  s({ trig = "inff", snippetType = "autosnippet" }, {
    t("\\infty"),
  }, { condition = tex.in_mathzone }),
}

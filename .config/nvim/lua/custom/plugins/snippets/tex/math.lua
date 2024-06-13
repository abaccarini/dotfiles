local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
-- local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep
-- local line_begin = require('luasnip.extras.expand_conditions').line_begin
local autosnippet = ls.extend_decorator.apply(s, { snippetType = 'autosnippet' })
local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

return {
  autosnippet({ trig = 'sr', wordTrig = false }, { t '^2' }, {
    condition = tex.in_mathzone,
  }),
  autosnippet({ trig = 'cb', wordTrig = false }, { t '^3' }, {
    condition = tex.in_mathzone,
  }),
  autosnippet({ trig = 'compl', wordTrig = false }, { t '^{c}' }, {
    condition = tex.in_mathzone,
  }),
  autosnippet({ trig = 'vtr', wordTrig = false }, { t '^{T}' }, {
    condition = tex.in_mathzone,
  }),
  autosnippet({ trig = 'inv', wordTrig = false }, { t '^{-1}' }, {
    condition = tex.in_mathzone,
  }),
  s(
    { trig = 'lbb', snippetType = 'autosnippet' },
    fmta('\\lb{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'lng', snippetType = 'autosnippet' },
    fmta('\\lng{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'lbr', snippetType = 'autosnippet' },
    fmta('\\lbr{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'lp', snippetType = 'autosnippet' },
    fmta('\\lp{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'ff', snippetType = 'autosnippet' },
    fmta('\\frac{<>}{<>}', {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  -- s(
  --   { trig = '^^', snippetType = 'autosnippet' },
  --   fmta('^{<>}', {
  --     i(1),
  --   }),
  --   { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  -- ),
  s(
    { trig = '([^%a])^^', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),

  s(
    { trig = '([^%a])__', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = '([^%a])pd', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\prod{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = '([^%a])sM', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with upper and lower limit
  s(
    { trig = '([^%a])smm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, 'i = 0'),
      i(2, '\\infty'),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL with upper and lower limit
  s(
    { trig = '([^%a])intt', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{<>}^{<>}', {
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
    { trig = '([^%a])intf', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{\\infty}^{\\infty}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE
  s(
    { trig = '([^%a])aa', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\abs{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- norm
  s(
    { trig = '([^%a])nor', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\norm{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SQUARE ROOT
  s(
    { trig = '([^%\\])sq', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sqrt{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = 'ht', snippetType = 'autosnippet' },
    fmta('\\hat{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'br', snippetType = 'autosnippet' },
    fmta('\\bar{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'vv', snippetType = 'autosnippet' },
    fmta('\\vec{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'tt', snippetType = 'autosnippet' },
    fmta('\\text{<>}', {
      i(1),
    }),
    { condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
  ),
  s(
    { trig = 'mt', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>matrix}
          <> & \\
        \end{<>matrix}
      ]],
      {
        i(1, 'b|B|p|v|V'),
        i(2),
        rep(1), -- this node repeats insert node i(1)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'dd', snippetType = 'autosnippet' }, {
    t '\\dots',
  }, { condition = tex.in_mathzone }),
  s({ trig = 'cdd', snippetType = 'autosnippet' }, {
    t '\\cdots',
  }, { condition = tex.in_mathzone }),
  -- LDOTS, i.e. \ldots
  s({ trig = 'ldd', snippetType = 'autosnippet' }, {
    t '\\ldots',
  }, { condition = tex.in_mathzone }),
  -- EQUIV, i.e. \equiv
  s({ trig = 'eqq', snippetType = 'autosnippet' }, {
    t '\\equiv ',
  }, { condition = tex.in_mathzone }),
  -- SETMINUS, i.e. \setminus
  s({ trig = 'stm', snippetType = 'autosnippet' }, {
    t '\\setminus ',
  }, { condition = tex.in_mathzone }),
  -- SUBSET, i.e. \subset
  s({ trig = 'sbb', snippetType = 'autosnippet' }, {
    t '\\subset ',
  }, { condition = tex.in_mathzone }),
  -- APPROX, i.e. \approx
  s({ trig = 'px', snippetType = 'autosnippet' }, {
    t '\\approx ',
  }, { condition = tex.in_mathzone }),
  -- PROPTO, i.e. \propto
  s({ trig = 'pt', snippetType = 'autosnippet' }, {
    t '\\propto ',
  }, { condition = tex.in_mathzone }),
  -- COLON, i.e. \colon
  s({ trig = '::', snippetType = 'autosnippet' }, {
    t '\\colon ',
  }, { condition = tex.in_mathzone }),
  -- IMPLIES, i.e. \implies
  s({ trig = '>>', snippetType = 'autosnippet' }, {
    t '\\implies ',
  }, { condition = tex.in_mathzone }),
  -- DOT PRODUCT, i.e. \cdot
  s({ trig = ';.', snippetType = 'autosnippet' }, {
    t '\\cdot ',
  }, { condition = tex.in_mathzone }),
  -- CROSS PRODUCT, i.e. \times
  s({ trig = 'xx', snippetType = 'autosnippet' }, {
    t '\\times ',
  }, { condition = tex.in_mathzone }),
  -- infinity
  s({ trig = 'inf', snippetType = 'autosnippet' }, {
    t '\\infty ',
  }, { condition = tex.in_mathzone }),
}

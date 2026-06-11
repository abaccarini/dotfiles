local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep
local autosnippet = ls.extend_decorator.apply(s, { snippetType = 'autosnippet' })

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

local typst = {}
typst.in_mathzone = function()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, 'typst')
  if not ok or not parser then
    return false
  end
  parser:parse(true)
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == 'math' then
      return true
    end
    node = node:parent()
  end
  return false
end
typst.in_text = function()
  return not typst.in_mathzone()
end

return {

  s(
    { trig = 'sf', snippetType = 'autosnippet' },
    fmta('sans("<>")', {
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'fk', snippetType = 'autosnippet' },
    fmta('frak("<>")', {
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])bm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>bold(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])lng', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>lng(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])lbb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>lb(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])lbr', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>lbr(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])lp', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>lp(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),

  autosnippet({ trig = 'sr', wordTrig = false }, { t '^2' }, {
    condition = typst.in_mathzone,
  }),
  autosnippet({ trig = 'cb', wordTrig = false }, { t '^3' }, {
    condition = typst.in_mathzone,
  }),
  autosnippet({ trig = 'compl', wordTrig = false }, { t '^c' }, {
    condition = typst.in_mathzone,
  }),
  autosnippet({ trig = 'vtr', wordTrig = false }, { t '^T' }, {
    condition = typst.in_mathzone,
  }),
  autosnippet({ trig = 'inv', wordTrig = false }, { t '^(-1)' }, {
    condition = typst.in_mathzone,
  }),
  s(
    { trig = 'ff', snippetType = 'autosnippet' },
    fmta('frac(<>, <>)', {
      i(1),
      i(2),
    }),
    { condition = typst.in_mathzone }
  ),

  s(
    { trig = '^^', wordTrig = false, snippetType = 'autosnippet' },
    fmta('^(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '__', wordTrig = false, snippetType = 'autosnippet' },
    fmta('_(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])pd', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>product_(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])sM', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>sum_(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s({ trig = 'dc', snippetType = 'autosnippet' }, {
    t 'dec ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'ec', snippetType = 'autosnippet' }, {
    t 'enc ',
  }, { condition = typst.in_mathzone }),
  s(
    { trig = '([^%a])dC', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>decc(<>, <>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, 'k'),
      i(2, 'c'),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])eC', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>encc(<>, <>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, 'k'),
      i(2, 'm'),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])smm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>sum_(<>)^(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, 'i = 0'),
      i(2, 'oo'),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])intt', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>integral_(<>)^(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])intf', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>integral_(-oo)^(oo)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])aa', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>abs(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])Nor', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>norm(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])nor', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>norm(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])sq', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>sqrt(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'bin', snippetType = 'autosnippet' },
    fmta('binom(<>, <>)', {
      i(1),
      i(2),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'ht', snippetType = 'autosnippet' },
    fmta('hat(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'td', snippetType = 'autosnippet' },
    fmta('tilde(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'br', snippetType = 'autosnippet' },
    fmta('overline(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'vv', snippetType = 'autosnippet' },
    fmta('arrow(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'bb', snippetType = 'autosnippet' },
    fmta('bb(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s({ trig = 'prt', snippetType = 'autosnippet' }, {
    t 'prop ',
  }, { condition = typst.in_mathzone }),

  s(
    { trig = 'prb', wordTrig = false, snippetType = 'autosnippet' },
    fmta('pr(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'cl', snippetType = 'autosnippet' },
    fmta('cal(<>)', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'tt', snippetType = 'autosnippet' },
    fmta('"<>"', {
      i(1),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = 'mt', snippetType = 'autosnippet' },
    fmta('mat(delim: "<>", <>)', {
      i(1, '('),
      i(2),
    }),
    { condition = typst.in_mathzone }
  ),
  s({ trig = 'dd', snippetType = 'autosnippet' }, {
    t 'dots.h',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'cdd', snippetType = 'autosnippet' }, {
    t 'dots.h.c',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'ldd', snippetType = 'autosnippet' }, {
    t 'dots.h',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'eqq', snippetType = 'autosnippet' }, {
    t 'equiv ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'stm', snippetType = 'autosnippet' }, {
    t 'minus.set ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'sbb', snippetType = 'autosnippet' }, {
    t 'subset ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'px', snippetType = 'autosnippet' }, {
    t 'approx ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'pt', snippetType = 'autosnippet' }, {
    t 'prop ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'md', snippetType = 'autosnippet' }, {
    t 'divides ',
  }, { condition = typst.in_mathzone }),
  s({ trig = '::', snippetType = 'autosnippet' }, {
    t ': ',
  }, { condition = typst.in_mathzone }),
  s({ trig = '>>', snippetType = 'autosnippet' }, {
    t '=> ',
  }, { condition = typst.in_mathzone }),
  s({ trig = ';.', snippetType = 'autosnippet', wordTrig = false }, {
    t 'dot.op ',
  }, { condition = typst.in_mathzone }),
  s(
    { trig = '([^%a])to', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>->> ', {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = typst.in_mathzone }
  ),
  s({ trig = 'gr', snippetType = 'autosnippet' }, {
    t 'gr ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'gets', snippetType = 'autosnippet', wordTrig = false }, {
    t '<- ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'inn', snippetType = 'autosnippet', wordTrig = false }, {
    t 'in ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'leq', snippetType = 'autosnippet', wordTrig = false }, {
    t '<= ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'geq', snippetType = 'autosnippet', wordTrig = false }, {
    t '>= ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'xx', snippetType = 'autosnippet' }, {
    t 'times ',
  }, { condition = typst.in_mathzone }),
  s({ trig = 'inff', snippetType = 'autosnippet' }, {
    t 'infinity ',
  }, { condition = typst.in_mathzone }),
  s(
    { trig = 'cas', snippetType = 'autosnippet' },
    fmta(
      [[
        cases(
          <> & "if" <>,
        )
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = typst.in_mathzone }
  ),
}

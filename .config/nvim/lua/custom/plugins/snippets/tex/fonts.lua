local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local line_begin = require('luasnip.extras.expand_conditions').line_begin
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
  s(
    { trig = '([^%a])tt', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 2000 },
    fmta('<>\\texttt{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_text }
  ),
  -- ITALIC i.e. \textit
  s(
    { trig = 'tt', snippetType = 'autosnippet' },
    fmta('\\texttt{<>}', {
      i(1),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = 'sf', snippetType = 'autosnippet' },
    fmta('\\textsf{<>}', {
      i(1),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = 'bf', snippetType = 'autosnippet' },
    fmta('\\textbf{<>}', {
      i(1),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = 'tii', snippetType = 'autosnippet' },
    fmta('\\textit{<>}', {
      i(1),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = 'em', snippetType = 'autosnippet' },
    fmta('\\emph{<>}', {
      i(1),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = '([^%a])em', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\emph{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_text }
  ),
  s(
    { trig = '([^%a])tii', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\textit{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'bf', snippetType = 'autosnippet' },
    fmta('\\textbf{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = '([^%a])sf', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\textsf{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH ROMAN i.e. \mathrm
  s(
    { trig = '([^%a])rmm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathrm{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH CALIGRAPHY i.e. \mathcal
  s(
    { trig = '([^%a])mcc', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathcal{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH BOLDFACE i.e. \mathbf
  s(
    { trig = '([^%a])mbf', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathbf{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH BLACKBOARD i.e. \mathbb
  s(
    { trig = '([^%a])mbb', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathbb{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- REGULAR TEXT i.e. \text (in math environments)
  s(
    { trig = '([^%a])tee', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\text{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
}

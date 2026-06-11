local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

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
    { trig = '([^%a])tt', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 2000 },
    fmta('<>`<>`', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_text }
  ),
  s(
    { trig = ';sc', snippetType = 'autosnippet' },
    fmta('#smallcaps[<>]', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';ul', snippetType = 'autosnippet' },
    fmta('#underline[<>]', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'bf', snippetType = 'autosnippet' },
    fmta('*<>*', {
      d(1, get_visual),
    }),
    { condition = typst.in_text }
  ),
  s(
    { trig = 'tii', snippetType = 'autosnippet' },
    fmta('_<>_', {
      d(1, get_visual),
    }),
    { condition = typst.in_text }
  ),

  s(
    { trig = ';sf', snippetType = 'autosnippet' },
    fmta('#text(font: "sans")[<>]', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';em', snippetType = 'autosnippet' },
    fmta('#emph[<>]', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = '([^%a])rmm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>upright(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])mcc', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>cal(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])mbf', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>bold(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])mbb', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>bb(<>)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
  s(
    { trig = '([^%a])tee', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>"<>"', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = typst.in_mathzone }
  ),
}

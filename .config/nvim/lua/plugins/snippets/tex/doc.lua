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
local function to_label(str)
  return str:lower():gsub('[^%a%d]+', '_'):gsub('^_', ''):gsub('_$', '')
end

return {

  s(
    { trig = ';tr', snippetType = 'autosnippet', wordTrig = false },
    fmta('% !TeX root = ./tex<>', {
      d(1, get_visual),
    })
  ),
  s('cha', {
    t '\\chapter{',
    i(1, ''),
    t { '}', '\\label{cha:' },
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '}', '' },
    i(0),
  }),

  s('sec', {
    t '\\section{',
    i(1, ''),
    t { '}', '\\label{sec:' },
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '}', '' },
    i(0),
  }),

  s('sub', {
    t '\\subsection{',
    i(1, ''),
    t { '}', '\\label{sub:' },
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '}', '' },
    i(0),
  }),

  s('ssub', {
    t '\\subsubsection{',
    i(1, ''),
    t { '}', '\\label{ssub:' },
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '}', '' },
    i(0),
  }),
  s('par', {
    t '\\paragraph{',
    i(1, ''),
    t { '}', '\\label{par:' },
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '}', '' },
    i(0),
  }),

  s(
    { trig = ';ll', snippetType = 'autosnippet', wordTrig = false },
    fmta('\\label{line:<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';ct', snippetType = 'autosnippet', wordTrig = false },
    fmta('~\\cite{<>}', {
      d(1, get_visual),
    })
  ),

  s(
    { trig = ';erf', snippetType = 'autosnippet', wordTrig = false },
    fmta('~\\eqref{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';rf', snippetType = 'autosnippet', wordTrig = false },
    fmta('~\\ref{<>}', {
      d(1, get_visual),
    })
  ),
  -- s({ trig = 'sec', dscr = 'section' },
  --   fmta(
  --     [[
  --     \begin{<>}
  --         <>
  --     \end{<>}
  --   ]],
  --     {
  --       i(1),
  --       i(2),
  --       rep(1), -- this node repeats insert node i(1)
  --     }
  --   )
  -- ),
}

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

return {

  s(
    { trig = ';\\', wordTrig = false,snippetType = 'autosnippet' },
    fmta('\\<>{<>}', {

        i(1),
      -- d(1, get_visual),
      d(2, get_visual),
        -- i(1),
        -- i(2),
    })
  ),
  s(
    { trig = ';cl', wordTrig = false,snippetType = 'autosnippet' },
    fmta('{\\color{<>}<>}', {
      d(1, get_visual),
      d(2, get_visual),
        -- i(1),
        -- i(2),
    })
  ),
  s(
    { trig = ';ft', wordTrig = false,snippetType = 'autosnippet' },
    fmta('\\footnote{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = '([^%a])ii', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\item <>', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
-- s({ trig = 'ii', snippetType = 'autosnippet',  wordTrig = false  }, {
  --   t '\\item ',
  -- }, {  }),
  s(
    { trig = ';exa', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{experiment}[]{}{}
          <>
      \end{experiment}
    ]],
      {
        i(1),
      }
    )
  ),
  s(
    { trig = ';exp', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{experiment}[label={exp:<>}]{<>}{}
          <>
      \end{experiment}
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';thm', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{theorem}[label={thm:<>}]{<>}{}
          <>
      \end{theorem}
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';def', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{definition}[label={def:<>}]{<>}{}
          <>
      \end{definition}
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';tcb', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{<>}[]{<>}{}
          <>
      \end{<>}
    ]],
      {
        i(1),
        i(2),
        i(3),
        rep(1), -- this node repeats insert node i(1)
      }
    )
  ),
  s(
    { trig = ';env', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
    ]],
      {
        i(1),
        i(2),
        rep(1), -- this node repeats insert node i(1)
      }
    )
  ),
  s(
    { trig = '([^%a])mm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>$<> $', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'mm', snippetType = 'autosnippet' },
fmta(
    [[$<>$]],
    { i(1) }
  ), 
    { condition = line_begin }
  ),
  -- s(
  --   { trig = 'mm', snippetType = 'autosnippet' },
  --   fmta('$<> $', {
  --     i(0),
  --   }),
  --   { condition = line_begin }
  -- ),
  s(
    { trig = 'bal', dscr = 'Align*' },
    fmt( -- The snippet code actually looks like the equation environment it produces.
      [[
      \begin{align*}
          <>
      \end{align*}
      ]],
      { i(1) },
      { delimiters = '<>' }
    )
  ),
  -- ITEMIZE
  s(
    { trig = 'itt', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{itemize}
          \item <>
      \end{itemize}
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
    -- { condition = line_begin }
  ),
  s(
    { trig = 'enn', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{enumerate}
          \item <>
      \end{enumerate}
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = 'pf', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{proof}
          <>
      \end{proof}
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
}

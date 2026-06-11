local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
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
  else
    return sn(nil, i(1))
  end
end

return {

  s(
    { trig = ';\\', wordTrig = false, snippetType = 'autosnippet' },
    fmta('#<>[<>]', {
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = ';cl', wordTrig = false, snippetType = 'autosnippet' },
    fmta('#text(fill: <>)[<>]', {
      d(1, get_visual),
      d(2, get_visual),
    })
  ),
  s(
    { trig = ';ft', wordTrig = false, snippetType = 'autosnippet' },
    fmta('#footnote[<>]', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = '([^%a])ii', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>- <>', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';eexa', snippetType = 'autosnippet' },
    fmta(
      [[
      #experiment[
          <>
      ]
    ]],
      {
        i(1),
      }
    )
  ),
  s(
    { trig = ';eexp', snippetType = 'autosnippet' },
    fmta(
      [[
      #experiment(title: "<>")[
          <>
      ] <<exp:<>>>
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
      #theorem(title: "<>")[
          <>
      ] <<thm:<>>>
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
      #definition(title: "<>")[
          <>
      ] <<def:<>>>
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';cor', snippetType = 'autosnippet' },
    fmta(
      [[
      #corollary(title: "<>")[
          <>
      ] <<cor:<>>>
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),

  s(
    { trig = ';tthm', snippetType = 'autosnippet' },
    fmta(
      [[
      #theorem(title: "<>")[
          <>
      ] <<thm:<>>>
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';ddef', snippetType = 'autosnippet' },
    fmta(
      [[
      #definition(title: "<>")[
          <>
      ] <<def:<>>>
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
      #<>(title: "<>")[
          <>
      ]
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = ';env', snippetType = 'autosnippet' },
    fmta(
      [[
      #<>[
          <>
      ]
    ]],
      {
        i(1),
        i(2),
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
    fmta([[$<>$]], { i(1) }),
    { condition = line_begin }
  ),
  s(
    { trig = 'bal', dscr = 'block math (align)' },
    fmt(
      [[
      $
          <>
      $
      ]],
      { i(1) },
      { delimiters = '<>' }
    )
  ),
  s(
    { trig = 'itt', snippetType = 'autosnippet' },
    fmta(
      [[
      - <>
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = 'enn', snippetType = 'autosnippet' },
    fmta(
      [[
      + <>
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = ';pf', snippetType = 'autosnippet' },
    fmta(
      [[
      #proof[
          <>
      ]
      <>
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
}

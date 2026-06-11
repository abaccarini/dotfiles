local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

local function to_label(str)
  return str:lower():gsub('[^%a%d]+', '_'):gsub('^_', ''):gsub('_$', '')
end

local heading = function(prefix, label_kind)
  return {
    t(prefix .. ' '),
    i(1, ''),
    t(' <' .. label_kind .. ':'),
    d(2, function(args)
      return sn(nil, { i(1, '' .. to_label(args[1][1])) })
    end, { 1 }),
    t { '>', '' },
    i(0),
  }
end

return {

  s('cha', heading('=', 'cha')),
  s('sec', heading('==', 'sec')),
  s('sub', heading('===', 'sub')),
  s('ssub', heading('====', 'ssub')),
  s('par', heading('=====', 'par')),

  s({ trig = ';ll', snippetType = 'autosnippet', wordTrig = false }, {
    t '<line:',
    d(1, get_visual),
    t '>',
  }),
  s(
    { trig = ';ct', snippetType = 'autosnippet', wordTrig = false },
    fmta('@<>', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';erf', snippetType = 'autosnippet', wordTrig = false },
    fmta('@<>', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = ';rf', snippetType = 'autosnippet', wordTrig = false },
    fmta('@<>', {
      d(1, get_visual),
    })
  ),
}

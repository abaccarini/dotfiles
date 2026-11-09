-- Suggested-edit markup (\chg, \chgdel, \chgrep, \abon, \abdel; see the paper's preamble/macros.tex).
-- Select text, press <Tab> (store_selection_keys), then type the trigger to wrap the selection.
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
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- The selection as it is, with no stop to jump to, since \chgrep, \abon and \abdel leave the
-- selected text alone.  With no selection, there is a stop to type the text at, after the new text or note.
local get_fixed = function(_, parent)
  local selection = parent.snippet.env.LS_SELECT_RAW
  return sn(nil, #selection > 0 and t(selection) or i(1))
end

-- In text, and not the tail of a command being typed out by hand (`\chg`).
local in_text = function(line_to_cursor, trigger)
  return vim.fn['vimtex#syntax#in_mathzone']() == 0 and line_to_cursor:sub(-#trigger - 1, -#trigger - 1) ~= '\\'
end

local auto = function(trig)
  return { trig = trig, snippetType = 'autosnippet', priority = 2000 }
end

return {
  -- inserted text
  s(auto 'chg', fmta('\\chg{<>}', { d(1, get_visual) }), { condition = in_text }),
  -- deleted text
  s(auto 'cdl', fmta('\\chgdel{<>}', { d(1, get_visual) }), { condition = in_text }),
  -- replaced text: the selection becomes the old text, and the cursor starts in the new
  s(auto 'crp', fmta('\\chgrep{<>}{<>}', { d(2, get_fixed), i(1) }), { condition = in_text }),
  -- a note on text: the selection is highlighted, and the cursor starts in the note
  s(auto 'cmo', fmta('\\abon{<>}{<>}', { d(2, get_fixed), i(1) }), { condition = in_text }),
  -- a note on text to delete: the selection is struck through, and the cursor starts in the note
  s(auto 'cmd', fmta('\\abdel{<>}{<>}', { d(2, get_fixed), i(1) }), { condition = in_text }),
}

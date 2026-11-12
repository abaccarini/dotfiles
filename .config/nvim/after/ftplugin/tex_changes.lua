-- Review suggested edits (\chg, \chgdel, \chgrep, and \abdel, a deletion with a note) and notes
-- (\ab, \claude, \abon, \claudeon, the second review round's \claudeii and \claudeiion, the
-- third's \claudeiii and \claudeiiion, the fourth's \claudeiv and \claudeivon, and the fifth's
-- \claudev and \claudevon); the macros are in the paper's preamble/macros.tex.
--   <leader>ea, <leader>er   accept / reject the edit under the cursor (a note is removed either
--                            way, leaving the text an \abon, \claudeon, \claudeiion, \claudeiiion,
--                            \claudeivon or \claudevon is on); in
--                            visual mode, every edit in the selection
--   <leader>eA               accept every edit in the file, keeping the notes
--   ]e, [e                   next / previous edit or note
-- `:[range]ChgAccept[!]` and `:[range]ChgReject[!]` do the same; with a range, `!` also removes
-- the notes in it.  The whole command is one undo step.  Nothing is reflowed: <leader>F (from
-- tex.lua) does that, and `gv<leader>F` after a visual accept or reject.

local bufnr = vim.api.nvim_get_current_buf()

-- The argument each macro leaves on accept and on reject (false: nothing).
local macros = {
  chg = { nargs = 1, accept = 1, reject = false },
  chgdel = { nargs = 1, accept = false, reject = 1 },
  chgrep = { nargs = 2, accept = 2, reject = 1 },
  ab = { nargs = 1, accept = false, reject = false, note = true },
  claude = { nargs = 1, accept = false, reject = false, note = true },
  abon = { nargs = 2, accept = 1, reject = 1, note = true },
  claudeon = { nargs = 2, accept = 1, reject = 1, note = true },
  claudeii = { nargs = 1, accept = false, reject = false, note = true },
  claudeiion = { nargs = 2, accept = 1, reject = 1, note = true },
  claudeiii = { nargs = 1, accept = false, reject = false, note = true },
  claudeiiion = { nargs = 2, accept = 1, reject = 1, note = true },
  claudeiv = { nargs = 1, accept = false, reject = false, note = true },
  claudeivon = { nargs = 2, accept = 1, reject = 1, note = true },
  claudev = { nargs = 1, accept = false, reject = false, note = true },
  claudevon = { nargs = 2, accept = 1, reject = 1, note = true },
  abdel = { nargs = 2, accept = false, reject = 1 },
}
local search_pattern =
  [[\\\%(chg\|chgdel\|chgrep\|ab\|claude\|abon\|claudeon\|claudeii\|claudeiion\|claudeiii\|claudeiiion\|claudeiv\|claudeivon\|claudev\|claudevon\|abdel\){]]

local function buf_lines()
  return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

-- Byte index of the first unescaped % in `line`, or past its end.
local function comment_start(line)
  local from = 1
  while true do
    local p = line:find('%', from, true)
    if not p or line:sub(p - 1, p - 1) ~= '\\' then
      return p or #line + 1
    end
    from = p + 1
  end
end

-- (row, col), 0-based, of the brace closing the one at (row, col), skipping escaped braces and
-- comments.  VimTeX's parser is not used: it also takes a following `(...)` or `[...]` as
-- arguments, which would then be deleted with the edit.
local function closing_brace(lines, row, col)
  local depth = 0
  for r = row, math.min(#lines - 1, row + 200) do
    local line, c = lines[r + 1], r == row and col or 0
    while c < #line do
      local ch = line:sub(c + 1, c + 1)
      if ch == '\\' then
        c = c + 1
      elseif ch == '%' then
        break
      elseif ch == '{' then
        depth = depth + 1
      elseif ch == '}' then
        depth = depth - 1
        if depth == 0 then
          return r, c
        end
      end
      c = c + 1
    end
  end
end

-- The macro whose backslash is at (row, col): its spec, the braces of each argument as
-- {open row, open col, close row, close col}, and the (exclusive) end of the whole macro.
local function parse_at(lines, row, col)
  local name = lines[row + 1]:match('^\\(%a+){', col + 1)
  local spec = macros[name]
  if not spec then
    return
  end
  local item = { spec = spec, row = row, col = col, args = {} }
  local r, c = row, col + 1 + #name
  for k = 1, spec.nargs do
    if lines[r + 1]:sub(c + 1, c + 1) ~= '{' then
      return
    end
    local close_r, close_c = closing_brace(lines, r, c)
    if not close_r then
      return
    end
    item.args[k] = { r, c, close_r, close_c }
    r, c = close_r, close_c + 1
  end
  item.end_row, item.end_col = r, c
  return item
end

-- Every macro starting on rows first..last, in document order.
local function scan(lines, first, last)
  local found = {}
  for r = first, last do
    local line = lines[r + 1]
    local stop, from = comment_start(line), 1
    while true do
      local s, _, name = line:find('\\(%a+){', from)
      if not s or s > stop then
        break
      end
      if macros[name] and line:sub(s - 1, s - 1) ~= '\\' then
        found[#found + 1] = parse_at(lines, r, s - 1)
      end
      from = s + 1
    end
  end
  return found
end

-- The innermost macro around the cursor.
local function item_at_cursor(lines)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2]
  local best
  for _, item in ipairs(scan(lines, math.max(0, row - 200), row)) do
    local starts_before = item.row < row or (item.row == row and item.col <= col)
    local ends_after = item.end_row > row or (item.end_row == row and item.end_col > col)
    if starts_before and ends_after then
      best = item
    end
  end
  return best
end

-- Line `row`, which reads `old`, changed to `new` by replacing only the part that differs, so the
-- marks run() keeps on the line stay on it (replacing the whole line would move them off it).
local function set_line(row, old, new)
  local p = 0
  while p < #old and p < #new and old:byte(p + 1) == new:byte(p + 1) do
    p = p + 1
  end
  local q = 0
  while q < #old - p and q < #new - p and old:byte(#old - q) == new:byte(#new - q) do
    q = q + 1
  end
  vim.api.nvim_buf_set_text(bufnr, row, p, row, #old - q, { new:sub(p + 1, #new - q) })
end

-- After text was removed at (row, col): no doubled space, no space before punctuation or a tie,
-- and no blank line left by a note that stood on its own.
local function tidy(row, col)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  local before, after = line:sub(1, col), line:sub(col + 1)
  if not line:match '%S' then
    vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, {})
    local around = vim.api.nvim_buf_get_lines(bufnr, math.max(row - 1, 0), row + 1, false)
    if row > 0 and #around == 2 and not around[1]:match '%S' and not around[2]:match '%S' then
      vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, {})
    end
    return
  end
  if after == '' or after:match '^[%.,;:!?%)%]}~]' then
    before = before:gsub('%s+$', '')
  elseif not before:match '%S' then
    after = after:gsub('^%s+', '')
  else
    local gap_before, gap_after = before:match '%s*$', after:match '^%s*'
    before = before:gsub('%s+$', '') .. (#gap_after > #gap_before and gap_after or gap_before)
    after = after:gsub('^%s+', '')
  end
  set_line(row, line, before .. after)
end

local function resolve(item, how)
  local keep = item.spec[how]
  local text = { '' }
  if keep then
    local a = item.args[keep]
    text = vim.api.nvim_buf_get_text(bufnr, a[1], a[2] + 1, a[3], a[4], {})
  end
  vim.api.nvim_buf_set_text(bufnr, item.row, item.col, item.end_row, item.end_col, text)
  if not keep then
    tidy(item.row, item.col)
  end
end

local ns = vim.api.nvim_create_namespace 'tex_changes'

local function run(how, opts)
  local lines = buf_lines()
  local targets
  if opts.range == 0 then
    targets = { item_at_cursor(lines) }
    if not targets[1] then
      vim.notify('No suggested edit or note under the cursor', vim.log.levels.WARN)
      return
    end
  else
    targets = vim.tbl_filter(function(item)
      return opts.bang or not item.spec.note
    end, scan(lines, opts.line1 - 1, opts.line2 - 1))
  end

  -- Bottom up, so positions above stay valid; each is parsed again, since resolving one nested
  -- inside it has moved its closing brace.
  local marks = {}
  for k = #targets, 1, -1 do
    local item = parse_at(buf_lines(), targets[k].row, targets[k].col)
    if item then
      resolve(item, how)
      local row = math.min(item.row, vim.api.nvim_buf_line_count(bufnr) - 1)
      local col = math.min(item.col, #vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1])
      table.insert(marks, 1, vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {}))
    end
  end

  -- A mark on a blank line that tidy() deleted at the end of the buffer is past its last line.
  local function goto_mark(id)
    local pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, id, {})
    local row = math.min(pos[1], vim.api.nvim_buf_line_count(bufnr) - 1)
    vim.api.nvim_win_set_cursor(0, { row + 1, pos[2] })
  end
  if marks[1] then
    goto_mark(marks[1])
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  if opts.range > 0 then
    vim.notify(string.format('%s %d', how == 'accept' and 'Accepted' or 'Rejected', #marks))
  end
end

for how, cmd in pairs { accept = 'ChgAccept', reject = 'ChgReject' } do
  vim.api.nvim_buf_create_user_command(bufnr, cmd, function(opts)
    run(how, opts)
  end, { range = true, bang = true, desc = how:gsub('^%l', string.upper) .. ' suggested edits' })
end

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end
local function jump(flags)
  return function()
    for _ = 1, vim.v.count1 do
      vim.fn.search(search_pattern, flags)
    end
  end
end
map('n', '<leader>ea', '<cmd>ChgAccept<cr>', 'Accept edit under cursor')
map('n', '<leader>er', '<cmd>ChgReject<cr>', 'Reject edit under cursor')
map('x', '<leader>ea', ':ChgAccept<cr>', 'Accept edits in selection')
map('x', '<leader>er', ':ChgReject<cr>', 'Reject edits in selection')
map('n', '<leader>eA', '<cmd>%ChgAccept<cr>', 'Accept all edits in file')
map('n', ']e', jump 'W', 'Next suggested edit or note')
map('n', '[e', jump 'bW', 'Previous suggested edit or note')
pcall(function()
  require('which-key').add { { '<leader>e', group = 'Suggested edits', buffer = bufnr } }
end)

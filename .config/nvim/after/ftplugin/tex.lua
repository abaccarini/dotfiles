-- Hard-wrap text to match the file being edited, on demand only: nothing wraps or reflows on its
-- own.  The width (and whether sentences end with two spaces) is inferred from the file's own
-- wrapped lines and set as 'textwidth'; `:setlocal tw=N` sets one for a file with no width to infer.
--
-- <leader>F (`:TexReflow`) reflows the block of prose around the cursor; in visual mode
-- (`:[range]TexReflow`), every block with a line in the selection.  A block is reflowed with `gw`
-- from its first line that is too long, or short enough to take the next line's first word, to
-- its end.  Lines above that one are never touched, so a diff shows only the lines that had to
-- move.  The cursor stays on the same text, and `u` undoes the whole reflow.

local bufnr = vim.api.nvim_get_current_buf()

-- Commands that own their line: a reflow never joins them with prose (\ab and \claude are notes).
local own_line = {
  begin = true,
  ['end'] = true,
  item = true,
  label = true,
  part = true,
  chapter = true,
  section = true,
  subsection = true,
  subsubsection = true,
  paragraph = true,
  subparagraph = true,
  ab = true,
  claude = true,
  centering = true,
  includegraphics = true,
  input = true,
  include = true,
}

-- Environments whose lines are not prose (math environments are caught by VimTeX's syntax).
local skip_env = { 'tabular', 'array', 'verbatim', 'Verbatim', 'lstlisting', 'minted', 'tikzpicture', 'algorithm' }

local function command(s)
  return s:match '^%s*\\(%a+)'
end

local function has_comment(s)
  return s:find '^%s*%%' ~= nil or s:find '[^\\]%%' ~= nil
end

-- Whether `s` is a line of prose that a reflow may join with its neighbours.
local function prose(s)
  return not (s:match '^%s*$' or s:match '^%s*\\[%[%]]' or s:match '^%s*%$%$' or own_line[command(s)] or has_comment(s))
end

local function ends_row(s)
  return s:match '\\\\%s*$' ~= nil or s:match '\\\\%[[^%]]*%]%s*$' ~= nil
end

-- The width the file is wrapped at: the 90th percentile of lines that wrap into the next one, so
-- that overlong lines not yet reflowed are ignored.  A file with few such lines, or ragged ones
-- (unwrapped, or one sentence per line), is not treated as wrapped.
local function infer_width(lines)
  local widths = {}
  for i = 1, #lines - 1 do
    local cur = lines[i]:gsub('%s+$', '')
    if prose(cur) and prose(lines[i + 1]) and not ends_row(cur) then
      widths[#widths + 1] = vim.api.nvim_strwidth(cur)
    end
  end
  if #widths < 10 then
    return 0
  end
  table.sort(widths)
  local tw = widths[math.ceil(#widths * 0.9)]
  local tight = #vim.tbl_filter(function(w)
    return w > tw - 20 and w <= tw
  end, widths)
  return tight >= 0.6 * #widths and tw or 0
end

local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
local width = infer_width(lines)
if width > 0 then
  vim.bo[bufnr].textwidth = width
end
-- No wrapping while typing, of text ('t') or of % comments ('c'): reflowing is left to <leader>F.
vim.opt_local.formatoptions:remove { 't', 'c' }
local text = table.concat(lines, '\n')
local _, two = text:gsub('[.?!]  %S', '')
local _, one = text:gsub('%l[.?!] %u', '')
vim.b[bufnr].tex_joinspaces = two > one

-- 'joinspaces' is global, so it follows the current buffer; it also makes `gq`, `gw` and `J`
-- follow the file's sentence spacing.
local group = vim.api.nvim_create_augroup('tex_autowrap_' .. bufnr, { clear = true })
local saved_joinspaces = vim.o.joinspaces
local function enter()
  saved_joinspaces = vim.o.joinspaces
  vim.o.joinspaces = vim.b[bufnr].tex_joinspaces
end
vim.api.nvim_create_autocmd('BufEnter', { group = group, buffer = bufnr, callback = enter })
vim.api.nvim_create_autocmd('BufLeave', {
  group = group,
  buffer = bufnr,
  callback = function()
    vim.o.joinspaces = saved_joinspaces
  end,
})
if vim.api.nvim_get_current_buf() == bufnr then
  enter()
end

-- The environments around the cursor, innermost first, as vimtex#env#get_all() gives them.  That
-- function never returns when an environment opens at line 1, column 1, as \begin{abstract} does
-- in the abstract: it steps back from each \begin, and there it steps back onto the same one.
local function environments()
  local view = vim.fn.winsaveview()
  local envs = {}
  while true do
    local env = vim.fn['vimtex#env#get_inner']()
    if vim.tbl_isempty(env) then
      break
    end
    envs[#envs + 1] = env
    if env.open.lnum == 1 and env.open.cnum <= 1 then
      break
    end
    vim.fn['vimtex#pos#set_cursor'](vim.fn['vimtex#pos#prev'](env.open))
  end
  vim.fn.winrestview(view)
  return envs
end

local function in_skipped_region(lnum, line)
  local ok, in_math = pcall(vim.fn['vimtex#syntax#in_mathzone'], lnum, 1)
  if ok and in_math == 1 and vim.fn['vimtex#syntax#in_mathzone'](lnum, #line) == 1 then
    return true
  end
  local ok_env, envs = pcall(environments)
  for _, env in ipairs(ok_env and envs or {}) do
    for _, name in ipairs(skip_env) do
      if env.name:find('^' .. name) then
        return true
      end
    end
  end
  return false
end

local function is_item(s)
  return command(s) == 'item'
end

-- The block of prose around line `lnum`, as its first and last line numbers: the lines a reflow
-- may join.  An \item line starts a block.
local function block_at(lnum)
  local line = vim.fn.getline(lnum)
  if not (prose(line) or is_item(line)) then
    return
  end
  local first, last, n = lnum, lnum, vim.fn.line '$'
  while first > 1 and not is_item(vim.fn.getline(first)) do
    local prev = vim.fn.getline(first - 1)
    if not (prose(prev) or is_item(prev)) or ends_row(prev) then
      break
    end
    first = first - 1
  end
  while last < n and not ends_row(vim.fn.getline(last)) and prose(vim.fn.getline(last + 1)) do
    last = last + 1
  end
  return first, last
end

-- The first line of first..last that is too long, or short enough to take the next line's first
-- word.
local function first_unfilled(first, last, tw)
  for lnum = first, last do
    local len = vim.api.nvim_strwidth((vim.fn.getline(lnum):gsub('%s+$', '')))
    local word = lnum < last and vim.fn.getline(lnum + 1):match '^%s*(%S+)'
    if len > tw or (word and len + 1 + vim.api.nvim_strwidth(word) <= tw) then
      return lnum
    end
  end
end

local function fill(first, last, tw)
  local start = first_unfilled(first, last, tw)
  if not start then
    return
  end
  vim.api.nvim_win_set_cursor(0, { start, 0 })
  if in_skipped_region(start, vim.fn.getline(start)) then
    return
  end
  -- A line broken off keeps the indent of the one it is broken from ('autoindent'), rather than
  -- taking the one 'indentexpr' gives: GetTeXIndent() indents the body of every environment,
  -- which these files leave unindented in abstract, proof and the theorem-like ones.  A count
  -- before `gww` would apply to a `w` motion, hence `gw{N}G`.
  local indentexpr = vim.bo[bufnr].indentexpr
  vim.bo[bufnr].indentexpr = ''
  pcall(vim.cmd, 'silent keepjumps normal! gw' .. last .. 'G')
  vim.bo[bufnr].indentexpr = indentexpr
end

local ns = vim.api.nvim_create_namespace 'tex_reflow'

-- Reflow every block with a line in line1..line2 (without a range, the cursor line).
local function reflow(line1, line2)
  local tw = vim.bo[bufnr].textwidth
  if tw == 0 then
    vim.notify('No width to reflow to: set one with :setlocal tw=N', vim.log.levels.WARN)
    return
  end
  local blocks, lnum = {}, line1
  while lnum <= line2 do
    local first, last = block_at(lnum)
    if first then
      blocks[#blocks + 1] = { first, last }
      lnum = last + 1
    else
      lnum = lnum + 1
    end
  end
  -- Bottom up, so the blocks above keep their line numbers; a mark keeps the cursor's text.
  local pos = vim.api.nvim_win_get_cursor(0)
  local mark = vim.api.nvim_buf_set_extmark(bufnr, ns, pos[1] - 1, pos[2], {})
  for k = #blocks, 1, -1 do
    fill(blocks[k][1], blocks[k][2], tw)
  end
  local row, col = unpack(vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, mark, {}))
  vim.api.nvim_buf_del_extmark(bufnr, ns, mark)
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

vim.api.nvim_buf_create_user_command(bufnr, 'TexReflow', function(opts)
  reflow(opts.line1, opts.line2)
end, { range = true, desc = 'Reflow the blocks of prose in the range (default: around the cursor)' })

vim.keymap.set('n', '<leader>F', '<cmd>TexReflow<cr>', { buffer = bufnr, desc = 'Reflow paragraph' })
vim.keymap.set('x', '<leader>F', ':TexReflow<cr>', { buffer = bufnr, silent = true, desc = 'Reflow selected paragraphs' })

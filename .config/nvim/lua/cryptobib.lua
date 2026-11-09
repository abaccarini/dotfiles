-- Cite from CryptoBib without putting it in the completion path.
--
-- A paper lists only abbrev3 and a small refs.bib in \bibliography, so VimTeX completes citations
-- from refs.bib alone.  M.pick() searches all of CryptoBib (https://github.com/cryptobib/export,
-- cloned at g:cryptobib_dir, default ~/work/cryptobib) with fzf-lua.  <CR> inserts the selected
-- keys (<Tab> marks several): inside \cite{...} they join the key list, elsewhere they are wrapped
-- in \cite{}.  Each entry that refs.bib (in the VimTeX project root, or b:cryptobib_target) does not
-- hold yet is copied there verbatim; CryptoBib's entries need the @string macros of its abbrev3.bib.
-- The search index (scripts/cryptobib_index.py) is rebuilt in the background whenever crypto.bib
-- changes, e.g. after `git -C ~/work/cryptobib pull`.

local M = {}

local function bib_path()
  return vim.fs.normalize(vim.g.cryptobib_dir or '~/work/cryptobib') .. '/crypto.bib'
end

local function index_path()
  return vim.fn.stdpath 'cache' .. '/cryptobib/index.tsv'
end

local function mtime(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.mtime.sec
end

-- Runs `callback` once the index is at least as new as crypto.bib, rebuilding it first if not.
local function with_index(callback)
  local bib, index = bib_path(), index_path()
  local bib_time = mtime(bib)
  if not bib_time then
    vim.notify('CryptoBib: no ' .. bib .. ' (set g:cryptobib_dir)', vim.log.levels.ERROR)
    return
  end
  if (mtime(index) or -1) >= bib_time then
    return callback()
  end
  vim.fn.mkdir(vim.fs.dirname(index), 'p')
  vim.notify 'CryptoBib: indexing crypto.bib'
  local script = vim.fn.stdpath 'config' .. '/scripts/cryptobib_index.py'
  vim.system({ 'python3', '-I', script, bib, index }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify('CryptoBib: indexing failed\n' .. (result.stderr or ''), vim.log.levels.ERROR)
      else
        callback()
      end
    end)
  end)
end

local function read_entry(start, length)
  local file = assert(io.open(bib_path(), 'rb'))
  file:seek('set', start - 1)
  local entry = file:read(length)
  file:close()
  return entry
end

-- The refs.bib that receives copied entries.
function M.refs_path()
  if vim.b.cryptobib_target then
    return vim.fs.normalize(vim.b.cryptobib_target)
  end
  local root = vim.b.vimtex and vim.b.vimtex.root or vim.fn.expand '%:p:h'
  return root .. '/refs.bib'
end

-- Appends to `refs` each item ({ key, start, length }) it does not hold yet; returns their keys.
function M.copy_entries(refs, items)
  local file = io.open(refs, 'r')
  if not file then
    vim.notify('CryptoBib: no ' .. refs .. ', so only the keys were inserted', vim.log.levels.WARN)
    return {}
  end
  local held = file:read 'a'
  file:close()
  local added = {}
  local out = assert(io.open(refs, 'a'))
  for _, item in ipairs(items) do
    if not held:find('{' .. item.key .. ',', 1, true) then
      out:write('\n', read_entry(item.start, item.length), '\n')
      added[#added + 1] = item.key
    end
  end
  out:close()
  return added
end

-- Whether `before`, the text left of the cursor, ends inside the key list of a \cite-like command
-- (\cite, \citep, \Cite, \parencite, ... with up to two optional arguments).
local function in_cite(before)
  local open = before:match '.*(){[^}]*$'
  if not open then
    return false
  end
  local head = before:sub(1, open - 1)
  local cmd = '\\%a*[Cc]ite%a*%*?%s*'
  return (head:match(cmd .. '$') or head:match(cmd .. '%b[]%s*$') or head:match(cmd .. '%b[]%s*%b[]%s*$')) ~= nil
end

-- `line` with `keys` inserted at the cursor, and the 0-based column of the last inserted byte.
-- `col` is fzf-lua's: the cursor's byte column plus one.  In insert mode the keys go before that
-- byte, in normal mode after it, as `a` would put them.
function M.insert_keys(line, col, keys, insert_mode)
  local cut = insert_mode and col - 1 or math.min(col, #line)
  local before, after = line:sub(1, cut), line:sub(cut + 1)
  local list = table.concat(keys, ',')
  local text
  if in_cite(before) then
    text = (before:match '[{,]%s*$' and '' or ',') .. list
  else
    text = '\\cite{' .. list .. '}'
  end
  return before .. text .. after, #before + #text - 1
end

function M.pick()
  local refs = M.refs_path()
  with_index(function()
    require('fzf-lua').fzf_exec('cat ' .. vim.fn.shellescape(index_path()), {
      prompt = 'CryptoBib> ',
      fzf_opts = {
        ['--delimiter'] = '\t',
        ['--with-nth'] = '1..4',
        ['--multi'] = true,
        ['--tiebreak'] = 'index', -- the index lists the newest papers first
        ['--no-hscroll'] = true, -- keep the key column in view when the match is in a long title
        ['--preview'] = 'tail -c +{5} ' .. vim.fn.shellescape(bib_path()) .. ' | head -c {6}',
        ['--preview-window'] = 'down,40%,wrap',
      },
      complete = function(selected, opts, line, col)
        local items = {}
        for _, entry in ipairs(selected) do
          local key, start, length = entry:match '^([^\t]+)\t.*\t(%d+)\t(%d+)$'
          items[#items + 1] = { key = key, start = tonumber(start), length = tonumber(length) }
        end
        local added = M.copy_entries(refs, items)
        if #added > 0 then
          vim.notify('CryptoBib: added ' .. table.concat(added, ', ') .. ' to ' .. vim.fn.fnamemodify(refs, ':~:.'))
          vim.cmd.checktime()
        end
        local keys = vim.tbl_map(function(item)
          return item.key
        end, items)
        return M.insert_keys(line, col, keys, opts.__CTX.mode:sub(1, 1) == 'i')
      end,
    })
  end)
end

return M

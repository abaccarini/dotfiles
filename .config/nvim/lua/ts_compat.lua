-- Neovim 0.12 removed the `all = false` option from the treesitter query API:
-- a match now *always* maps a capture id to a list of nodes, where `all = false`
-- used to hand back a bare TSNode.
--
-- nvim-treesitter's master branch is frozen at Neovim 0.11 (its README says
-- "Neovim 0.10 or 0.11 (Neovim 0.12 is not supported)") and still passes
-- `all = false`, then indexes matches as single nodes. On 0.12 its handlers get
-- a plain table where they expect a TSNode, which surfaces as
--   treesitter.lua:197: attempt to call method 'range' (a nil value)
-- from the highlighter's decoration provider whenever an injection query uses
-- one of those directives (markdown, bash, html_tags, ruby, hcl, php, hurl).
--
-- This restores the old single-node shape, but only for callers that explicitly
-- opt in with `all = false`. Everything else keeps 0.12 semantics untouched.

local M = {}

local applied = false

---@param match table<integer, TSNode[]>
---@return table<integer, TSNode>
local function first_nodes(match)
  local single = {}
  for id, nodes in pairs(match) do
    single[id] = type(nodes) == 'table' and nodes[1] or nodes
  end
  return single
end

local function wants_single(opts)
  return type(opts) == 'table' and opts.all == false
end

-- Predicates and directives receive the match table directly.
local function patch_registrars()
  local query = vim.treesitter.query
  for _, fn in ipairs { 'add_predicate', 'add_directive' } do
    local register = query[fn]
    query[fn] = function(name, handler, opts)
      if wants_single(opts) then
        local original = handler
        handler = function(match, ...)
          return original(first_nodes(match), ...)
        end
      end
      return register(name, handler, opts)
    end
  end
end

-- nvim-treesitter.query.iter_prepared_matches() iterates matches itself.
local function patch_iter_matches()
  local ok, probe = pcall(vim.treesitter.query.parse, 'lua', '((identifier) @a)')
  if not ok then
    return false
  end

  local mt = getmetatable(probe)
  local Query = mt and mt.__index
  if type(Query) ~= 'table' or type(Query.iter_matches) ~= 'function' then
    return false
  end

  local iter_matches = Query.iter_matches
  Query.iter_matches = function(self, node, source, start, stop, opts)
    local iter = iter_matches(self, node, source, start, stop, opts)
    if not wants_single(opts) then
      return iter
    end
    return function(...)
      local pattern, match, metadata = iter(...)
      if match ~= nil then
        match = first_nodes(match)
      end
      return pattern, match, metadata
    end
  end

  return true
end

--- Must run before nvim-treesitter loads: `lua/nvim-treesitter.lua` requires
--- `nvim-treesitter.query_predicates` at plugin-load time, which is earlier than
--- lazy.nvim's `config`.
function M.setup()
  if applied or vim.fn.has 'nvim-0.12' == 0 then
    return
  end
  applied = true

  patch_registrars()
  patch_iter_matches()
end

return M

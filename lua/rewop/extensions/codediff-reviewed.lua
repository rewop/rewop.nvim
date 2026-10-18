-- Local "mark file as reviewed" for codediff explorer rows (neither codediff
-- nor review.nvim has this). State is kept per git root and persisted to
-- stdpath('data')/codediff-reviewed.json.
-- Reviewed files get a check mark and a dimmed name.
-- Caveats: relies on codediff internals (lifecycle.get_panel_view,
-- explorer.tree/data); a toggle re-renders the whole tree.
local M = {}

local store = vim.fn.stdpath 'data' .. '/codediff-reviewed.json'

local function load()
  local f = io.open(store, 'r')
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read '*a')
  f:close()
  return ok and type(data) == 'table' and data or {}
end

local reviewed = load() -- [git_root] = { [path] = true }

local function save()
  local f = io.open(store, 'w')
  if f then
    f:write(vim.json.encode(reviewed))
    f:close()
  end
end

local function root_of(explorer)
  return explorer.data and explorer.data.git_root or ''
end

local function is_reviewed(root, path)
  return reviewed[root] and reviewed[root][path] or false
end

local function current_explorer()
  local lifecycle = package.loaded['codediff.ui.lifecycle']
  return lifecycle and lifecycle.get_panel_view(vim.api.nvim_get_current_tabpage())
end

--- Row formatter: wraps codediff's default file row.
function M.file_formatter(root_getter)
  return function(ctx)
    local default = require('codediff.ui.explorer.formatters').file
    local layout = default(ctx)
    if not is_reviewed(root_getter(), ctx.path) then
      return layout
    end
    for _, region in ipairs(layout.left) do
      for _, seg in ipairs(region.segments) do
        if seg.text == ctx.filename then
          seg.hl = 'Comment'
        end
      end
    end
    table.insert(layout.right, 1, { segments = { { text = '✓ ', hl = { fg = '#3fb950', bold = true } } } })
    return layout
  end
end

--- Toggle reviewed for the file under the explorer cursor, or the file open in a diff pane.
function M.toggle()
  local explorer = current_explorer()
  if not explorer then
    vim.notify('Not in a codediff session', vim.log.levels.WARN)
    return
  end
  local in_explorer = vim.api.nvim_get_current_buf() == explorer.bufnr
  local path
  if in_explorer then
    local node = explorer.tree:get_node()
    path = node and node.data and node.data.type ~= 'group' and node.data.type ~= 'directory' and node.data.path
  else
    local sel = explorer.data.current_selection
    path = sel and sel.path
  end
  if not path then
    return
  end
  local root = root_of(explorer)
  reviewed[root] = reviewed[root] or {}
  reviewed[root][path] = (not reviewed[root][path]) or nil
  save()
  explorer.tree:render()
  if in_explorer then
    pcall(vim.cmd, 'normal! j')
  end
end

function M.clear()
  local explorer = current_explorer()
  if explorer then
    reviewed[root_of(explorer)] = nil
    save()
    explorer.tree:render()
  end
end

-- Formatter needs the root of the explorer being rendered; one explorer per
-- tab, so resolve it from the current tab.
function M.current_root()
  local explorer = current_explorer()
  return explorer and root_of(explorer) or ''
end

return M

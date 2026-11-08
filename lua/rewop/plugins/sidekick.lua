-- codediff shows committed revisions in virtual buffers, which sidekick doesn't
-- treat as files. Resolve them to the real path so locations can still be sent.
local function location(kind)
  return function(ctx)
    local name = vim.api.nvim_buf_get_name(ctx.buf)
    if not name:match '^codediff://' then
      return require('sidekick.cli.context').context[kind](ctx)
    end
    local root, commit, path = require('codediff.core.virtual_file').parse_url(name)
    if not path then
      return false
    end
    local loc = { name = root .. '/' .. path, cwd = ctx.cwd, row = ctx.row, col = ctx.col, range = ctx.range }
    local ret = require('sidekick.cli.context.location').get(loc, { kind = kind })
    table.insert(ret[1], { ' (at commit ' .. commit:sub(1, 8) .. ')' })
    return ret
  end
end

-- Like sidekick's own picker, but hides external sessions (agents running in other
-- tmux panes), which can't be opened in a window. If `name` is given and that tool
-- is already attached, just toggle its window.
local function pick(name)
  local State = require 'sidekick.cli.state'
  if name and #State.get { name = name, attached = true } > 0 then
    return require('sidekick.cli').toggle { name = name, focus = true }
  end
  local items = vim.tbl_filter(function(s)
    return not s.external
  end, State.get { name = name, installed = true })
  local open = function(state)
    if state then
      State.attach(state, { show = true, focus = true })
    end
  end
  if name and #items == 1 then
    return open(items[1])
  end
  vim.ui.select(items, {
    prompt = 'Select CLI tool:',
    kind = 'sidekick_cli',
    format_item = function(state)
      return table.concat(vim.tbl_map(function(p)
        return p[1]
      end, require('sidekick.cli.ui.select').format(state)))
    end,
  }, open)
end

return {
  'folke/sidekick.nvim',
  opts = {
    -- only the CLI integration is used, copilot.lua handles suggestions
    nes = { enabled = false },
    cli = {
      win = { layout = 'left', split = { width = 60 } },
      context = {
        position = location 'position',
        file = location 'file',
        line = location 'line',
      },
    },
  },
  keys = {
    {
      '<leader>ii',
      function()
        pick 'claude'
      end,
      desc = 'Sidekick toggle Claude',
    },
    {
      '<leader>iP',
      function()
        pick 'pi'
      end,
      desc = 'Sidekick toggle Pi',
    },
    {
      '<leader>is',
      function()
        pick()
      end,
      desc = 'Sidekick select CLI',
    },
    {
      '<leader>id',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Sidekick detach CLI session',
    },
    {
      '<leader>it',
      function()
        require('sidekick.cli').send { msg = '{position|selection}' }
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick send this',
    },
    {
      '<leader>if',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Sidekick send file',
    },
    {
      '<leader>iv',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Sidekick send selection',
    },
    {
      '<leader>ip',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick select prompt',
    },
    {
      '<c-.>',
      function()
        -- nothing open yet: use the filtered picker instead of sidekick's full list
        if #require('sidekick.cli.state').get { attached = true, terminal = true } == 0 then
          return pick()
        end
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 't', 'i', 'x' },
      desc = 'Sidekick toggle focus (sidekick <-> previous window)',
    },
  },
}

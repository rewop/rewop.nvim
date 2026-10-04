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

return {
  'folke/sidekick.nvim',
  opts = {
    -- only the CLI integration is used, copilot.lua handles suggestions
    nes = { enabled = false },
    cli = {
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
        require('sidekick.cli').toggle { name = 'claude', focus = true }
      end,
      desc = 'Sidekick toggle Claude',
    },
    {
      '<leader>is',
      function()
        require('sidekick.cli').select { filter = { installed = true } }
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
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 't', 'i', 'x' },
      desc = 'Sidekick focus',
    },
  },
}

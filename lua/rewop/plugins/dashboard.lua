local header = [[
 _ __ _____      _____  _ __
| '__/ _ \ \ /\ / / _ \| '_ \
| | |  __/\ V  V / (_) | |_) |
|_|  \___| \_/\_/ \___/| .__/
                       |_|   ]]

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        header = header,
        keys = {
          { icon = ' ', key = 'f', desc = 'Find file', action = ':FzfLua files' },
          { icon = ' ', key = 'r', desc = 'Recent files', action = ':FzfLua oldfiles' },
          { icon = ' ', key = 'g', desc = 'Grep', action = ':FzfLua live_grep' },
          { icon = ' ', key = 's', desc = 'Restore session', action = ":lua require('persistence').load()" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { icon = ' ', title = 'Recent files', section = 'recent_files', cwd = true, indent = 2, padding = 1 },
      },
    },
  },
}

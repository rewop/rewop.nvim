return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      '<leader>Ss',
      function()
        require('persistence').load()
      end,
      desc = 'Restore session for current directory',
    },
    {
      '<leader>Sl',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Restore last session',
    },
    {
      '<leader>Sd',
      function()
        require('persistence').stop()
      end,
      desc = "Don't save current session",
    },
  },
}

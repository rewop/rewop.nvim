return {
  'georgeguimaraes/review.nvim',
  version = '*',
  dependencies = {
    {
      'esmuellert/codediff.nvim',
      opts = {
        explorer = { view_mode = 'tree' },
        history = { view_mode = 'tree' },
      },
    },
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Review',
  opts = {},
  keys = {
    { '<leader>rr', '<cmd>Review<cr>', desc = 'Review working tree' },
    { '<leader>rc', '<cmd>Review commits<cr>', desc = 'Review commits' },
    { '<leader>rb', '<cmd>Review branch<cr>', desc = 'Review branch' },
    { '<leader>rl', '<cmd>Review list<cr>', desc = 'Review list comments' },
    { '<leader>rp', '<cmd>Review preview<cr>', desc = 'Review preview export' },
    { '<leader>rs', '<cmd>Review sidekick<cr>', desc = 'Review send comments to sidekick' },
  },
}

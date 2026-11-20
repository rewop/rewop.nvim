-- Connects nvim to Claude Code over its IDE protocol (same as the VS Code extension):
-- Claude sees the open file/selection and proposes edits as native nvim diffs.
-- Loaded eagerly so the server is up for any `claude` in this cwd (run `/ide` there).
-- <leader>a is taken by harpoon/amp, so this lives under <leader>C.
return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  lazy = false,
  config = true,
  keys = {
    { '<leader>C', nil, desc = 'Claude Code' },
    { '<leader>Cc', '<cmd>ClaudeCode<cr>', desc = 'Claude Code toggle' },
    { '<leader>Cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude Code focus' },
    { '<leader>Cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Claude Code resume' },
    { '<leader>CC', '<cmd>ClaudeCode --continue<cr>', desc = 'Claude Code continue' },
    { '<leader>Cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Claude Code select model' },
    { '<leader>Cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude Code add current buffer' },
    { '<leader>Cs', '<cmd>ClaudeCodeSend<cr>', mode = 'x', desc = 'Claude Code send selection' },
    {
      '<leader>Cs',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Claude Code add file',
      ft = { 'neo-tree', 'netrw', 'snacks_picker_list' },
    },
    { '<leader>Ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Claude Code accept diff' },
    { '<leader>Cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Claude Code deny diff' },
  },
}

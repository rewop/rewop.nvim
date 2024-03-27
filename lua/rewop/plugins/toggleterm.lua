return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      direction = 'float',
    }

    vim.keymap.set('n', '<leader>tt', '<CMD>ToggleTerm<CR>', { desc = 'Toggle terminal' })
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { desc = 'ESC terminal mode' })
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = 'Move window left' })
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = 'Move window down' })
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = 'Move window up' })
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = 'Move window right' })
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { desc = 'Enter wincmd' })
  end,
}

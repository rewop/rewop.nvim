-- [[ Basic Keymaps ]]

-- Map escape
vim.keymap.set({ 'i', 'v' }, 'jk', '<Esc>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- insert blank line without leaving normal mode
vim.keymap.set('n', '<Leader>o', 'o<Esc>', { desc = 'Add a blank line below without insert mode' })
vim.keymap.set('n', '<Leader>O', 'O<Esc>', { desc = 'Add a blank line above without insert mode' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Center screen when searching and scrolling
vim.keymap.set('n', '<C-u>', '<C-u>zz', {})
vim.keymap.set('n', '<C-d>', '<C-d>zz', {})
vim.keymap.set('n', '<C-b>', '<C-b>zz', {})
vim.keymap.set('n', '<C-f>', '<C-f>zz', {})
vim.keymap.set('n', 'n', 'nzz', {})
vim.keymap.set('n', 'N', 'Nzz', {})

-- Remaps for buffer operations
vim.keymap.set('n', '<leader>bd', function()
  local current_bf = vim.api.nvim_get_current_buf()
  local prev_bf = vim.fn.getbufinfo('#')[1]
  if prev_bf ~= nil and prev_bf.listed == 1 then
    vim.cmd.b(prev_bf.bufnr)
  end
  vim.api.nvim_buf_delete(current_bf, {})
end, { desc = '[D]elete current [b]uffer' })
vim.keymap.set('n', '<leader>bb', '<Cmd>b#<CR>', { desc = 'Go to alternate buffer' })
vim.keymap.set('n', '<leader>bD', '<Cmd>%bd<CR>', { desc = 'Delete all buffers' })
vim.keymap.set('n', '<leader>bO', '<Cmd>%bd|e#<CR>', { desc = 'Delete all other buffers' })
vim.keymap.set('n', '<leader>`', '<Cmd>b#<CR>', { desc = 'Go to alternate buffer' })
vim.keymap.set('n', '[b', '<Cmd>bp<CR>', { desc = 'Go to prev buffer' })
vim.keymap.set('n', ']b', '<Cmd>bn<CR>', { desc = 'Go to next buffer' })

-- Save commands
vim.keymap.set('n', '<C-s>', '<Cmd>w<CR>')
vim.keymap.set('n', '<C-S>', '<Cmd>wa<CR>')

-- kaymap for lazy
vim.keymap.set('n', '<leader>l', '<Cmd>Lazy<CR>', { desc = 'Open [L]azy' })

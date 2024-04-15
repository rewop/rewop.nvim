-- [[ Basic Keymaps ]]

-- Map escape
vim.keymap.set({ 'i', 'v' }, 'jk', '<Esc>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- easy motion for start and end of line
vim.keymap.set({ 'n', 'v' }, 'H', '^', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'L', '$', { silent = true })

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
vim.keymap.set('n', '<leader>w', '<Cmd>w<CR>', { desc = 'Write current buffer' })
vim.keymap.set('n', '<leader>W', '<Cmd>wa<CR>', { desc = 'Write all buffer' })

-- kaymap for lazy
vim.keymap.set('n', '<leader>l', '<Cmd>Lazy<CR>', { desc = 'Open [L]azy' })

-- keymap for tabs
vim.keymap.set('n', '<leader>tc', '<Cmd>tabnew<CR>', { desc = 'Crate a new tab' })
vim.keymap.set('n', '<leader>tx', '<Cmd>tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>tp', '<Cmd>tabp<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabn<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = 'Close other tabs' })

-- keymaps for register
vim.keymap.set('n', '<leader>y+', '"+y', { desc = 'Yank to system register' })
vim.keymap.set('n', '<leader>p+', '"+p', { desc = 'Paste from system register' })
vim.keymap.set('n', '<leader>py', '"0p', { desc = 'Paste from the last yank register' })
vim.keymap.set('n', '<leader>pd', '"1p', { desc = 'Paste from the last delete register' })

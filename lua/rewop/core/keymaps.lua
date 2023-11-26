-- [[ Basic Keymaps ]]

-- Map escape 
vim.keymap.set({'i', 'v'}, 'jk', '<Esc>')

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
  vim.api.nvim_buf_delete(0, {})
end, { desc = '[D]elete current [b]uffer' })
vim.keymap.set("n", "<leader>bb", "<Cmd>b#<CR>", { desc = "Go to alternate buffer" })
vim.keymap.set("n", "<leader>`", "<Cmd>b#<CR>", { desc = "Go to alternate buffer" })
vim.keymap.set("n", "[b", "<Cmd>bp<CR>", { desc = "Go to prev buffer" })
vim.keymap.set("n", "]b", "<Cmd>bn<CR>", { desc = "Go to next buffer" })

-- Save commands
vim.keymap.set('n', '<C-s>', '<Cmd>w<CR>')
vim.keymap.set('n', '<C-S>', '<Cmd>wa<CR>')

-- keymaps for diffview
vim.keymap.set('n', '<leader>gv', function () require('diffview').open() end, { desc = 'Open [G]it Diff[V]iew' })
vim.keymap.set('n', '<leader>gq', function () require('diffview').close() end, { desc = '[C]lose [G]it Diffview' })

-- kaymap for lazy
vim.keymap.set('n', '<leader>l', '<Cmd>Lazy<CR>', { desc = "Open [L]azy" })

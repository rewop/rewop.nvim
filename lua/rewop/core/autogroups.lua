-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Soft wrap markdown ]]
local markdown_wrap_group = vim.api.nvim_create_augroup('MarkdownWrap', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
  group = markdown_wrap_group,
  pattern = 'markdown',
})

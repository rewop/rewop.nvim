-- Create command to be able to disable autoformatiing on save
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

-- Create command to enable formatting on save
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  -- Customize or remove this keymap to your liking
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  config = function()
    -- oxfmt wins in projects that configure it; otherwise fall back to prettier.
    local js = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true }

    require('conform').setup {
      formatters = {
        oxfmt = {
          condition = function(_, ctx)
            return vim.fs.root(ctx.dirname, { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }) ~= nil
          end,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = js,
        typescript = js,
        javascriptreact = js,
        typescriptreact = js,
        css = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        json = js,
        yaml = { 'prettierd', 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        astro = { 'prettierd', 'prettier' },
        go = { 'goimports', 'gofumpt' },
        proto = { 'buf' },
        sql = { 'sqlfluff' },
        python = { 'ruff' },
        cs = { 'csharpier' },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    }
  end,
}

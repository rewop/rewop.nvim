return {
  'mfussenegger/nvim-lint',
  event = {
    'BufReadPre',
    'BufNewFile',
  },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- Only run eslint_d in projects that actually configure ESLint (e.g. oxlint projects
    -- are linted by the oxlint language server instead).
    local eslint_configs = {
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      'eslint.config.mts',
      'eslint.config.cts',
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.json',
      '.eslintrc.yml',
      '.eslintrc.yaml',
    }

    local function try_lint()
      if lint.linters_by_ft[vim.bo.filetype] and not vim.fs.root(0, eslint_configs) then
        return
      end
      lint.try_lint()
    end

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = try_lint,
    })

    vim.keymap.set('n', '<leader>cl', try_lint, { desc = 'Trigger linting for current buffer' })
  end,
}

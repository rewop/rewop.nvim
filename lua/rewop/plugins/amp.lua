-- Connects nvim to the Amp CLI: run `amp` (IDE connection is on by default) in the
-- same workspace and it sees the open file, selection and diagnostics.
-- Note: upstream marks amp.nvim as deprecated/unmaintained.
return {
  'sourcegraph/amp.nvim',
  branch = 'main',
  lazy = false,
  opts = { auto_start = true, log_level = 'info' },
  config = function(_, opts)
    require('amp').setup(opts)

    local msg = function()
      return require 'amp.message'
    end

    vim.api.nvim_create_user_command('AmpSend', function(o)
      if o.args == '' then
        return vim.notify('Usage: :AmpSend <message>', vim.log.levels.WARN)
      end
      msg().send_message(o.args)
    end, { nargs = '*', desc = 'Send a message to Amp' })

    vim.api.nvim_create_user_command('AmpSendBuffer', function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      msg().send_message(table.concat(lines, '\n'))
    end, { desc = 'Send current buffer contents to Amp' })

    vim.api.nvim_create_user_command('AmpPromptSelection', function(o)
      local lines = vim.api.nvim_buf_get_lines(0, o.line1 - 1, o.line2, false)
      msg().send_to_prompt(table.concat(lines, '\n'))
    end, { range = true, desc = 'Add selected text to the Amp prompt' })

    vim.api.nvim_create_user_command('AmpPromptRef', function(o)
      local ref = '@' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
      if o.range > 0 then
        ref = ref .. '#L' .. o.line1 .. (o.line1 ~= o.line2 and ('-' .. o.line2) or '')
      end
      msg().send_to_prompt(ref)
    end, { range = true, desc = 'Add a file reference to the Amp prompt' })
  end,
  keys = {
    { '<leader>ar', ':AmpPromptRef<cr>', mode = { 'n', 'x' }, desc = 'Amp add file reference to prompt' },
    { '<leader>as', ':AmpPromptSelection<cr>', mode = 'x', desc = 'Amp add selection to prompt' },
  },
}

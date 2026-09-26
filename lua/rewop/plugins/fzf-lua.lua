-- Fuzzy Finder (files, lsp, etc)
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzf = require 'fzf-lua'

    fzf.setup {
      winopts = {
        height = 0.95,
        width = 0.95,
        preview = { layout = 'vertical', vertical = 'up:50%' },
      },
      fzf_opts = { ['--layout'] = 'default' }, -- prompt at the bottom, list grows upward
      keymap = {
        fzf = {
          ['ctrl-j'] = 'down',
          ['ctrl-k'] = 'up',
        },
      },
      actions = {
        files = {
          ['enter'] = require('fzf-lua.actions').file_edit_or_qf,
          ['ctrl-s'] = require('fzf-lua.actions').file_sel_to_qf,
        },
      },
      lsp = { file_icons = true },
    }

    vim.keymap.set('n', '<leader><space>', fzf.files, { desc = '[ ] Find files' })
    vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = 'Search [G]it [F]ile' })
    vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]ile' })
    vim.keymap.set('n', '<leader>sb', fzf.buffers, { desc = '[S]earch [B]uffers' })
    vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
  end,
}

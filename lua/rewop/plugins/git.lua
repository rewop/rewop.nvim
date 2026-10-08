-- Git related plugins
return {
  'tpope/vim-fugitive',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = 'Stage git hunk' })
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = 'Reset git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        -- gitsigns attaches after codediff has set its keymaps and would shadow
        -- them, so hand hunk navigation back to codediff inside a diff session
        local function in_codediff()
          local lifecycle = package.loaded['codediff.ui.lifecycle']
          return lifecycle and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) ~= nil
        end
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            if in_codediff() then
              require('codediff').next_hunk()
            else
              gs.next_hunk()
            end
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            if in_codediff() then
              require('codediff').prev_hunk()
            else
              gs.prev_hunk()
            end
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'esmuellert/codediff.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = function()
      require('neogit').setup()

      -- neogit's codediff integration still builds the pre-v4 session config
      -- (mode/original_path/explorer_data); codediff v4 expects Path refs and a
      -- panel table, so translate until neogit catches up
      local view = require 'codediff.ui.view'
      local path = require 'codediff.core.path'
      local create = view.create
      view.create = function(cfg, ...)
        if cfg.mode and not cfg.original then
          cfg.original = path.make_ref(cfg.original_path, cfg.git_root)
          cfg.modified = path.make_ref(cfg.modified_path, cfg.git_root)
          if cfg.mode == 'explorer' then
            local data = cfg.explorer_data or {}
            if cfg.original_revision then
              data.source_revisions = { original = cfg.original_revision, modified = cfg.modified_revision }
            end
            cfg.panel = { name = 'explorer', data = data }
          end
        end
        return create(cfg, ...)
      end
      vim.keymap.set('n', '<leader>gg', function()
        require('neogit').open { kind = 'tab' }
      end, { desc = 'Open Neogit' })
    end,
  },
}

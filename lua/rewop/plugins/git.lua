-- Git related plugins

-- Inline blame as a pill: gap, then " author · 3 days ago · summary " on a
-- raised background (highlights in plugins/colorscheme.lua)
local function blame_pill(name, info)
  local gap = { '    ' }
  if info.author == 'Not Committed Yet' then
    return { gap, { ' You · uncommitted ', 'GitSignsCurrentLineBlame' } }
  end
  local author = info.author == name and 'You' or info.author
  local summary = info.summary or ''
  if vim.fn.strchars(summary) > 60 then
    summary = vim.fn.strcharpart(summary, 0, 59) .. '…'
  end
  local when = require('gitsigns.util').get_relative_time(tonumber(info.author_time))
  return {
    gap,
    { ' ' .. author, 'GitSignsBlameAuthor' },
    { ' · ' .. when .. ' · ' .. summary .. ' ', 'GitSignsCurrentLineBlame' },
  }
end

-- Full blame popup (commit message + the hunk it introduced) on a solid
-- background: floats are transparent globally (catppuccin), which makes this
-- popup hard to read, so restyle just this window once it's open.
-- Highlight groups are defined in plugins/colorscheme.lua.
local blame_popup_winhl = table.concat({
  'NormalFloat:GitSignsPopup',
  'FloatBorder:GitSignsPopupBorder',
  'Directory:GitSignsPopupSha', -- commit hash
  'MoreMsg:GitSignsPopupAuthor', -- author
  'Label:GitSignsPopupDate', -- date
  'Title:GitSignsPopupHunk', -- "Hunk 1 of 4 @@ ... @@"
  'GitSignsAddPreview:DiffAdd', -- full-line backgrounds for the diff
  'GitSignsDeletePreview:DiffDelete',
}, ',')

local function style_blame_popup(win)
  vim.wo[win].winhighlight = blame_popup_winhl
  -- Commit message: the lines between the header and the first "Hunk" line.
  -- Light markdown-ish highlighting (gitsigns renders it as plain text).
  local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false)
  local msg_end = #lines + 1
  for i, l in ipairs(lines) do
    if l:match '^Hunk %d+ of %d+' then
      msg_end = i
      break
    end
  end
  local in_msg = ([[\%%>1l\%%<%dl]]):format(msg_end)
  local function add(group, pattern)
    vim.fn.matchadd(group, pattern, 10, -1, { window = win })
  end
  add('GitSignsPopupSubject', [[\%2l.*]]) -- subject line
  add('GitSignsPopupType', [[\%2l^\w\+\%(([^)]*)\)\?!\?:]]) -- feat(scope):
  add('GitSignsPopupCode', in_msg .. [[`[^`]\+`]]) -- `code`
  add('GitSignsPopupBullet', in_msg .. [[^\s*\zs[-*]\ze\s]]) -- - bullets
  add('GitSignsPopupTrailer', in_msg .. [[^[A-Z][A-Za-z-]\+:\ze\s]]) -- Co-Authored-By:
end

local function blame_popup()
  require('gitsigns').blame_line({ full = true }, function()
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.w[win].gitsigns_preview == 'blame' and vim.wo[win].winhighlight ~= blame_popup_winhl then
          style_blame_popup(win)
        end
      end
    end)
  end)
end

return {
  'tpope/vim-fugitive',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    init = function()
      local group = vim.api.nvim_create_augroup('rewop_gitsigns_q', {})

      -- `:q`-style close for the blame panel (<leader>gB)
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'gitsigns-blame',
        callback = function(ev)
          vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = ev.buf, nowait = true, desc = 'Close blame' })
        end,
      })

      -- `d` from the blame panel opens a tab holding only gitsigns:// revision
      -- buffers. Close that whole tab with q; anywhere else (e.g. a regular
      -- :Gitsigns diffthis split) q only closes the window.
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = group,
        pattern = 'gitsigns://*',
        callback = function(ev)
          vim.keymap.set('n', 'q', function()
            local only_revisions = true
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              if vim.api.nvim_win_get_config(win).relative == '' and not name:match '^gitsigns://' then
                only_revisions = false
                break
              end
            end
            if only_revisions and #vim.api.nvim_list_tabpages() > 1 then
              vim.cmd.tabclose()
            else
              vim.cmd.close()
            end
          end, { buffer = ev.buf, nowait = true, desc = 'Close gitsigns diff' })
        end,
      })
    end,
    opts = {
      -- See `:help gitsigns.txt`
      current_line_blame_formatter = blame_pill,
      current_line_blame_formatter_nc = blame_pill,
      preview_config = { border = 'rounded' },
      -- default 1000ms; blame is computed once per file, so lookups are cheap
      current_line_blame_opts = { delay = 100 },
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
        vim.keymap.set('n', '<leader>gb', blame_popup, { buffer = bufnr, desc = 'Blame line (popup)' })
        vim.keymap.set('n', '<leader>gt', require('gitsigns').toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle inline blame' })
        vim.keymap.set('n', '<leader>gB', require('gitsigns').blame, { buffer = bufnr, desc = 'Blame file' })

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

      -- History of the current file / selected lines. Visual mode uses `:` (not
      -- <cmd>) so the '<,'> range reaches the command.
      vim.keymap.set('n', '<leader>gh', '<cmd>CodeDiff history %<cr>', { desc = 'File history (codediff)' })
      vim.keymap.set('x', '<leader>gh', ':CodeDiff history<cr>', { silent = true, desc = 'Line history (codediff)' })
      vim.keymap.set('n', '<leader>gl', '<cmd>NeogitLogCurrent<cr>', { desc = 'File log (Neogit)' })
      vim.keymap.set('x', '<leader>gl', ':NeogitLogCurrent<cr>', { silent = true, desc = 'Line log (Neogit)' })
    end,
  },
}

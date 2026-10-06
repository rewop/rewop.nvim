-- lowercase "rewop" in the ANSI shadow style, one glyph per letter.
-- p has a descender (rows 7-8).
local glyphs = {
  {
    '██████╗ ',
    '██╔═══╝ ',
    '██║     ',
    '██║     ',
    '██║     ',
    '╚═╝     ',
    '        ',
    '        ',
  },
  {
    ' ██████╗ ',
    '██╔═══██╗',
    '████████║',
    '██╔═════╝',
    '╚███████╗',
    ' ╚══════╝',
    '         ',
    '         ',
  },
  {
    '██╗    ██╗',
    '██║    ██║',
    '██║ █╗ ██║',
    '██║███╗██║',
    '╚███╔███╔╝',
    ' ╚══╝╚══╝ ',
    '          ',
    '          ',
  },
  {
    ' ██████╗ ',
    '██╔═══██╗',
    '██║   ██║',
    '██║   ██║',
    '╚██████╔╝',
    ' ╚═════╝ ',
    '         ',
    '         ',
  },
  {
    '██████╗  ',
    '██╔══██╗ ',
    '██║  ██║ ',
    '██║  ██║ ',
    '██████╔╝ ',
    '██╔═══╝  ',
    '██║      ',
    '╚═╝      ',
  },
}

-- catppuccin color of the header
local header_color = 'blue'

local function set_highlights()
  local ok, palettes = pcall(require, 'catppuccin.palettes')
  if not ok then
    return
  end
  local c = palettes.get_palette()
  vim.api.nvim_set_hl(0, 'RewopHeader', { fg = c[header_color] })
  vim.api.nvim_set_hl(0, 'SnacksDashboardIcon', { fg = c.blue })
  vim.api.nvim_set_hl(0, 'SnacksDashboardKey', { fg = c.peach, bold = true })
  vim.api.nvim_set_hl(0, 'SnacksDashboardDesc', { fg = c.text })
  vim.api.nvim_set_hl(0, 'SnacksDashboardTitle', { fg = c.mauve, bold = true })
  vim.api.nvim_set_hl(0, 'SnacksDashboardFile', { fg = c.subtext1 })
  vim.api.nvim_set_hl(0, 'SnacksDashboardDir', { fg = c.overlay1 })
end

-- review the current branch against main/master (merge-base aware), skipping
-- the branch picker; falls back to the picker on a detached HEAD
local function review_branch()
  local branch = vim.trim(vim.fn.system { 'git', 'branch', '--show-current' })
  vim.cmd('Review branch' .. (branch ~= '' and vim.v.shell_error == 0 and ' ' .. branch or ''))
end

local function header()
  local rows = {}
  for row = 1, #glyphs[1] do
    local text = {}
    for _, glyph in ipairs(glyphs) do
      table.insert(text, glyph[row])
    end
    table.insert(rows, { text = { { table.concat(text), hl = 'RewopHeader' } }, align = 'center', padding = row == #glyphs[1] and 1 or 0 })
  end
  return rows
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      desc = 'Apply catppuccin colors to the dashboard',
      group = vim.api.nvim_create_augroup('rewop-dashboard-hl', {}),
      callback = set_highlights,
    })
  end,
  config = function(_, opts)
    require('snacks').setup(opts)
    set_highlights()
  end,
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        keys = {
          { icon = ' ', key = 'd', desc = 'Review changes (CodeDiff)', action = ':CodeDiff' },
          { icon = ' ', key = 'b', desc = 'Review branch against main', action = review_branch },
          { icon = ' ', key = 'f', desc = 'Find file', action = ':FzfLua files' },
          { icon = ' ', key = 's', desc = 'Restore session', action = ":lua require('persistence').load()" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = function()
        local sections = header()
        vim.list_extend(sections, {
          { section = 'keys', gap = 1, padding = 1 },
          { icon = ' ', title = 'Recent files', section = 'recent_files', cwd = true, indent = 2, padding = 1 },
        })
        return sections
      end,
    },
  },
}

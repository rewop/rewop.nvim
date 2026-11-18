-- TODO setup catppuccin colorscheme
return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    name = 'onedark',
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
        float = { transparent = true },
        custom_highlights = function(colors)
          return {
            -- Inline blame drawn as a "pill" (see current_line_blame_formatter in
            -- plugins/git.lua). catppuccin's default (fg = surface1, no bg) is
            -- barely visible on the transparent background.
            GitSignsCurrentLineBlame = { fg = colors.subtext0, bg = colors.surface0, style = { 'italic' } },
            GitSignsBlameAuthor = { fg = colors.lavender, bg = colors.surface0, style = { 'bold' } },
            -- Solid background for the <leader>gb blame popup
            GitSignsPopup = { fg = colors.text, bg = colors.mantle },
            GitSignsPopupBorder = { fg = colors.blue, bg = colors.mantle }, -- same as FloatBorder
            GitSignsPopupSha = { fg = colors.peach, bg = colors.mantle },
            GitSignsPopupAuthor = { fg = colors.lavender, bg = colors.mantle, style = { 'bold' } },
            GitSignsPopupDate = { fg = colors.overlay2, bg = colors.mantle, style = { 'italic' } },
            GitSignsPopupHunk = { fg = colors.blue, bg = colors.surface0, style = { 'bold' } },
            GitSignsPopupSubject = { fg = colors.text, style = { 'bold' } },
            GitSignsPopupType = { fg = colors.mauve, style = { 'bold' } },
            GitSignsPopupCode = { fg = colors.green, bg = colors.surface0 },
            GitSignsPopupBullet = { fg = colors.peach },
            GitSignsPopupTrailer = { fg = colors.overlay1, style = { 'italic' } },
          }
        end,
        integrations = {
          blink_cmp = true,
          dap = true,
          dap_ui = true,
          gitsigns = true,
          harpoon = true,
          indent_blankline = {
            enabled = true,
          },
          mason = true,
          mini = {
            enabled = true,
          },
          native_lsp = {
            enabled = true,
          },
          neotree = true,
          noice = true,
          notify = true,
          fzf = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
      }
      vim.cmd [[colorscheme catppuccin]]
    end,
  },
}

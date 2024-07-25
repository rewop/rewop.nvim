-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Set Indent to four chars
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
-- vim.o.shiftwrap = true
vim.o.expandtab = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Set relative numbers
vim.o.relativenumber = true

-- hihghlight current line
vim.o.cursorline = true

-- minimum number of visible line to keep before or after the cursor
vim.o.scrolloff = 10

-- set transparent background
-- TODO consider using the plugin https://github.com/xiyaowong/transparent.nvim
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none', ctermbg = 'none' })
-- vim.api.nvim_set_hl(0, "Structure", { bg = "none", ctermbg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none", ctermbg = "none" })

-- set default fodling behaviour
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.o.foldtext = ''
-- vim.o.fillchars = 'fold: '
vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 4

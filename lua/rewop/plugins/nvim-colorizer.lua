-- return {
--   'catgoose/nvim-colorizer.lua',
--   event = 'BufReadPre',
--   config = function()
--     require('colorizer').setup {
--
--       filetypes = {
--         'css',
--         'javascript',
--         'javascriptreact',
--         'typescript',
--         'typescriptreact',
--         html = { mode = 'foreground' },
--       },
--       user_default_options = {
--         -- RGB = true, -- #RGB hex codes
--         -- RRGGBB = true, -- #RRGGBB hex codes
--         -- names = true, -- "Name" codes like Blue
--         -- RRGGBBAA = true, -- #RRGGBBAA hex codes
--         -- rgb_fn = true, -- CSS rgb() and rgba() functions
--         -- hsl_fn = true, -- CSS hsl() and hsla() functions
--         css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
--         css_fn = true, -- Enable all CSS functions: rgb_fn, hsl_fn
--         tailwind = 'both', -- Enable all TailwindCSS features: rgb_fn, names, RGB
--         tailwind_opts = { -- Options for highlighting tailwind names
--           update_names = false, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
--         },
--       },
--     }
--   end,
-- }

return {
  'brenoprata10/nvim-highlight-colors',
  event = 'BufReadPre',
  config = function()
    require('nvim-highlight-colors').setup()
  end,
}

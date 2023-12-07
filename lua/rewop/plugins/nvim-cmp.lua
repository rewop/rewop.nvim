return  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        -- 'L3MON4D3/LuaSnip',
        -- 'saadparwaiz1/cmp_luasnip',
        --
        'onsails/lspkind.nvim',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        -- local luasnip = require("luasnip")

        cmp.setup({
            -- snippet = {
            --     -- REQUIRED - you must specify a snippet engine
            --     expand = function(args)
            --         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            --         luasnip.lsp_expand(args.body) -- For `luasnip` users.
            --         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            --         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            --     end,
            -- },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    menu = ({
                        buffer = "[Buf]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        path = "[Path]",
                    }),
                }),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ 
                    nehaviour = cmp.ConfirmBehavior.Replace,
                    select = true, 
                }), 
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- elseif luasnip.expand_or_locally_jumpable() then
                    --     luasnip.expand_or_jump()
                    else
                        fallback()
                    end

                end),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    -- elseif luasnip.locally_jumpable(-1) then
                    --     luasnip.jump(-1)
                    else
                        fallback()
                    end
                end),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lua' },
                { name = 'path' },
                { name = 'nvim_lsp' },
                -- { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' }, -- complete text from the current buffer
            })
        })
        -- Set configuration for specific filetype.
        cmp.setup.filetype('lua')
        -- cmp.setup.filetype('gitcommit', {
        --     sources = cmp.config.sources({
        --         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        --     }, {
        --         { name = 'buffer' },
        --     })
        -- })
        -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        -- cmp.setup.cmdline({ '/', '?' }, {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = {
        --         { name = 'buffer' }
        --     }
        -- })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        --     cmp.setup.cmdline(':', {
        --         mapping = cmp.mapping.preset.cmdline(),
        --         sources = cmp.config.sources({
        --             { name = 'path' }
        --         }, {
        --             { name = 'cmdline' }
        --         })
        --     })
    end
}

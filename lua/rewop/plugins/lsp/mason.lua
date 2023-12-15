 return {
     "williamboman/mason.nvim",
     dependencies = {
         "williamboman/mason-lspconfig.nvim",
     },
     config = function()
         local mason = require("mason")
         local mason_lspconfig = require("mason-lspconfig")

         mason.setup({
             ui = {
                 icons = {
                     package_installed = "✓",
                     package_pending = "➜",
                     package_unistalled = "✗",
                 },
             },
         })
         mason_lspconfig.setup({
             -- list of servers for mason to install
             ensure_installed = {
                 "tsserver",
                 "html",
                 "cssls",
                 "tailwindcss",
                 "svelte",
                 "lua_ls",
                 "pyright",
                 "gopls",
                 "sqlls",
                 "jsonls",
                 "yamlls",
                 "terraformls",
                 "marksman",
                 "helm_ls",
                 "dockerls",
             },
             automatic_installation = true,
         })

     end
 }

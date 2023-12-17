-- TODO setup catppuccin colorscheme
return {
    {
        -- Theme inspired by Atom
        "navarasu/onedark.nvim",
        name = "onedark",
        priority = 1000,
    },
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000, 
        config = function () 
            require("catppuccin").setup({
                transparent_background = true,
            })
            vim.cmd([[colorscheme catppuccin]])
        end
    }
}

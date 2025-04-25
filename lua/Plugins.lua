local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- multi-line operations
    {
        "terryma/vim-multiple-cursors",
    },

    -- vscode-like pictograms
    {
        "onsails/lspkind.nvim",
        event = { "vimenter" },
    },

    -- code snippet engine
    {
        "l3mon4d3/luasnip",
        version = "v2.*",
        config = function()
            require('config.snippets')
        end
    },

    -- auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
            "hrsh7th/cmp-buffer",   -- buffer auto-completion
            "hrsh7th/cmp-path",     -- path auto-completion
            "hrsh7th/cmp-cmdline",  -- cmdline auto-completion
            "saadparwaiz1/cmp_luasnip",
            "micangl/cmp-vimtex",
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },

    -- themes
    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd('colorscheme gruvbox')
        end
    },

    ---- lsp manager

    -- lsp tools
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },

    {
        'jayp0521/mason-null-ls.nvim',
        dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
    },

    {
        'nvim-lua/plenary.nvim',
    },

    -- debug tools
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio" },
        config = function()
            require("config.nvim-dap-ui")
        end
    },

    -- nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("config.treesitter")
        end
    },

    -- undotree
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set('n', 'UD', vim.cmd.UndotreeToggle)
        end,
    },

    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require('config.nvimtree')
        end,
        enabled = false,
    },

    -- web devicons
    {
        "nvim-tree/nvim-web-devicons",
    },

    -- lsp signature
    {
        "ray-x/lsp_signature.nvim",
        event = "insertenter",
    },

    -- lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('config.lualine')
        end
    },

    -- parenthesis completion
    {
        'windwp/nvim-autopairs',
        event = "insertenter",
        config = true,
    },

    -- Markdown related
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "Markdownpreviewtoggle", "Markdownpreview", "Markdownpreviewstop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        config = function()
            require('config.markdown-preview')
        end
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion", "terminal" },
    },

    {
        "Zeioth/markmap.nvim",
        build = "yarn global add markmap-cli",
        cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
        opts = {
            html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
            hide_toolbar = false,              -- (default)
            grace_period = 3600000             -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
        },
        config = function(_, opts)
            require("markmap").setup(opts)
            vim.api.nvim_set_keymap('n', '<Space>o', ':MarkmapOpen<CR>', { noremap = true, silent = true })
        end,
        ft = { "markdown" }
    },

    -- tex
    {
        "lervag/vimtex",
        lazy = false, -- Load vimtex immediately for tex files
        config = function()
            require('config.vimtex')
        end,
        ft = { "tex" }
    },

    -- fzf-lua
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('config.fzf-lua')
        end
    },

    -- gitsigns
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('config.gitsigns')
        end
    },

    -- colorizer
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require 'colorizer'.setup({
                'css',
                'javascript',
                html = { mode = 'background' },
            }, { mode = 'foreground' })
        end
    },

    -- ai engine
    {
        "joshuavial/aider.nvim",
        opts = {
            auto_manage_context = true, -- automatically manage buffer context
            default_bindings = true,    -- use default <leader>A keybindings
            debug = false,              -- enable debug logging
        },
        config = function()
            require('config.aider')
        end,
    },

})

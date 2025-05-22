-- Mason Settings
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
})

-- Mason-lspconfig Settings  (LS)
--[[
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright', 'lua_ls',
        'clangd', 'ts_ls',
        'html', 'texlab',
        'cssls', 'verible',
        'matlab_ls'
    },
})
--]]

-- Mason-null-ls Settings (Formatters)
require("mason-null-ls").setup({
    ensure_installed = { "prettier", "stylua", 'tex_fmt', },
    automatic_installation = true,
})

-- Mason-nvim-dap Settings (Debugers)
require("mason-nvim-dap").setup({
    ensure_installed = { "python", "cppdbg", "bash" },
    automatic_setup = true,
})

-- LspConfig Settings
local lspconfig = require('lspconfig')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>, CMP
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    require "lsp_signature".on_attach({
        bind = true,            -- 这是必要的，确保输入模式下生效
        hint_enable = true,     -- 启用虚拟提示
        floating_window = true, -- 使用浮动窗口显示签名
        fix_pos = false,
        hint_prefix = "🔍 ",
        hi_parameter = "LspSignatureActiveParameter", -- 高亮当前参数
        handler_opts = {
            border = "rounded"
        },
    }, bufnr)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<C-h>', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- Null Ls
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black.with({
            extra_args = { "--fast" },
        })
    }
})

-- Python Settings
lspconfig.pyright.setup({ -- Pyright
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = false,
            },
            pythonPath = '/opt/homebrew/bin/python3.12',
            extraPaths = "/opt/homebrew/lib/python3.12/site-packages/torch/include/torch",
        },
    },
})

local python_config = require('Languages.python')

python_config.python_keymaps() -- Keymaps
python_config.debuger()        -- Debuger

-- C Settings
lspconfig.clangd.setup {
    on_attach = on_attach,
    settings =
    {
        checkUpdates = true,
    },
    flags = {
        debounce_text_changes = 150,
    },
    filetypes = { "c", "cpp", "cc", "h", "cuh" },
    path = '/opt/homebrew/opt/llvm/bin/clangd'
}

local c_config = require('Languages.c')
c_config.c_keymaps()

--Lua settings
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- Prevents diagnostics on plugins
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

--Verilog Settings
lspconfig.verible.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    root_dir = function() return vim.uv.cwd() end
}

--Matlab Settings
lspconfig.matlab_ls.setup {
    on_attach = on_attach,
    cmd = { "matlab-language-server", "--stdio" },
    settings = {
        MATLAB = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            indexWorkspace = true,
            installPath = "/Applications/MATLAB_R2021b.app",
            matlabConnectionTiming = "onStart",
            telemetry = false,
        },
    },
    single_file_support = true,
}

local matlab_config = require('Languages.matlab')
matlab_config.matlab_keymaps()

-- Typescript LSP Settings
lspconfig.ts_ls.setup {
    on_attach = on_attach,
    settings = {
        javascript = {
            suggest = {
                completeFunctionCalls = true,
            }
        }
    }
}

-- Css LSP Settings
lspconfig.cssls.setup {
    on_attach = on_attach
}

-- HTML LSP Settings
lspconfig.html.setup {
    on_attach = on_attach
}

-- Tex LSP Settings
lspconfig.texlab.setup {
    on_attach = on_attach
}

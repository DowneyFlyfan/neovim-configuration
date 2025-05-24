-- Mason Settings
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local lspconfig = require("lspconfig")
local opts = { noremap = true, silent = true }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	require("lsp_signature").on_attach({
		bind = true,
		hint_enable = true,
		floating_window = true,
		fix_pos = false,
		hint_prefix = "🔍 ",
		hi_parameter = "LspSignatureActiveParameter",
		handler_opts = {
			border = "rounded",
		},
	}, bufnr)

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})
end

vim.diagnostic.config({
	signs = true,
	virtual_text = true,
	underline = true,

	float = {
		visible = true,
		source = "if_many",
		border = "rounded",
		header = true,
		prefix = "💡 ",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"pyright",
		"lua_ls",
		"clangd",
		"ts_ls",
		"html",
		"texlab",
		"cssls",
		"verible",
		"matlab_ls",
		-- "ast_grep", "black", "rustfmt", "prettier", "prettierd", "stylua", "txtfmt"
	},
	handlers = {
		function(server_name)
			lspconfig[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,

		["pyright"] = function()
			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
							autoImportCompletions = false,
						},
					},
				},
			})
		end,

		["clangd"] = function()
			lspconfig.clangd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "/usr/bin/clangd" },
				filetypes = { "c", "cpp", "cc", "h", "cuh" },
				flags = { debounce_text_changes = 150 },
			})
		end,

		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
		end,

		["verible"] = function()
			lspconfig.verible.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				root_dir = function()
					return vim.uv.cwd()
				end,
			})
		end,

		["matlab_ls"] = function()
			lspconfig.matlab_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					MATLAB = {
						indexWorkspace = true,
						installPath = "/Applications/MATLAB_R2021b.app",
						matlabConnectionTiming = "onStart",
						telemetry = false,
					},
				},
				single_file_support = true,
			})
		end,

		["ts_ls"] = function()
			lspconfig.ts_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					javascript = { suggest = { completeFunctionCalls = true } },
					typescript = { suggest = { completeFunctionCalls = true } }, -- 通常也会为ts配置
				},
			})
		end,

		-- cssls, html, texlab 会使用上面的默认 handler
		-- 如果它们也需要特殊 settings，像上面一样为它们添加专门的 handler 即可
	},
})

-- Independent Config for each language
local python_config = require("Languages.python")

python_config.python_keymaps()
python_config.debuger()

local c_config = require("Languages.c")
c_config.c_keymaps()

local matlab_config = require("Languages.matlab")
matlab_config.matlab_keymaps()

require("mason-nvim-dap").setup({
	ensure_installed = { "python", "cppdbg", "bash" },
	automatic_setup = true, -- 这个 automatic_setup 是 mason-nvim-dap 的，不是 mason-lspconfig 的
})

-- Mason Settings
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

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
			local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
			if filetype == "matlab" then
				vim.lsp.buf.format({ bufnr = args.buf })
			else
				require("conform").format({ bufnr = args.buf })
			end
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

-- Little snippets
vim.lsp.config["pyright"] = {
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
}

vim.lsp.config["luals"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		runtime = { version = "LuaJIT" },
		diagnostics = { globals = { "vim" } },
		workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
		telemetry = { enable = false },
	},
}

vim.lsp.config["clangd"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/opt/homebrew/opt/llvm/bin/clangd" },
	filetypes = { "c", "cpp", "cc", "h", "cuh", "cuda" },
	flags = { debounce_text_changes = 150 },
}

vim.lsp.config["verible"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.uv.cwd()
	end,
}

vim.lsp.config["matlab_ls"] = {
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
}

vim.lsp.config["ts_ls"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		javascript = { suggest = { completeFunctionCalls = true } },
		typescript = { suggest = { completeFunctionCalls = true } }, -- 通常也会为ts配置
	},
}

vim.lsp.config["cssls"] = {
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config["html"] = {
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config["texlab"] = {
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config["marksman"] = {
	on_attach = on_attach,
	capabilities = capabilities,
}

require("mason-nvim-dap").setup({
	ensure_installed = { "python", "cppdbg", "bash" },
	automatic_setup = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"ast_grep",
		"black",
		"rustfmt",
		"prettier",
		"prettierd",
		"stylua",
		"txtfmt",
	},

	auto_update = false,
	run_on_start = true,
	start_delay = 3000,
	debounce_hours = 5, -- at least 5 hours between attempts to install/update
	integrations = {
		["mason-lspconfig"] = true,
		["mason-nvim-dap"] = true,
	},
})

-- Independent Config for each language
require("Languages.python")
require("Languages.c")
require("Languages.matlab")

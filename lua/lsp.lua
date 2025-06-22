-- Mason Settings
capabilities = vim.lsp.protocol.make_client_capabilities() -- Remove local
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

on_attach = function(client, bufnr)
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

require("mason-nvim-dap").setup({
	ensure_installed = { "python", "cppdbg", "bash" },
	automatic_setup = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"ast_grep",
		"black",
		"prettier",
		"prettierd",
		"stylua",
		"tex-fmt",
		"rust",
		"clang-format",
		"beautysh",
	},

	auto_update = true,
	run_on_start = true,
	start_delay = 500,
	debounce_hours = 5,
	integrations = {
		["mason-lspconfig"] = true,
		["mason-nvim-dap"] = true,
	},
})

require("Languages.python")
require("Languages.c")
require("Languages.matlab")
require("Languages.lua_config") -- For luals
require("Languages.typescript") -- For ts_ls
require("Languages.css") -- For cssls
require("Languages.html") -- For html lsp
require("Languages.tex") -- For texlab
require("Languages.markdown") -- For marksman
require("Languages.verilog") -- For verible

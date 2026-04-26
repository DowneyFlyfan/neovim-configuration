local icons = {
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
}

-- diagnostic
vim.diagnostic.config({
	virtual_text = {
		prefix = "■",
		source = "if_many",
		spacing = 1,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.error,
			[vim.diagnostic.severity.WARN] = icons.warn,
			[vim.diagnostic.severity.HINT] = icons.hint,
			[vim.diagnostic.severity.INFO] = icons.info,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- Global Capabilities & On_attach
_G.Capabilities = require("cmp_nvim_lsp").default_capabilities()

_G.On_attach = function(client, bufnr)
	require("lsp_signature").on_attach({
		bind = true,
		hint_enable = true,
		floating_window = true,
		handler_opts = { border = "rounded" },
		check_708 = true,
	}, bufnr)

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- goto
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	-- vim.keymap.set("n", "gh", ":TermExec cmd='cppman <cword>'<CR>", { buffer = true })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	-- Hover Doc
	vim.keymap.set("n", "<C-h>", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts)

	-- Code Action & Rename
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

	-- Workspace Directories
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	-- Diagnostic
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, opts)
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)

	-- formatter
	local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = format_group })
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		group = format_group,
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			if ft == "matlab" then
				vim.lsp.buf.format({ bufnr = args.buf })
			else
				require("conform").format({ bufnr = args.buf })
			end
		end,
	})
end

-- Mason Tools
require("mason-nvim-dap").setup({
	ensure_installed = { "python", "cppdbg", "bash" },
	automatic_installation = true,
	handlers = {},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"black",
		"prettierd",
		"prettier",
		"tex-fmt",
		"verible",
		"clang-format",
		"beautysh",
		"rustfmt",
		"asmfmt",
		"ast_grep",
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

-- Languages Config Load
local languages = {
	"python",
	"c",
	"matlab",
	"lua_config",
	"typescript",
	"css",
	"html",
	"tex",
	"markdown",
	"verilog",
	"rust",
	"asm",
	"bash",
	"tcl",
}

for _, lang in ipairs(languages) do
	local ok, _ = pcall(require, "Languages." .. lang)
	if not ok then
		vim.notify("Language config not found: " .. lang, vim.log.levels.WARN)
	end
end

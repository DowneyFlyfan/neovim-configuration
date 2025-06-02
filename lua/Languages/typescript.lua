-- LSP config for ts_ls (typically tsserver)
vim.lsp.config["ts_ls"] = { -- Or "tsserver" if that's what mason-lspconfig installs/uses
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		javascript = { suggest = { completeFunctionCalls = true } },
		typescript = { suggest = { completeFunctionCalls = true } },
	},
}

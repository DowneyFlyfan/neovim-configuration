-- LSP config for ts_ls (typically tsserver)
vim.lsp.config("tsserver", { -- Or "tsserver" if that's what mason-lspconfig installs/uses
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		javascript = { suggest = { completeFunctionCalls = true } },
		typescript = { suggest = { completeFunctionCalls = true } },
	},
})

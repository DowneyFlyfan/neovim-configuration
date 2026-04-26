-- LSP config for html language server (e.g., vscode-html-languageserver-bin)
vim.lsp.config("html", {
	on_attach = On_attach,
	capabilities = Capabilities,
})

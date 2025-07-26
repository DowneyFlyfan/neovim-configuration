-- LSP config for svls
vim.lsp.config("svlangserver", {
	on_attach = On_attach,
	capabilities = Capabilities,
	filetypes = { "verilog", "systemverilog" },
})

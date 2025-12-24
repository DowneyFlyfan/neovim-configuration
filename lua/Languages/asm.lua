vim.lsp.config("asm_lsp", {
	on_attach = On_attach,
	capabilities = Capabilities,
	filetypes = { "asm", "nasm", "s" },
})

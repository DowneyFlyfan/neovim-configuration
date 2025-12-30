vim.lsp.config("asm_lsp", {
	on_attach = On_attach,
	capabilities = Capabilities,
	root_patterns = { ".asm-lsp.toml", ".git" },
	filetypes = { "asm", "nasm", "s" },
})

vim.lsp.config("svlangserver", {
	on_attach = On_attach,
	capabilities = Capabilities,
	filetypes = { "verilog", "systemverilog" },
	settings = {
		systemverilog = {
			forceFastIndexing = false,
		},
	},
})

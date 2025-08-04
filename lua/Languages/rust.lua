-- LSP config for rust
vim.lsp.config("rust_analyzer", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		["rust-analyzer"] = {
			showSyntaxTree = true,
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

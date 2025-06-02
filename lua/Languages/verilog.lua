-- LSP config for verible
vim.lsp.config["verible"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.uv.cwd() -- Or your preferred root detection logic
	end,
}

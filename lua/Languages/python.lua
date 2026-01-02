-- LSP config for pyright
vim.lsp.config("pyright", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = true,
			},
		},
	},
})

-- Shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "<C-e>", ":w<CR>:!python3 %<CR>", { noremap = true, silent = true })
	end,
})

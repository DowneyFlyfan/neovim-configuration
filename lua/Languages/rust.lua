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

--Shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.keymap.set("n", "<C-e>", ":w<CR>:!cargo run<CR>", { noremap = true, silent = true })
	end,
})

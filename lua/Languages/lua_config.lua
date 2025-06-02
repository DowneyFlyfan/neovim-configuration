-- LSP config for luals
vim.lsp.config["luals"] = {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-language-server" }, -- Ensure lua-language-server is installed
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		runtime = { version = "LuaJIT" },
		diagnostics = { globals = { "vim" } },
		workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
		telemetry = { enable = false },
	},
}

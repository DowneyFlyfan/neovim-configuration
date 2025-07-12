-- LSP config for luals
vim.lsp.config("lua_ls", {
	on_attach = On_attach,
	capabilities = Capabilities,
	cmd = { "lua-language-server" }, -- Ensure lua-language-server is installed
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		runtime = { version = "LuaJIT" },
		diagnostics = { globals = { "vim" } },
		workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
		telemetry = { enable = false },
	},
})

-- LSP config for verible
local lspconfig = require("lspconfig")
vim.lsp.config["svls"] = {
	on_attach = on_attach,
	capabilities = capabilities,
}

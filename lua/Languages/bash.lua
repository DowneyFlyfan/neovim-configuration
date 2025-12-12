vim.lsp.config("bashls", {
	on_attach = On_attach,
	capabilities = Capabilities,
	globPattern = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc|zsh_*)",
})

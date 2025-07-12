-- LSP config for svls
vim.lsp.config("svls", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {},
})

-- For vim-matchup:
-- After a plugin update, the treesitter engine for matchup seems to conflict
-- with the verilog parser, causing matching for begin/end to fail.
-- The following command disables the treesitter engine specifically for
-- verilog and systemverilog files, forcing matchup to fall back to the
-- legacy (and working) b:match_words matching method.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"verilog", "systemverilog"},
  callback = function()
    vim.b.matchup_treesitter_enabled = 0
  end,
  desc = "Disable matchup treesitter for verilog to fix matching."
})

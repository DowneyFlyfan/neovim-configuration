require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		tex = { "tex_fmt" },
		verilog = { "verible" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_set_keymap("n", "<space>f", ":lua require('conform').format()<CR>", { noremap = true, silent = true })

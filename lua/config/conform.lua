require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters = {
		verible = {
			command = "verible-verilog-format",
			args = { "-" },
			stdin = true,
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		asm = { "asmfmt" },
		nasm = { "asmfmt" },
		s = { "asmfmt" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		tex = { "tex_fmt" },
		verilog = { "verible" },
		systemverilog = { "verible" },

		-- sh series
		sh = { "beautysh" },
		zsh = { "beautysh" },
		bash = { "beautysh" },
		ksh = { "beautysh" },
		csh = { "beautysh" },

		c = { "clang-format" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_set_keymap("n", "<space>f", ":lua require('conform').format()<CR>", { noremap = true, silent = true })

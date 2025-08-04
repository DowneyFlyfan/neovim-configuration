require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"python",
		"javascript",
		"cuda",
		"matlab",
		"verilog",
		"bash",
		"json",
		"rust",
		"csv",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end

			return false
		end,
		additional_vim_regex_highlighting = { "latex" },
	},

	indent = { enable = true },
	matchup = {
		enable = true,
		include_match_words = true,
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = 1000,
		colors = {
			"#E06C75", -- red
			"#98C379", -- green
			"#E5C07B", -- yellow
			"#61AFEF", -- blue
			"#C678DD", -- purple
			"#56B6C2", -- cyan
		},
	},
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 0

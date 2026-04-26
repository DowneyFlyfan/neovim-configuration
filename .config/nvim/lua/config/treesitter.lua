local ensure_parsers = {
	"python",
	"c",
	"cpp",
	"cuda",
	"rust",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"bibtex",
	"matlab",
	"systemverilog",
	"bash",
	"html",
	"javascript",
	"css",
	"json",
	"yaml",
	"toml",
	"markdown",
	"markdown_inline",
	"comment",
	"tcl",
	"asm",
	"latex",
}

local ts = require("nvim-treesitter")

-- install() is a no-op for already-installed parsers
ts.install(ensure_parsers)

local max_filesize = 150 * 1024

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		local filepath = vim.api.nvim_buf_get_name(buf)
		local ok, stats = pcall(vim.uv.fs_stat, filepath)

		if ok and stats and stats.size > max_filesize then
			return
		end

		pcall(vim.treesitter.start, buf)
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

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
}

local ts = require("nvim-treesitter")

-- install() is a no-op for already-installed parsers
ts.install(ensure_parsers)

-- Enable treesitter highlighting, folding, and indentation via FileType autocmd
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)

		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

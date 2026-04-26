vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Viewer options
-- Use skim on macOS, fall back to zathura otherwise
if vim.fn.has("macunix") then
	vim.g.vimtex_view_method = "skim"
	vim.g.vimtex_view_skim_options = "--reuse --forward-search @tex @line @pdf"
	vim.g.vimtex_view_skim_sync = 1
	vim.g.vimtex_view_general_inverse_search = { "vimtex#view#skim#inverse_search()" }
else
	vim.g.vimtex_view_method = "zathura"
end

-- Use xelatex compiler
vim.g.vimtex_compiler_latexmk = {
	executable = "latexmk",
	options = { "-pdf", "-xelatex", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
}
vim.g.vimtex_compiler_latexmk_continuous = 1

vim.g.maplocalleader = ","

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	command = "setl updatetime=1000",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.opt_local.textwidth = 100 -- 行宽限制
		vim.opt_local.wrap = true -- 启用软换行
		vim.opt_local.linebreak = true -- 按单词边界换行
		vim.opt_local.breakindent = true -- 保持缩进
	end,
})

-- Add keybindings for VimtexClean and VimtexCompile
vim.api.nvim_set_keymap(
	"n",
	"<Space>c",
	":VimtexClean<CR>",
	{ noremap = true, silent = true, desc = "Clean Vimtex files" }
)
vim.api.nvim_set_keymap(
	"n",
	"<Space>p",
	":VimtexCompile<CR>",
	{ noremap = true, silent = true, desc = "Compile Vimtex file" }
)

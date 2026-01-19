-- LSP config for pyright
vim.lsp.config("pyright", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = true,
			},
		},
	},
})

-- Shortcuts
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "<C-e>", ":w<CR>:!python3 %<CR>", { noremap = true, silent = true })
	end,
})

-- Pydoc Checker
local function open_python_doc()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.ceil(vim.o.columns * 0.8)
	local height = math.ceil(vim.o.lines * 0.8)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = math.ceil((vim.o.columns - width) / 2),
		row = math.ceil((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	vim.cmd("terminal pydoc " .. word)
	vim.cmd("startinsert")

	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "gh", open_python_doc, { noremap = true, silent = true })
	end,
})

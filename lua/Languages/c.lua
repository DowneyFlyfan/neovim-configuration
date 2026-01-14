local M = {}

function M.run_file()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		print("Error: Buffer has no name")
		return
	end
	local command = string.format("runc %s", vim.fn.shellescape(file))
	local result = vim.fn.system(command)
	print("==== Command ==== " .. command)
	print("==== Result ==== " .. result)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "ch", "cc", "cpp", "cu", "cuh" },
	callback = function()
		vim.api.nvim_set_keymap(
			"n",
			"<C-e>",
			':w<CR>:lua require("Languages.c").run_file()<CR>',
			{ noremap = true, silent = true }
		)
	end,
})

local function open_cppman_float()
	local word = vim.fn.expand("<cword>")
	local buf = vim.api.nvim_create_buf(false, true)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})

	local job_id = vim.fn.termopen("cppman " .. word)

	vim.api.nvim_set_option_value("winhl", "Normal:NormalFloat", { scope = "local", win = win })

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.fn.jobstop(job_id)
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, noremap = true, silent = true })

	vim.cmd("stopinsert")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.keymap.set("n", "gh", open_cppman_float, { buffer = true })
	end,
})

-- LSP config for clangd
vim.lsp.config("clangd", {
	on_attach = On_attach,
	capabilities = Capabilities,
	cmd = (vim.fn.has("mac") == 1) and { "/opt/homebrew/opt/llvm/bin/clangd", "--background-index" }
		or { "/usr/bin/clangd-20", "--background-index" },
	flags = { debounce_text_changes = 150 },
})

return M

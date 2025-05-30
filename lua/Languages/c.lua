local M = {}

function M.run_file()
	local file = vim.fn.expand("%:p")
	local command = string.format("runc %s", file)
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

return M

local M = {}

function M.run_file()
	local file = vim.fn.expand("%:p")
	local command =
		string.format("/Applications/MATLAB_R2021b.app/bin/matlab -nodesktop -nosplash -r \"run('%s'); quit;\"", file)
	local result = vim.fn.system(command)
	print("==== Command ==== " .. command)
	print("==== Result ==== " .. result)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "matlab",
	callback = function()
		vim.api.nvim_set_keymap(
			"n",
			"<C-e>",
			':w<CR>:lua require("Languages.matlab").run_file()<CR>',
			{ noremap = true, silent = true }
		)
	end,
})

-- LSP config for matlab_ls
vim.lsp.config("matlab_ls", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		MATLAB = {
			indexWorkspace = true,
			installPath = "/Applications/MATLAB_R2021b.app", -- This path is user-specific
			matlabConnectionTiming = "onStart",
			telemetry = false,
		},
	},
	single_file_support = true,
})

return M

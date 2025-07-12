vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "<C-e>", ":w<CR>:!python3 %<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<M-c>", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<M-i>", ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<M-o>", ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<M-b>", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
	end,
})

-- LSP config for pyright
vim.lsp.config("pyright", {
	on_attach = On_attach,
	capabilities = Capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = false, -- Ensure this is false if you don't want auto-imports
			},
		},
	},
})

local dap = require("dap")

dap.adapters.python = {
	type = "executable",
	command = "python",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = vim.fn.expand("%:p:h"),
	},
}

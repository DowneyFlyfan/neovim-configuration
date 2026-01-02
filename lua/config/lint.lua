local lint = require("lint")

lint.linters.nasm = {
	cmd = "nasm",
	stdin = false,
	append_fname = true,
	args = {
		"-f",
		"elf64",
		"-o",
		"/dev/null",
		"-X",
		"gnu",
	},
	stream = "stderr",
	ignore_exitcode = true,
	parser = require("lint.parser").from_pattern("[^:]+:(%d+):%s+(%w+):%s+(.*)", { "lnum", "severity", "message" }, {
		["error"] = vim.diagnostic.severity.ERROR,
		["warning"] = vim.diagnostic.severity.WARN,
	}),
}

lint.linters_by_ft = {
	nasm = { "nasm" },
	markdown = { "vale" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

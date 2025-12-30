local lint = require("lint")

lint.linters.nasm = {
	cmd = "nasm",
	stdin = false,
	append_fname = true,
	args = {
		"-f",
		"elf64", -- 或者是 'macho64' (Mac)
		"-o",
		"/dev/null", -- 不生成实际目标文件
		"-X",
		"gnu", -- 使用 GNU 风格的错误报告格式，方便解析
	},
	stream = "stderr",
	ignore_exitcode = true,
	parser = require("lint.parser").from_pattern("[^:]+:(%d+):%s+(%w+):%s+(.*)", { "lnum", "severity", "message" }, {
		["error"] = vim.diagnostic.severity.ERROR,
		["warning"] = vim.diagnostic.severity.WARN,
	}),
}

-- 绑定到 nasm 文件类型
lint.linters_by_ft = {
	nasm = { "nasm" },
	markdown = { "vale" },
}

-- 记得添加之前提到的事件触发逻辑
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.lsp.config("asm_lsp", {
	on_attach = function(client, bufnr)
		client.server_capabilities.semanticTokensProvider = nil
		if _G.On_attach then
			_G.On_attach(client, bufnr)
		end
	end,
	capabilities = Capabilities,
	root_patterns = { ".asm-lsp.toml", ".git" },
	filetypes = { "asm", "nasm", "s" },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.nasm",
	command = "set filetype=asm",
})

local function nasm_format()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local new_lines = {}
	local indent_level = 0
	local indent_str = "    " -- 4个空格

	for _, line in ipairs(lines) do
		local trimmed = line:match("^%s*(.-)%s*$") or ""

		if trimmed == "" then
			table.insert(new_lines, "")
			goto continue
		end

		-- 1. 识别 Token 类型
		local is_macro_start = trimmed:match("^%%macro") or trimmed:match("^%%rep")
		local is_macro_end = trimmed:match("^%%endmacro") or trimmed:match("^%%endrep")
		-- 只有这些伪指令才强制顶格，标号(Label)不再包含在这里
		local is_directive = trimmed:match("^%%define") or trimmed:match("^default") or trimmed:match("^SECTION")

		-- 2. 调整缩进层级
		if is_macro_end then
			indent_level = indent_level - 1
		end
		if indent_level < 0 then
			indent_level = 0
		end

		local current_indent = string.rep(indent_str, indent_level)

		-- 3. 生成新行
		if is_directive then
			-- 只有 Section/%define 强制顶格
			table.insert(new_lines, trimmed)
		elseif is_macro_start then
			-- 块开始：打印当前行 -> 缩进+1
			table.insert(new_lines, current_indent .. trimmed)
			indent_level = indent_level + 1
		else
			-- 【修改点】：标号(Label)和普通指令一样，都遵循当前缩进
			table.insert(new_lines, current_indent .. trimmed)
		end

		::continue::
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

vim.api.nvim_create_user_command("NasmFmt", nasm_format, {})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.nasm", "*.asm" },
	callback = nasm_format,
})

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
	local indent_str = "    "

	for _, line in ipairs(lines) do
		local trimmed = line:match("^%s*(.-)%s*$") or ""

		if trimmed == "" then
			table.insert(new_lines, "")
			goto continue
		end

		local is_macro_start = trimmed:match("^%%macro") or trimmed:match("^%%rep") or trimmed:match("^%%if")
		local is_macro_end = trimmed:match("^%%endmacro") or trimmed:match("^%%endrep") or trimmed:match("^%%endif")
		local is_macro_mid = trimmed:match("^%%else") or trimmed:match("^%%elif")
		local is_directive = trimmed:match("^%%define") or trimmed:match("^default") or trimmed:match("^SECTION")

		if is_macro_end or is_macro_mid then
			indent_level = indent_level - 1
		end

		if indent_level < 0 then
			indent_level = 0
		end

		local current_indent = string.rep(indent_str, indent_level)

		if is_directive then
			table.insert(new_lines, trimmed)
		elseif is_macro_start or is_macro_mid then
			table.insert(new_lines, current_indent .. trimmed)
			indent_level = indent_level + 1
		else
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

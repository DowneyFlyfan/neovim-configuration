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
	local comment_align_col = 40

	for _, line in ipairs(lines) do
		local trimmed = line:match("^%s*(.-)%s*$") or ""

		if trimmed == "" then
			table.insert(new_lines, "")
			goto continue
		end

		local content, comment = trimmed:match("([^;]*)(;.*)")
		if not content then
			content = trimmed
			comment = ""
		end

		content = content:match("(.-)%s*$") or ""

		local is_macro_start = content:match("^%%macro")
			or content:match("^%%rep")
			or content:match("^%%if")
			or content:match("^%%ifndef")
		local is_macro_end = content:match("^%%endmacro") or content:match("^%%endrep") or content:match("^%%endif")
		local is_macro_mid = content:match("^%%else") or content:match("^%%elif")
		-- 移除 %define，使其能够缩进
		local is_global_directive = content:match("^default") or content:match("^SECTION")

		if is_macro_end or is_macro_mid then
			indent_level = indent_level - 1
		end
		if indent_level < 0 then
			indent_level = 0
		end

		local current_indent = string.rep(indent_str, indent_level)
		local formatted_line = ""

		if is_global_directive then
			formatted_line = content
		else
			formatted_line = current_indent .. content
		end

		if comment ~= "" then
			if content == "" and not is_global_directive then
				formatted_line = current_indent .. comment
			else
				local current_len = #formatted_line
				local padding = comment_align_col - current_len
				if padding < 1 then
					padding = 1
				end
				formatted_line = formatted_line .. string.rep(" ", padding) .. comment
			end
		end

		table.insert(new_lines, formatted_line)

		if is_macro_start or is_macro_mid then
			indent_level = indent_level + 1
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

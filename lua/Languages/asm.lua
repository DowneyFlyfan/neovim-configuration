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

local x86_doc_cache = {}

local function html_entities(s)
	return s
		:gsub("&amp;", "&")
		:gsub("&lt;", "<")
		:gsub("&gt;", ">")
		:gsub("&nbsp;", " ")
		:gsub("&mdash;", "—")
		:gsub("&ndash;", "–")
		:gsub("&quot;", '"')
		:gsub("&rsquo;", "'")
		:gsub("&lsquo;", "'")
		:gsub("&#(%d+);", function(n)
			return string.char(tonumber(n))
		end)
end

local function parse_html_table(tbl_html)
	local rows = {}
	for tr in tbl_html:gmatch("<tr[^>]*>(.-)</tr>") do
		local cells = {}
		for cell in tr:gmatch("<t[hd][^>]*>(.-)</t[hd]>") do
			cell = html_entities(cell:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
			table.insert(cells, cell)
		end
		if #cells > 0 then
			table.insert(rows, cells)
		end
	end
	if #rows == 0 then
		return {}
	end

	local ncols = 0
	for _, row in ipairs(rows) do
		ncols = math.max(ncols, #row)
	end
	local widths = {}
	for i = 1, ncols do
		widths[i] = 0
	end
	for _, row in ipairs(rows) do
		for i, cell in ipairs(row) do
			widths[i] = math.max(widths[i], #cell)
		end
	end

	local lines = {}
	for ri, row in ipairs(rows) do
		local parts = {}
		for i = 1, ncols do
			local text = row[i] or ""
			table.insert(parts, text .. string.rep(" ", widths[i] - #text))
		end
		table.insert(lines, "| " .. table.concat(parts, " | ") .. " |")
		if ri == 1 then
			local sep = {}
			for i = 1, ncols do
				table.insert(sep, string.rep("-", widths[i]))
			end
			table.insert(lines, "| " .. table.concat(sep, " | ") .. " |")
		end
	end
	return lines
end

local function html_to_markdown(raw_html)
	local s = raw_html:gsub("\n", " ")
	s = s:gsub("<head>.-</head>", "")
	s = s:gsub("<script[^>]*>.-</script>", "")
	s = s:gsub("<style[^>]*>.-</style>", "")
	s = s:gsub("<nav[^>]*>.-</nav>", "")
	s = s:gsub("<footer[^>]*>.-</footer>", "")

	s = s:gsub("<table[^>]*>(.-)</table>", function(tbl)
		local tbl_lines = parse_html_table(tbl)
		return "\n" .. table.concat(tbl_lines, "\n") .. "\n"
	end)

	s = s:gsub("<h1[^>]*>(.-)</h1>", function(t)
		t = html_entities(t:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$")
		return "\n# " .. t .. "\n"
	end)
	s = s:gsub("<h2[^>]*>(.-)</h2>", function(t)
		t = html_entities(t:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$")
		return "\n## " .. t .. "\n"
	end)
	s = s:gsub("<h3[^>]*>(.-)</h3>", function(t)
		t = html_entities(t:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$")
		return "\n### " .. t .. "\n"
	end)

	s = s:gsub("<p[^>]*>", "\n\n")
	s = s:gsub("</p>", "")
	s = s:gsub("<br[^>]*/?>", "\n")
	s = s:gsub("<li[^>]*>", "\n- ")
	s = s:gsub("<[^>]+>", "")
	s = html_entities(s)
	s = s:gsub("\n\n\n+", "\n\n")

	local lines = vim.split(s, "\n")
	for i, line in ipairs(lines) do
		lines[i] = line:match("^%s*(.-)%s*$") or ""
	end
	while #lines > 0 and lines[1] == "" do
		table.remove(lines, 1)
	end
	while #lines > 0 and lines[#lines] == "" do
		table.remove(lines)
	end
	return lines
end

local function show_x86_doc(word)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " x86: " .. word:upper() .. " ",
		title_pos = "center",
	})

	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "markdown"
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true
	vim.wo[win].conceallevel = 2
	vim.wo[win].cursorline = true
	vim.wo[win].foldenable = false

	if x86_doc_cache[word] then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, x86_doc_cache[word])
	else
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Loading..." })
		vim.system(
			{ "curl", "-s", "-L", "https://www.felixcloutier.com/x86/" .. word },
			{ text = true },
			vim.schedule_wrap(function(result)
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				if result.code ~= 0 or not result.stdout or result.stdout == "" then
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No documentation found for: " .. word })
					return
				end
				local lines = html_to_markdown(result.stdout)
				x86_doc_cache[word] = lines
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			end)
		)
	end

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, desc = "Close documentation window" })
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "s" },
	callback = function()
		vim.keymap.set("n", "gh", function()
			show_x86_doc(vim.fn.expand("<cword>"):lower())
		end, { desc = "Open x86 doc in floating window", buffer = 0 })
	end,
})

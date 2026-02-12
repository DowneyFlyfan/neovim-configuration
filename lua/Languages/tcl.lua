vim.lsp.config("tclsp", {
	on_attach = On_attach,
	capabilities = Capabilities,
})

local dc_man_dir = vim.fn.expand("~/.local/share/dc_shell_man")
local dc_doc_cache = {}

-- Man page (dc_shell) parser

local BS = string.char(8) -- backspace character (0x08)

local function strip_man_formatting(raw)
	-- Remove bold: X<BS>X -> X
	local s = raw:gsub("(.)" .. BS .. "%1", "%1")
	-- Remove underline: _<BS>X -> X
	s = s:gsub("_" .. BS .. "(.)", "%1")
	-- Remove any remaining backspace sequences
	s = s:gsub("." .. BS, "")
	return s
end

local function parse_man_page(filepath)
	local f = io.open(filepath, "rb")
	if not f then
		return nil
	end
	local raw = f:read("*a")
	f:close()

	local text = strip_man_formatting(raw)
	local raw_lines = vim.split(text, "\n")

	-- Skip the first header line ("2.  Synopsys Commands ... Command Reference")
	local lines = {}
	local started = false
	for i, line in ipairs(raw_lines) do
		if not started then
			if i > 2 then
				started = true
			end
		end
		if started then
			local header = line:match("^(%u[%u%s]+)%s*$")
			if header then
				table.insert(lines, "# " .. header)
			else
				local subheader = line:match("^%s+((%u[%a]+ %u[%a]+[%a%s]*))%s*$")
				if subheader then
					table.insert(lines, "## " .. subheader)
				else
					table.insert(lines, line)
				end
			end
		end
	end

	while #lines > 0 and lines[#lines]:match("^%s*$") do
		table.remove(lines)
	end
	return lines
end

-- HTML (Innovus) parser

local function html_entities(s)
	return s
		:gsub("&amp;", "&")
		:gsub("&lt;", "<")
		:gsub("&gt;", ">")
		:gsub("&nbsp;", " ")
		:gsub("&#160;", " ")
		:gsub("&mdash;", "—")
		:gsub("&ndash;", "–")
		:gsub("&quot;", '"')
		:gsub("&rsquo;", "'")
		:gsub("&lsquo;", "'")
		:gsub("&apos;", "'")
		:gsub("&#39;", "'")
		:gsub("&#(%d+);", function(n)
			local code = tonumber(n)
			if code and code < 128 then
				return string.char(code)
			end
			return ""
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

	-- Render as definition list: first cell bold, rest as indented description
	local lines = {}
	for _, row in ipairs(rows) do
		local name = row[1] or ""
		if name ~= "" then
			table.insert(lines, "**" .. name .. "**")
		end
		for i = 2, #row do
			local desc = row[i] or ""
			if desc ~= "" then
				table.insert(lines, "    " .. desc)
			end
		end
		table.insert(lines, "")
	end
	return lines
end

local function html_to_markdown(raw_html)
	local s = raw_html:gsub("\n", " ")
	s = s:gsub("<head>.-</head>", "")
	s = s:gsub("<script[^>]*>.-</script>", "")
	s = s:gsub("<style[^>]*>.-</style>", "")
	s = s:gsub("<nav[^>]*>.-</nav>", "")
	s = s:gsub("<header[^>]*>.-</header>", "")
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
	s = s:gsub("<h4[^>]*>(.-)</h4>", function(t)
		t = html_entities(t:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$")
		return "\n#### " .. t .. "\n"
	end)

	s = s:gsub("<p[^>]*>", "\n\n")
	s = s:gsub("</p>", "")
	s = s:gsub("<br[^>]*/?>", "\n")
	s = s:gsub("<li[^>]*>", "\n- ")
	s = s:gsub("<code[^>]*>(.-)</code>", "`%1`")
	s = s:gsub("<strong[^>]*>(.-)</strong>", "**%1**")
	s = s:gsub("<em[^>]*>(.-)</em>", "*%1*")
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

local function parse_html_page(filepath)
	local f = io.open(filepath, "r")
	if not f then
		return nil
	end
	local raw = f:read("*a")
	f:close()
	return html_to_markdown(raw)
end

-- Unified lookup: Innovus HTML first (more likely for TCL), then dc_shell man pages

local function find_doc(word)
	-- 1. Innovus TCR (HTML)
	local html_path = dc_man_dir .. "/innovusTCR/" .. word .. ".html"
	local f = io.open(html_path, "r")
	if f then
		f:close()
		return html_path, "html"
	end

	-- 2. dc_shell man pages
	local sections = {
		{ dir = "cat2", ext = ".2" },
		{ dir = "cat3", ext = ".3" },
		{ dir = "cat1", ext = ".1" },
		{ dir = "cat4", ext = ".4" },
		{ dir = "catn", ext = "" },
	}
	for _, sec in ipairs(sections) do
		local path = dc_man_dir .. "/" .. sec.dir .. "/" .. word .. sec.ext
		f = io.open(path, "r")
		if f then
			f:close()
			return path, "man"
		end
	end

	return nil, nil
end

local function show_dc_doc(word)
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
		title = " " .. word .. " ",
		title_pos = "center",
	})

	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "markdown"
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true
	vim.wo[win].conceallevel = 2
	vim.wo[win].cursorline = true
	vim.wo[win].foldenable = false

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, desc = "Close documentation window" })

	if dc_doc_cache[word] then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, dc_doc_cache[word])
		return
	end

	local path, fmt = find_doc(word)
	if not path then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No documentation found for: " .. word })
		return
	end

	local lines
	if fmt == "html" then
		lines = parse_html_page(path)
	else
		lines = parse_man_page(path)
	end

	if not lines then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Failed to read: " .. path })
		return
	end

	dc_doc_cache[word] = lines
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tcl" },
	callback = function()
		vim.keymap.set("n", "gh", function()
			show_dc_doc(vim.fn.expand("<cword>"))
		end, { desc = "Open EDA doc in floating window", buffer = 0 })
	end,
})

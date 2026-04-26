vim.lsp.config("tclsp", {
	on_attach = On_attach,
	capabilities = Capabilities,
})

-- Load DC synthesis cmp source (lazy, only for tcl filetype)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tcl",
	once = true,
	callback = function()
		require("config.tcl-cmp-source")
	end,
})

local tcl_man_dir = vim.fn.expand("~/.local/share/tcl_man")
-- Priority order: first match wins
local tools = { "innovusTCR", "genus_comref", "joules_cmd_ref", "integrityTCR" }

local doc_cache = {} -- rendered lines per word
local file_index -- word -> absolute html path (lazy built)

-- Build word -> path index by scanning each tool dir once
local function build_index()
	local idx = {}
	local uv = vim.uv or vim.loop
	for _, tool in ipairs(tools) do
		local dir = tcl_man_dir .. "/" .. tool
		local handle = uv.fs_scandir(dir)
		if handle then
			while true do
				local name, t = uv.fs_scandir_next(handle)
				if not name then
					break
				end
				if t == "file" and name:sub(-5) == ".html" then
					local word = name:sub(1, -6)
					-- Earlier tool wins (don't overwrite)
					if not idx[word] then
						idx[word] = dir .. "/" .. name
					end
				end
			end
		end
	end
	return idx
end

-- HTML parser

local entity_map = {
	["&amp;"] = "&",
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&nbsp;"] = " ",
	["&#160;"] = " ",
	["&mdash;"] = "—",
	["&ndash;"] = "–",
	["&quot;"] = '"',
	["&rsquo;"] = "'",
	["&lsquo;"] = "'",
	["&apos;"] = "'",
	["&#39;"] = "'",
}

local function html_entities(s)
	s = s:gsub("&%w+;", entity_map):gsub("&#%d+;", entity_map)
	-- Numeric entities not in map: convert ASCII range, drop rest
	s = s:gsub("&#(%d+);", function(n)
		local code = tonumber(n)
		if code and code < 128 then
			return string.char(code)
		end
		return ""
	end)
	return s
end

local function strip_tags(t)
	return (html_entities(t:gsub("<[^>]+>", "")):gsub("%s+", " "):match("^%s*(.-)%s*$") or "")
end

local function parse_html_table(tbl_html)
	local lines = {}
	for tr in tbl_html:gmatch("<tr[^>]*>(.-)</tr>") do
		local cells = {}
		for cell in tr:gmatch("<t[hd][^>]*>(.-)</t[hd]>") do
			cells[#cells + 1] = strip_tags(cell)
		end
		if #cells > 0 then
			local name = cells[1]
			if name ~= "" then
				lines[#lines + 1] = "**" .. name .. "**"
			end
			for i = 2, #cells do
				if cells[i] ~= "" then
					lines[#lines + 1] = "    " .. cells[i]
				end
			end
			lines[#lines + 1] = ""
		end
	end
	return lines
end

local function html_to_markdown(raw_html)
	local s = raw_html:gsub("\n", " ")
	-- Strip non-content blocks
	s = s:gsub("<head>.-</head>", "")
		:gsub("<script[^>]*>.-</script>", "")
		:gsub("<style[^>]*>.-</style>", "")
		:gsub("<nav[^>]*>.-</nav>", "")
		:gsub("<header[^>]*>.-</header>", "")
		:gsub("<footer[^>]*>.-</footer>", "")

	s = s:gsub("<table[^>]*>(.-)</table>", function(tbl)
		return "\n" .. table.concat(parse_html_table(tbl), "\n") .. "\n"
	end)

	-- Headings
	for level = 1, 4 do
		local prefix = "\n" .. string.rep("#", level) .. " "
		s = s:gsub("<h" .. level .. "[^>]*>(.-)</h" .. level .. ">", function(t)
			return prefix .. strip_tags(t) .. "\n"
		end)
	end

	s = s:gsub("<p[^>]*>", "\n\n")
		:gsub("</p>", "")
		:gsub("<br[^>]*/?>", "\n")
		:gsub("<li[^>]*>", "\n- ")
		:gsub("<code[^>]*>(.-)</code>", "`%1`")
		:gsub("<strong[^>]*>(.-)</strong>", "**%1**")
		:gsub("<em[^>]*>(.-)</em>", "*%1*")
		:gsub("<[^>]+>", "")
	s = html_entities(s):gsub("\n\n\n+", "\n\n")

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

local function show_doc(word)
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

	local cached = doc_cache[word]
	if cached then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, cached)
		return
	end

	if not file_index then
		file_index = build_index()
	end

	local path = file_index[word]
	if not path then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No documentation found for: " .. word })
		return
	end

	local lines = parse_html_page(path)
	if not lines then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Failed to read: " .. path })
		return
	end

	doc_cache[word] = lines
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tcl" },
	callback = function()
		vim.keymap.set("n", "gh", function()
			show_doc(vim.fn.expand("<cword>"))
		end, { desc = "Open EDA doc in floating window", buffer = 0 })
	end,
})

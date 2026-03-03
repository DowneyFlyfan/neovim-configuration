vim.lsp.config("svlangserver", {
	on_attach = On_attach,
	capabilities = Capabilities,
	filetypes = { "verilog", "systemverilog" },
	settings = {
		systemverilog = {
			forceFastIndexing = false,
		},
	},
})

local verilog_doc_dir = vim.fn.expand("~/.local/share/verilog_doc")
local verilog_doc_cache = {}
local verilog_file_index = nil

-- Aliases: map related keywords to the same doc file
local verilog_aliases = {
	endmodule = "module",
	endfunction = "function",
	endtask = "task",
	endgenerate = "generate",
	endinterface = "interface",
	endpackage = "package",
	endclass = "class",
	["else"] = "if",
	["end"] = "begin",
	join = "fork",
	join_any = "fork",
	join_none = "fork",
	negedge = "posedge",
	casex = "case",
	casez = "case",
	endcase = "case",
	["ifndef"] = "ifdef",
	["elsif"] = "ifdef",
	["endif"] = "ifdef",
	["undef"] = "define",
	["$write"] = "display",
	["$strobe"] = "display",
	["$display"] = "display",
	["$monitor"] = "monitor",
	["$finish"] = "finish",
	["$stop"] = "finish",
	["$readmemh"] = "readmemh",
	["$readmemb"] = "readmemh",
	["$clog2"] = "clog2",
	["$random"] = "random",
	["$urandom"] = "random",
	["$urandom_range"] = "random",
	["$fopen"] = "fopen",
	["$fclose"] = "fopen",
	["$fwrite"] = "fopen",
	["$fdisplay"] = "fopen",
	["$fscanf"] = "fopen",
	["$fgets"] = "fopen",
	["$feof"] = "fopen",
	["$dumpfile"] = "dumpvars",
	["$dumpvars"] = "dumpvars",
	["$dumpoff"] = "dumpvars",
	["$dumpon"] = "dumpvars",
	["$dumpall"] = "dumpvars",
	["$time"] = "display",
}

local function build_verilog_index()
	if verilog_file_index then
		return
	end
	verilog_file_index = {}
	local handle = vim.uv.fs_scandir(verilog_doc_dir)
	if not handle then
		return
	end
	while true do
		local name, typ = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if typ == "file" and name:match("%.md$") then
			local base = name:gsub("%.md$", "")
			verilog_file_index[base] = verilog_doc_dir .. "/" .. name
		end
	end
end

local function show_verilog_doc(word)
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
		title = " Verilog: " .. word .. " ",
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

	-- Resolve alias
	local lookup = verilog_aliases[word] or word

	if verilog_doc_cache[lookup] then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, verilog_doc_cache[lookup])
		return
	end

	build_verilog_index()
	local filepath = verilog_file_index and verilog_file_index[lookup]
	if not filepath then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No documentation found for: " .. word })
		return
	end

	local f = io.open(filepath, "r")
	if not f then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Failed to read: " .. filepath })
		return
	end
	local raw = f:read("*a")
	f:close()

	local lines = vim.split(raw, "\n")
	-- Trim trailing empty lines
	while #lines > 0 and lines[#lines] == "" do
		table.remove(lines)
	end

	verilog_doc_cache[lookup] = lines
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "verilog", "systemverilog" },
	callback = function()
		vim.keymap.set("n", "gh", function()
			local word = vim.fn.expand("<cword>")
			-- Handle system tasks: cursor on "display" but actual keyword is "$display"
			local line = vim.api.nvim_get_current_line()
			local col = vim.fn.col(".")
			if col > 1 and line:sub(col - 1, col - 1) == "$" then
				word = "$" .. word
			end
			-- Handle compiler directives: cursor on "define" but actual keyword is "`define"
			if col > 1 and line:sub(col - 1, col - 1) == "`" then
				word = word -- backtick directives are stored without backtick
			end
			show_verilog_doc(word:lower())
		end, { desc = "Open Verilog doc in floating window", buffer = 0 })
	end,
})

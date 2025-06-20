require("treesitter-context").setup({
	enable = true,
	multiwindow = false,
	max_lines = 0,
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 2,
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = "cursor",
	separator = nil,
	zindex = 20, -- The Z-index of the context window
	on_attach = nil,
})

vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Color
vim.cmd("hi TreesitterContextBottom gui=underline guisp=Red")
vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Red")

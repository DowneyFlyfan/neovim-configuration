require("todo-comments").setup({})

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev({ keywords = { "TODO", "BUG" } })
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next({ keywords = { "todo", "bug" } })
end, { desc = "next error/warning todo comment" })

vim.keymap.set("n", "<Space>t", ":TodoLocList<CR>")

local todo_concealed = false
vim.keymap.set("n", "<Space>tt", function()
	if todo_concealed then
		vim.cmd("match none")
		vim.wo.conceallevel = 0
	else
		vim.cmd("match Conceal /.*\\(FIX:\\|WARN:\\).*$/")
		vim.wo.conceallevel = 2
	end
	todo_concealed = not todo_concealed
end, { desc = "Conceal/reveal FIX and WARN comments" })

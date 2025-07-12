require("todo-comments").setup({})

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev({ keywords = { "TODO", "BUG" } })
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next({ keywords = { "todo", "bug" } })
end, { desc = "next error/warning todo comment" })

vim.keymap.set("n", "<Space>t", ":TodoLocList<CR>")

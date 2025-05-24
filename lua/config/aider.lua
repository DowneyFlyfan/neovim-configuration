require("aider").setup({
	auto_manage_context = false, -- 用户希望手动管理上下文
	default_bindings = false, -- 用户希望使用自定义按键映射
	debug = true,
	vim = true,
	notification = true,
	ignore_buffers = {},
	border = {
		style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		color = "#fab387",
	},
})

function _G.run_aider_in_terminal()
	vim.cmd("vsplit | terminal")
	vim.defer_fn(function()
		vim.api.nvim_input("aaider<CR>")
	end, 700)
	vim.defer_fn(function()
		vim.cmd("q")
	end, 800)
end

vim.api.nvim_set_keymap(
	"n",
	"<D-k>",
	"<cmd>lua run_aider_in_terminal()<CR>",
	{ noremap = true, silent = true, desc = "Run Aider in Browser" }
)

-- Refer to https://github.com/echasnovski/mini.nvim?tab=readme-ov-file

require("mini.comment").setup({})

require("mini.files").setup({})

vim.keymap.set("n", "<M-f>", function()
	MiniFiles.open()
end, { desc = "Open mini.files" })

require("mini.align").setup({})

require("mini.move").setup({})

require("mini.pairs").setup({})

require("mini.surround").setup({
	custom_surroundings = {
		["*"] = {
			input = function()
				local n_star = MiniSurround.user_input("Number of * to find")
				local many_star = string.rep("%*", tonumber(n_star) or 1)
				return { many_star .. "().-()" .. many_star }
			end,
			output = function()
				local n_star = MiniSurround.user_input("Number of * to output")
				local many_star = string.rep("*", tonumber(n_star) or 1)
				return { left = many_star, right = many_star }
			end,
		},
		["b"] = {
			input = function()
				local many_star = string.rep("%*", 2)
				return { many_star .. "().-()" .. many_star }
			end,
			output = function()
				local many_star = string.rep("*", 2)
				return { left = many_star, right = many_star }
			end,
		},
		["B"] = {
			input = function()
				local many_star = string.rep("%*", 3)
				return { many_star .. "().-()" .. many_star }
			end,
			output = function()
				local many_star = string.rep("*", 3)
				return { left = many_star, right = many_star }
			end,
		},
	},
})

require("mini.operators").setup({
	-- No need to copy this inside `setup()`. Will be used automatically.
	{
		evaluate = {
			prefix = "g=",

			-- Function which does the evaluation
			func = nil,
		},

		-- Exchange text regions
		exchange = {
			prefix = "gx",

			-- Whether to reindent new text to match previous indent
			reindent_linewise = true,
		},

		-- Multiply (duplicate) text
		multiply = {
			prefix = "gm",

			-- Function which can modify text before multiplying
			func = nil,
		},

		-- Replace text with register
		replace = {
			prefix = "gr",

			-- Whether to reindent new text to match previous indent
			reindent_linewise = true,
		},

		-- Sort text
		sort = {
			prefix = "gs",

			-- Function which does the sort
			func = nil,
		},
	},
})

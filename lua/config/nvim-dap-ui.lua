vim.cmd('silent! lua package.loaded["dapui"] = nil')

local dapui = require("dapui")
dapui.setup({
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			terminate = "⏹",
		},
	},
	floating = {
		max_height = 0.9,
		max_width = 0.5,
		border = "rounded",
	},
	layouts = {
		{
			elements = { "repl" },
			position = "right",
			size = 40,
			force = true,
		},
	},
})

local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

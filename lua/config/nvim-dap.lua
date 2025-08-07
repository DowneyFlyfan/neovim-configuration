local dap = require("dap")

vim.keymap.set("n", "<M-c>", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-i>", ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-o>", ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-b>", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })

-- Python
dap.adapters.python = {
	type = "executable",
	command = "python",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = vim.fn.expand("%:p:h"),
	},
}

-- GDB
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

-- C
dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Attach to gdbserver :1234",
		type = "gdb",
		request = "attach",
		target = "localhost:1234",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

-- C++
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}

-- Rust
dap.configurations.rust = {
	{
		initCommands = function()
			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
			assert(
				vim.v.shell_error == 0,
				"failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot
			)
			local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

			return {
				([[!command script import '%s']]):format(script_file),
				([[command source '%s']]):format(commands_file),
			}
		end,
	},
}

-- Bash
dap.adapters.bashdb = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
	name = "bashdb",
}

dap.configurations.sh = {
	{
		type = "bashdb",
		request = "launch",
		name = "Launch file",
		showDebugOutput = true,
		pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
		pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
		trace = true,
		file = "${file}",
		program = "${file}",
		cwd = "${workspaceFolder}",
		pathCat = "cat",
		pathBash = "/bin/bash",
		pathMkfifo = "mkfifo",
		pathPkill = "pkill",
		args = {},
		argsString = "",
		env = {},
		terminalKind = "integrated",
	},
}

-- Lua (Constructing...)
dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		"/absolute/path/to/local-lua-debugger-vscode/extension/debugAdapter.js",
	},
	enrich_config = function(config, on_config)
		if not config["extensionPath"] then
			local c = vim.deepcopy(config)
			-- 💀 If this is missing or wrong you'll see
			-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
			c.extensionPath = "/absolute/path/to/local-lua-debugger-vscode/"
			on_config(c)
		else
			on_config(config)
		end
	end,
}

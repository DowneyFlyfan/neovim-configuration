vim.opt.mouse = "a" -- Allow mouse in all modes
vim.o.termguicolors = true -- Enable true color support
vim.o.background = "light" -- Light color scheme
vim.o.scrolloff = 5 -- Keep 5 lines above/below cursor
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.conceallevel = 2

-- Terminal Mode Shortcuts
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- UI Configuration
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.splitbelow = true -- New splits open below
vim.opt.splitright = true -- New vsplits open right

-- Tab/Indentation
vim.opt.tabstop = 4 -- Visual spaces per TAB
vim.opt.softtabstop = 4 -- Spaces inserted per TAB
vim.opt.shiftwidth = 4 -- Spaces for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Search Settings
vim.opt.incsearch = true -- Search as you type
vim.opt.hlsearch = true -- Highlight matches
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase used
vim.api.nvim_set_keymap("n", "<Space>]", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Undo/History
vim.opt.undofile = true -- Persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Buffer Settings
vim.bo.modifiable = true -- Allow buffer modifications

-- Key Mappings --

-- Window Navigation
vim.api.nvim_set_keymap("n", "<Space>h", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>j", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>k", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space>l", "<C-w>l", { noremap = true, silent = true })

-- Tab Navigation
for i = 1, 9 do
	vim.api.nvim_set_keymap("n", "<Space>" .. i, ":tabn " .. i .. "<CR>", { noremap = true, silent = true })
end

-- Window Resizing
vim.api.nvim_set_keymap("n", "<Down>", ":resize +1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Up>", ":resize -1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", ":vertical resize -3<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", ":vertical resize +3<CR>", { noremap = true, silent = true })

-- Cursor Movement
vim.api.nvim_set_keymap("n", "H", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "J", "5j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "5k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", "$", { noremap = true, silent = true })

-- Visual Mode Movement
vim.api.nvim_set_keymap("v", "J", "5j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", "5k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true }) -- Yank to system clipboard

-- Terminal
function open_terminal()
	vim.cmd("vsplit | terminal")

	vim.cmd("vertical resize 65")
	vim.defer_fn(function()
		vim.api.nvim_input("a")
	end, 300)
end
vim.api.nvim_set_keymap("n", "T", ":lua open_terminal()<CR>", { noremap = true, silent = true })

-- Delay Edit
local group = vim.api.nvim_create_augroup("MyDelayedEOnFileOpen", { clear = true })
vim.opt.laststatus = 3
vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local bufname = vim.api.nvim_buf_get_name(bufnr)

		if bufname == nil or bufname == "" then
			return
		end

		if vim.b[bufnr].my_delayed_e_ran_on_first_load then
			return
		end
		vim.b[bufnr].my_delayed_e_ran_on_first_load = true

		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_loaded(bufnr) then
				return
			end

			local current_bufnr_at_exec_time = vim.api.nvim_get_current_buf()
			if current_bufnr_at_exec_time == bufnr then
				vim.cmd("e")
			else
			end
		end, 20) -- 20ms
	end,
})

-- AI Shortcuts
vim.api.nvim_set_keymap("n", "<space>c", ":AvanteClear<CR>", { noremap = true, silent = true }) -- Windows equivalent: Alt-c or Windows-c

-- Debugging
-- vim.lsp.set_log_level("INFO")

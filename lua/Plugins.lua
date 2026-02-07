local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- [Core Libraries]
	{ "nvim-lua/plenary.nvim" }, -- Lua functions library
	{ "nvim-tree/nvim-web-devicons" }, -- Icon support

	-- [UI & Themes]
	{
		"morhetz/gruvbox", -- Main colorscheme
		config = function()
			vim.cmd("colorscheme gruvbox")
			vim.api.nvim_set_hl(0, "MatchParen", { fg = "#000000", bg = "#DAA520", bold = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim", -- Statusline
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.lualine")
		end,
	},
	{
		"onsails/lspkind.nvim", -- Pictograms for completion
		event = { "vimenter" },
	},
	{
		"norcalli/nvim-colorizer.lua", -- Color highlighter
		config = function()
			require("colorizer").setup({
				"css",
				"javascript",
				html = { mode = "background" },
			}, { mode = "foreground" })
		end,
	},

	-- [LSP Infrastructure]
	{
		"mason-org/mason.nvim", -- Package manager
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim", -- LSP bridge
		opts = {
			ensure_installed = {
				"pyright",
				"bashls",
				"lua_ls",
				"ts_ls",
				"html",
				"texlab",
				"cssls",
				"matlab_ls",
				"marksman",
				"svlangserver",
				"clangd",
				"rust_analyzer",
				"asm_lsp",
			},
		},

		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{
		"ray-x/lsp_signature.nvim", -- Signature hints
		event = "insertenter",
	},

	-- [Docs]
	{
		"madskjeldgaard/cppman.nvim", -- Cpp manual
		requires = {
			{ "MunifTanjim/nui.nvim" },
		},
		ft = { "c", "ch", "cc", "cpp", "cu", "cuh" },
		config = function()
			local cppman = require("cppman")
			cppman.setup()

			-- Make a keymap to open the word under cursor in CPPman
			vim.keymap.set("n", "gh", function()
				cppman.open_cppman_for(vim.fn.expand("<cword>"))
			end)

			-- Open search box
			vim.keymap.set("n", "<leader>cc", function()
				cppman.input()
			end)
		end,
	},

	-- [Completion & Snippets]
	{
		"hrsh7th/nvim-cmp", -- Completion engine
		dependencies = {
			"lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"micangl/cmp-vimtex",
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},
	{
		"l3mon4d3/luasnip", -- Snippets engine
		version = "v2.*",
		config = function()
			require("config.snippets")
		end,
	},

	-- [Formatting & Linting]
	{
		"stevearc/conform.nvim", -- Formatter
		opts = {},
		config = function()
			require("config.conform")
		end,
	},
	{
		"mfussenegger/nvim-lint", -- Linter
		config = function()
			require("config.lint")
		end,
		enabled = treesitter,
	},

	-- [Treesitter & Syntax]
	{
		"nvim-treesitter/nvim-treesitter", -- Parser generator
		config = function()
			require("config.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context", -- Sticky context
		config = function()
			require("config.treesitter-context")
		end,
	},
	{
		"andymass/vim-matchup", -- Match
		init = function()
			vim.g.matchup_matchparen_hi_surround_always = 1
			vim.g.matchup_matchparen_deferred = 1
			vim.g.loaded_matchit = 1
			vim.g.loaded_matchparen = 1
		end,
		config = function()
			require("match-up").setup({
				treesitter = {
					enable = true,
					include_match_words = true,
				},
			})
		end,
	},

	-- [Navigation & Selection]
	{
		"ibhagwan/fzf-lua", -- Fuzzy finder
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.fzf-lua")
		end,
	},
	{
		"mbbill/undotree", -- Undo visualizer
		config = function()
			vim.keymap.set("n", "UD", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>",
				["Add Cursor Up"] = "<C-k>",
				["Add Cursor Down"] = "<C-j>",
			}
		end,
		enabled = true,
	},

	-- [Git]
	{
		"lewis6991/gitsigns.nvim", -- Git integration
		config = function()
			require("config.gitsigns")
		end,
	},

	-- [Debug]
	{
		"jay-babu/mason-nvim-dap.nvim", -- DAP manager
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("config.nvim-dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui", -- Debugger UI
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("config.nvim-dap-ui")
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- [Markdown & Notes]
	{
		"iamcco/markdown-preview.nvim", -- Browser preview
		cmd = { "Markdownpreviewtoggle", "Markdownpreview", "Markdownpreviewstop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		config = function()
			require("config.markdown-preview")
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim", -- Markdown rendering
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		completions = { lsp = { enabled = true } },
		ft = { "markdown", "codecompanion", "terminal", "Avante" },
		enabled = true,
	},
	{
		"Zeioth/markmap.nvim", -- Mindmap support
		build = "yarn global add markmap-cli",
		cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
		opts = {
			html_output = "/tmp/markmap.html",
			hide_toolbar = false,
			grace_period = 3600000,
		},
		config = function(_, opts)
			require("markmap").setup(opts)
			vim.api.nvim_set_keymap("n", "<Space>o", ":MarkmapOpen<CR>", { noremap = true, silent = true })
		end,
		ft = { "markdown" },
	},
	{
		"epwalsh/obsidian.nvim", -- Obsidian vault support
		version = "*",
		lazy = true,
		event = {
			"BufReadPre /users/downeyflyfan/library/mobile documents/icloud~md~obsidian/documents/**/*.md",
			"BufNewFile /Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "/Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/All",
				},
				{
					name = "work",
					path = "/Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/All",
				},
			},
		},
	},
	{
		"folke/todo-comments.nvim", -- TODO highlighter
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.todo-comments")
		end,
	},

	{
		"MattesGroeger/vim-bookmarks", -- bookmarks
	},

	-- [Specific Languages]
	{
		"lervag/vimtex", -- LaTeX
		config = function()
			require("config.vimtex")
		end,
		ft = { "tex" },
	},
	{
		"echasnovski/mini.nvim", -- Utility suite
		version = false,
		config = function()
			require("config.mini")
		end,
	},
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "c", "cpp", "cc" },
		opts = {},
		config = function()
			require("config.cmake")
		end,
	},

	-- [AI Engine]
	{
		"yetone/avante.nvim",
		build = function()
			if vim.fn.has("win32") == 1 then
				local plugin_path = vim.fn.stdpath("data") .. "/lazy/avante.nvim"
				local command = "powershell.exe -ExecutionPolicy Bypass -File "
					.. plugin_path
					.. "/Build.ps1 -BuildFromSource false"
				vim.fn.system({ "cmd.exe", "/c", command })
			else
				local plugin_path = vim.fn.stdpath("data") .. "/lazy/avante.nvim"
				vim.fn.system({ "make", "-C", plugin_path })
			end
		end,
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "gemini",
			providers = {
				openai = {
					endpoint = "https://api.deepseek.com",
					api_key_name = "DEEPSEEK_API_KEY",
					model = "deepseek-chat",
				},
				gemini = {
					api_key_name = "GEMINI_API_KEY",
					model = "gemini-3-flash-preview",
				},
			},
			windows = { position = "smart", width = 38 },
			web_search_engine = {
				provider = "google",
				proxy = "https://127.0.0.1:7890",
			},
			behaviour = {
				enable_fastapply = true,
			},
		},

		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-mini/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		enabled = true,
	},
})

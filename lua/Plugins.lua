local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"mg979/vim-visual-multi",
		branch = "master",
		config = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>",
				["Add Cursor Up"] = "<M-k>",
				["Add Cursor Down"] = "<M-j>",
			}
		end,
		enabled = false,
	},

	{
		"terryma/vim-multiple-cursors",
	},

	-- vscode-like pictograms
	{
		"onsails/lspkind.nvim",
		event = { "vimenter" },
	},

	-- code snippet engine
	{
		"l3mon4d3/luasnip",
		version = "v2.*",
		config = function()
			require("config.snippets")
		end,
	},

	-- auto-completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
			"hrsh7th/cmp-buffer", -- buffer auto-completion
			"hrsh7th/cmp-path", -- path auto-completion
			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
			"saadparwaiz1/cmp_luasnip",
			"micangl/cmp-vimtex",
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},

	-- todo-comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.todo-comments")
		end,
	},

	-- themes
	{
		"morhetz/gruvbox",
		config = function()
			vim.cmd("colorscheme gruvbox")
			vim.api.nvim_set_hl(0, "MatchParen", { fg = "#000000", bg = "#DAA520", bold = true })
		end,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("config.conform")
		end,
	},

	-- lsp tools
	{
		"mason-org/mason.nvim",
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
		"mason-org/mason-lspconfig.nvim",
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
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	{
		"nvim-lua/plenary.nvim",
	},

	-- debug tools
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("config.nvim-dap")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("config.nvim-dap-ui")
		end,
	},

	-- nvim-treesitter & vim-matchup
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config.treesitter")
		end,
	},

	{
		"andymass/vim-matchup",
		commit = "5456eaccf757606884ec1ac1ef3f564019973873", -- Pin to the commit for v0.7.4, which is known to be stable
		init = function()
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_hi_surround_always = 1
			vim.g.loaded_matchit = 1
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("config.treesitter-context")
		end,
	},

	-- undotree
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "UD", vim.cmd.UndotreeToggle)
		end,
	},

	-- web devicons
	{
		"nvim-tree/nvim-web-devicons",
	},

	-- lsp signature
	{
		"ray-x/lsp_signature.nvim",
		event = "insertenter",
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.lualine")
		end,
	},

	-- Markdown related
	{
		"iamcco/markdown-preview.nvim",
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
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		completions = { lsp = { enabled = true } },
		ft = { "markdown", "codecompanion", "terminal", "Avante" },
		enabled = true,
	},

	{
		"Zeioth/markmap.nvim",
		build = "yarn global add markmap-cli",
		cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
		opts = {
			html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
			hide_toolbar = false, -- (default)
			grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
		},
		config = function(_, opts)
			require("markmap").setup(opts)
			vim.api.nvim_set_keymap("n", "<Space>o", ":MarkmapOpen<CR>", { noremap = true, silent = true })
		end,
		ft = { "markdown" },
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = {
			"BufReadPre /users/downeyflyfan/library/mobile documents/icloud~md~obsidian/documents/**/*.md",
			"BufNewFile /Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
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

	-- tex
	{
		"lervag/vimtex",
		config = function()
			require("config.vimtex")
		end,
		ft = { "tex" },
	},

	-- fzf-lua
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.fzf-lua")
		end,
	},

	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns")
		end,
	},

	-- colorizer
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"css",
				"javascript",
				html = { mode = "background" },
			}, { mode = "foreground" })
		end,
	},

	-- mini series
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("config.mini")
		end,
	},

	-- ai engine
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
		version = false, -- Never set this value to "*"! Never!

		opts = {
			provider = "gemini",
			providers = {
				gemini = {
					api_key_name = "GEMINI_API_KEY",
					model = "gemini-2.5-flash",
				},
			},
			windows = {
				position = "smart",
				width = 38,
			},
			web_search_engine = {
				provider = "google",
				proxy = "https://127.0.0.1:7890",
			},
			ask = {
				floating = true,
				start_insert = false,
				border = "rounded",
				---@type "ours" | "theirs"
				focus_on_apply = "ours", -- which diff to focus after applying
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
				},
			},
		},
		enabled = true,
	},
})

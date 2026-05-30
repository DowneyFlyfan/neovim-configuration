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
				"clangd",
				"rust_analyzer",
				"asm_lsp",
				"tclsp",
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
		dependencies = {
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
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
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
			require("mason-nvim-dap").setup({
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
					bash = function()
						-- Skip automatic bash config; we set it up manually
					end,
				},
			})
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
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		-- Use yarn to keep app/yarn.lock untouched; reset any drift to keep tree clean for lazy.nvim updates
		build = function(plugin)
			vim.fn.system({ "sh", "-c", "cd " .. plugin.dir .. "/app && yarn install --frozen-lockfile" })
			vim.fn.system({ "git", "-C", plugin.dir, "checkout", "--", "app/yarn.lock" })
			vim.fn.system({ "rm", "-f", plugin.dir .. "/app/package-lock.json" })
		end,
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
		config = function()
			require("config.render-markdown")
		end,
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
		event = vim.fn.has("linux") == 1 and {
			"BufReadPre /home/downeyflyfan/Notes/**/*.md",
			"BufNewFile /home/downeyflyfan/Notes/**/*.md",
		} or {
			"BufReadPre /Users/downeyflyfan/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/**/*.md",
			"BufNewFile /Users/downeyflyfan/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/**/*.md",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = vim.fn.has("linux") == 1 and {
				{ name = "personal", path = "/home/downeyflyfan/Notes" },
				{ name = "work", path = "/home/downeyflyfan/Notes" },
			} or {
				{
					name = "personal",
					path = "/Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/All",
				},
				{
					name = "work",
					path = "/Users/downeyflyfan/Library/Mobile Documents/iCloud~md~obsidian/Documents/All",
				},
			},
			completion = {
				nvim_cmp = true,
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)
			vim.keymap.set("n", "gf", function()
				vim.cmd("e " .. vim.fn.expand("<cfile>"))
			end)
		end,
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
		config = function()
			vim.g.bookmark_sign = "⚽︎"
			vim.g.bookmark_highlight_lines = 1
		end,
	},
	{
		"3rd/image.nvim", -- viewing image
		-- Pinned to a local branch (`local-fixes`) carrying two patches:
		--   1. pcall guards in image.lua to prevent one bad file from crashing
		--   2. rsvg-convert SVG path (avoids ImageMagick MVG parser bugs)
		-- Update flow: see ~/.config/nvim/patches/image.nvim-local.patch and
		--   `cd ~/.local/share/nvim/lazy/image.nvim && git fetch origin master && git rebase origin/master`
		branch = "local-fixes",
		pin = true,
		build = false,
		config = function()
			require("config.image")
		end,
	},
	{
		"Thiago4532/mdmath.nvim", -- Inline LaTeX equation rendering as images
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		build = "cd mdmath-js && npm install",
		-- Load on markdown OR claude-code sidebar (snacks_terminal filetype).
		ft = { "markdown", "snacks_terminal" },
		config = function()
			require("mdmath").setup({
				-- snacks_terminal = claudecode.nvim sidebar buffer filetype.
				filetypes = { "markdown", "snacks_terminal" },
				foreground = "#000000",
				anticonceal = true,
				-- Sidebar is mostly used in terminal/insert mode; keep formulas visible.
				hide_on_insert = false,
				dynamic = true,
				dynamic_scale = vim.fn.has("linux") == 1 and 1.0 or 0.6,
				-- Slightly longer interval for terminal buffers (frequent updates).
				update_interval = 500,
				internal_scale = vim.fn.has("linux") == 1 and 2.0 or 0.6,
			})

			-- Three issues mdmath has on claude-code sidebar (snacks_terminal buffer):
			-- (1) Lazy-load race: when claude-code sidebar opens, lazy.nvim loads
			--     mdmath BECAUSE FileType=snacks_terminal fired. mdmath's own
			--     FileType autocmd then registers AFTER the event has already
			--     fired for the triggering buffer, so it misses the activation.
			--     setup()'s fallback only checks `vim.bo.filetype` of the
			--     *current* buffer, which is not always the new sidebar buffer.
			-- (2) Terminal-buffer treesitter sync bug: on terminal buffers, the
			--     markdown TS parser's byte-edit tracking gets out of sync with
			--     terminal output. The parser ends up only "seeing" the first
			--     line, so `markdown_inline` injection never activates and
			--     `(latex_block)` queries return zero matches. Workaround:
			--     `parser:invalidate()` + `parser:parse(true)` on every line
			--     update forces a full reparse and re-runs injections.
			-- (3) Terminal scroll-out problem: mdmath calls `get_current_view`
			--     (line('w0')..line('w$')) and only queries equations in that
			--     visible range. Terminal output scrolls fast, so equations
			--     printed earlier scroll out of the visible range and are never
			--     rendered. Override get_current_view to return the full buffer
			--     range for snacks_terminal buffers.
			local mdmath_util = require("mdmath.util")
			local orig_get_current_view = mdmath_util.get_current_view
			mdmath_util.get_current_view = function()
				local buf = vim.api.nvim_get_current_buf()
				if vim.bo[buf].filetype == "snacks_terminal" then
					return 0, vim.api.nvim_buf_line_count(buf)
				end
				return orig_get_current_view()
			end

			-- Heavy patch: replace mdmath.overlay's Buffer:parse for terminal
			-- buffers. The buffer-attached markdown TS parser is broken on
			-- nvim 0.12 + terminal buffers: byte-edit tracking gets out of sync
			-- with terminal output, regions become stale, and `parse(true)`
			-- fails with "Range value out of bounds". A fresh string parser on
			-- the buffer's current text content works fine and reliably activates
			-- the `markdown_inline` injection so `(latex_block)` matches resolve.
			local mdmath_overlay = require("mdmath.overlay")
			local function find_upvalue(fn, name)
				for i = 1, 100 do
					local n, v = debug.getupvalue(fn, i)
					if not n then
						return nil
					end
					if n == name then
						return v
					end
				end
			end
			local create_buffer = find_upvalue(mdmath_overlay.enable, "create_buffer")
			local Buffer = create_buffer and find_upvalue(create_buffer, "Buffer")
			local Equation = create_buffer and find_upvalue(create_buffer, "Equation")
			-- Equation is required directly inside overlay; grab it via require.
			if not Equation then
				Equation = require("mdmath.Equation")
			end

			if Buffer and not Buffer._mdmath_string_parser_patched then
				Buffer.parse = function(self, start_row, end_row)
					local bufnr = self.bufnr
					if not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end
					-- Snapshot buffer text for the string parser.
					local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
					local parser = vim.treesitter.get_string_parser(text, "markdown")
					parser:parse(true)
					local inlines = parser:children()["markdown_inline"]
					if not inlines then
						return
					end
					local query = vim.treesitter.query.parse("markdown_inline", "(latex_block) @block")

					local old_equations = self.equations
					local equations = {}

					local function process_equation(sr, sc, _er, _ec, value)
						local equation = nil
						for key, eq in ipairs(old_equations) do
							if eq ~= 0 and eq.valid and eq.pos[1] == sr and eq.pos[2] == sc and eq.text == value then
								equation = eq
								old_equations[key] = 0
								break
							end
						end
						equation = equation or Equation.new(bufnr, sr, sc, value)
						if equation then
							equations[#equations + 1] = equation
						end
					end

					-- iter_captures with a string source uses byte offsets, not
					-- line numbers, for start/stop. We re-parse the whole text
					-- (terminal scrolls fast → full-buffer view is the right
					-- semantics anyway), so just iterate every match and filter
					-- by node row when needed.
					inlines:for_each_tree(function(tree)
						for _, node in query:iter_captures(tree:root(), text) do
							local sr, sc, er, ec = node:range()
							if sr >= start_row and sr < end_row then
								local value = vim.treesitter.get_node_text(node, text)
								process_equation(sr, sc, er, ec, value)
							end
						end
					end)

					for _, eq in ipairs(old_equations) do
						if eq ~= 0 and eq.valid then
							if not eq.pos[1] or (start_row <= eq.pos[1] and eq.pos[1] < end_row) then
								eq:invalidate()
							else
								equations[#equations + 1] = eq
							end
						end
					end

					self.equations = equations
				end
				Buffer._mdmath_string_parser_patched = true
			end

			-- SSH fix: mdmath transmits images to Kitty with medium t='f' (file
			-- path), which fails when nvim is remote (over SSH) but the terminal
			-- is local -- the PNG is on the remote /tmp the local terminal can't
			-- read. Switch to t='d' (inline base64) over SSH, like image.nvim.
			require("config.mdmath_transmit")

			local mdmath_group = vim.api.nvim_create_augroup("MdMathClaudeSidebar", { clear = true })
			local overlay_buffers = find_upvalue(mdmath_overlay.enable, "buffers")

			local function setup_sidebar(buf)
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				if vim.b[buf]._mdmath_sidebar_attached then
					return
				end
				vim.b[buf]._mdmath_sidebar_attached = true

				-- Run enable in the sidebar's buffer context so the immediate
				-- parse_view picks up the right view/source.
				vim.api.nvim_buf_call(buf, function()
					pcall(function()
						require("mdmath").enable(buf)
					end)
				end)

				-- Re-trigger mdmath's per-buffer parse on each terminal-output
				-- batch. Debounced. We bypass mdmath's own on_lines (which may
				-- not fire reliably for terminal output) by listening directly
				-- via nvim_buf_attach AND TextChanged{,T} autocmds.
				local pending = false
				local function trigger_parse()
					if pending then
						return
					end
					pending = true
					vim.defer_fn(function()
						pending = false
						if not vim.api.nvim_buf_is_valid(buf) then
							return
						end
						if not overlay_buffers then
							return
						end
						local b_obj = overlay_buffers[buf]
						if not b_obj then
							return
						end
						pcall(function()
							b_obj:parse(0, vim.api.nvim_buf_line_count(buf))
						end)
					end, 500)
				end

				vim.api.nvim_buf_attach(buf, false, {
					on_lines = function()
						if not vim.api.nvim_buf_is_valid(buf) then
							return true
						end
						trigger_parse()
					end,
				})
				vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedT", "TextChangedI" }, {
					group = mdmath_group,
					buffer = buf,
					callback = trigger_parse,
				})
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = mdmath_group,
				pattern = "snacks_terminal",
				callback = function(args)
					vim.defer_fn(function()
						setup_sidebar(args.buf)
					end, 200)
				end,
			})
			-- Cover sidebars already open at the time this config runs.
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "snacks_terminal" then
					setup_sidebar(buf)
				end
			end

			-- Disable mdmath on codecompanion buffers to avoid assertion errors
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function(args)
					local bufname = vim.api.nvim_buf_get_name(args.buf)
					if bufname:match("%[CodeCompanion%]") or bufname:match("codecompanion") then
						vim.b[args.buf].mdmath_enabled = false
						pcall(vim.cmd, "MdMath disable")
					end
				end,
			})
		end,
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
					model = "deepseek-v4-flash",
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
		enabled = false,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			opts = {
				log_level = "DEBUG", -- or "TRACE"
			},
		},
		config = function()
			require("config.codecompanion")
		end,
		enabled = true,
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			terminal_cmd = "claude --dangerously-skip-permissions -c 2>/dev/null || claude --dangerously-skip-permissions",
		},
		config = true,
		keys = {
			{ "<leader>c", nil, desc = "AI/Claude Code" },
			{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>cs",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
})

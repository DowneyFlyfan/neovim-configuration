require("codecompanion").setup({
	adapters = {
		-- deepseek = function()
		-- 	return require("codecompanion.adapters").extend("deepseek", {
		-- 		env = {
		-- 			api_key = "DEEPSEEK_API_KEY",
		-- 		},
		-- 		schema = {
		-- 			model = {
		-- 				default = "deepseek-chat", -- deepseek-reasoner
		-- 			},
		-- 		},
		-- 	})
		-- end,

		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				env = {
					api_key = "GEMINI_API_KEY",
				},
				schema = {
					model = {
						default = "gemini-3-flash-preview",
					},
				},
			})
		end,
	},

	strategies = {
		chat = { adapter = { name = "deepseek", model = "deepseek-chat" } },
		inline = { adapter = { name = "deepseek", model = "deepseek-chat" } },
		agent = { adapter = { name = "deepseek", model = "deepseek-chat" } },
	},

	opts = {
		language = "Chinese",
	},

	prompt_library = {
		["Code explained in Chinese Using Deepseek reasoner"] = {
			strategy = "chat",
			description = "推理模型中文解释代码",
			opts = {
				index = 5,
				is_default = true,
				is_slash_cmd = false,
				modes = { "v" },
				short_name = "reasoner explain",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-reasoner",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[当被要求解释代码时，请遵循以下步骤：
                        1. 识别编程语言。
                        2. 描述代码的目的，并引用该编程语言的核心概念。
                        3. 解释每个函数或重要的代码块，包括参数和返回值。
                        4. 突出说明使用的任何特定函数或方法及其作用。
                        5. 如果适用，提供该代码如何融入更大应用程序的上下文。
                        ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						-- 直接从可视模式获取选中文本
						local input = require("codecompanion.helpers.actions").get_visual_selection()

						return string.format(
							[[请解释以下代码：
```%s
%s
```]],
							vim.bo.filetype,
							input
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Code explained in Chinese Using Deepseek chat"] = {
			strategy = "chat",
			description = "语言模型中文解释代码",
			opts = {
				index = 5,
				is_default = true,
				is_slash_cmd = false,
				modes = { "v" },
				short_name = "chat explain",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-chat",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[当被要求解释代码时，请遵循以下步骤：
                        1. 识别编程语言。
                        2. 描述代码的目的，并引用该编程语言的核心概念。
                        3. 解释每个函数或重要的代码块，包括参数和返回值。
                        4. 突出说明使用的任何特定函数或方法及其作用。
                        5. 如果适用，提供该代码如何融入更大应用程序的上下文。
                        ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						local input =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return string.format(
							[[请解释 buffer %d 中的这段代码:

  ```%s
  %s
  ```
  ]],
							context.bufnr,
							context.filetype,
							input
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Code Optimization Using Chat Model"] = {
			strategy = "inline",
			description = "语言模型优化代码",
			opts = {
				index = 5,
				is_default = true,
				is_slash_cmd = false,
				modes = { "v" },
				short_name = "chat optimize",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-chat",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[当被要求优化代码时，请遵循以下步骤：
                        1. 识别编程语言。
                        2. 给出优化代码并修复可能的bug
                        3. 只输出代码，不要任何解释或额外文本
                        ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						local input =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return string.format(
							[[请优化 buffer %d 中的代码:

  ```%s
  %s
  ```
  ]],
							context.bufnr,
							context.filetype,
							input
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Code Optimization Using Reasoning Model"] = {
			strategy = "inline",
			description = "推理模型优化代码",
			opts = {
				index = 5,
				is_default = true,
				is_slash_cmd = false,
				modes = { "v" },
				short_name = "reasoner optimize",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-reasoner",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[当被要求优化代码时，请遵循以下步骤：
                        1. 识别编程语言。
                        2. 给出优化代码并修复可能的bug
                        3. 只输出代码，不要任何解释或额外文本
                        ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						local input =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return string.format(
							[[请优化 buffer %d 中的代码:

  ```%s
  %s
  ```
  ]],
							context.bufnr,
							context.filetype,
							input
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Insert LaTeX Formulas"] = {
			strategy = "inline",
			description = "直接生成格式化LaTeX公式",
			opts = {
				index = 6,
				is_default = false,
				is_slash_cmd = false,
				modes = { "n", "v" },
				short_name = "Formula",
				auto_submit = false,
				user_prompt = true,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-chat",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[你是一个LaTeX专家，请严格遵循：
                        1. 只输出LaTeX公式代码，不要任何解释或额外文本
                        2. 必须使用以下结构：
                        \begin{equations}
                        \begin{aligned}
                        % 公式内容
                        \end{aligned}
                        \end{equations}
                        3. 优先使用\dfrac、\displaystyle等放大显示
                        4. 对复杂公式使用split、cases等环境
                        5. 确保所有括号大小自动匹配\left\right
                        6. 尽量使用mathcal, mathfrak等优美字体
                        ]],
					opts = {
						visible = true,
					},
				},
				{
					role = "user",
					content = function(context)
						if context.mode == "v" then
							local input =
								require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
							return "\n" .. input
						else
							return "生成符合以下描述的LaTeX公式："
						end
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Polish Texts"] = {
			strategy = "inline",
			description = "打磨文字",
			opts = {
				index = 6,
				is_default = false,
				is_slash_cmd = false,
				modes = "v",
				short_name = "Polish",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
				adapter = {
					name = "deepseek",
					model = "deepseek-chat",
				},
			},
			prompts = {
				{
					role = "system",
					content = [[
                    请根据以下文本的语言来打磨这段文字:
                    ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						local input =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return string.format(
							[[buffer %d:
  ```%s
  %s
  ```
  ]],
							context.bufnr,
							context.filetype,
							input
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd("filetype", {
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		local excluded_ft = { tex = true, markdown = true }

		if excluded_ft[ft] then -- Tex & Marddown
			-- Insert Formula
			vim.keymap.set({ "n", "v" }, "<space>f", function()
				require("codecompanion").prompt("Formula")
			end, { noremap = true, silent = true })

			-- Polish Texts
			vim.keymap.set("v", "<space>p", function()
				require("codecompanion").prompt("Polish")
			end, { noremap = true, silent = true })
		end

		-- into insert mode
		vim.keymap.set("v", "a", ":CodeCompanion ", { noremap = true, silent = true })

		-- optimize code
		vim.keymap.set("v", "<space>o", function()
			require("codecompanion").prompt("chat optimize")
		end, { noremap = true, silent = true })

		vim.keymap.set("v", "<space>O", function()
			require("codecompanion").prompt("reasoner optimize")
		end, { noremap = true, silent = true })

		-- explain code
		vim.keymap.set("v", "<space>e", function()
			require("codecompanion").prompt("chat explain")
		end, { noremap = true, silent = true })

		vim.keymap.set("v", "<space>E", function()
			require("codecompanion").prompt("reasoner explain")
		end, { noremap = true, silent = true })
	end,
})

require("codecompanion").setup({
	adapters = {
		http = {
			deepseek = function()
				return require("codecompanion.adapters").extend("deepseek", {
					env = {
						api_key = "DEEPSEEK_API_KEY",
					},
					schema = {
						model = {
							default = "deepseek-chat",
						},
					},
				})
			end,

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
	},

	interactions = {
		chat = {
			adapter = "gemini",
		},
		inline = {
			adapter = "gemini",
		},
	},

	opts = {
		language = "Chinese",
	},

	prompt_library = {
		["Code explaination"] = {
			interaction = "chat",
			description = "中文解释代码",
			opts = {
				index = 5,
				enabled = true,
				is_slash_cmd = false,
				modes = { "v" },
				alias = "chat explain",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
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

		["Code Optimization"] = {
			interaction = "inline",
			description = "优化代码",
			opts = {
				index = 5,
				enabled = true,
				is_slash_cmd = false,
				modes = { "v" },
				alias = "chat optimize",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "system",
					content = [[当被要求优化代码时，请遵循以下步骤：
                        1. 给出优化代码并修复可能的bug
                        2. 只输出代码，不要任何解释或额外文本
                        3. 若输入只有注释，请根据注释要求补全代码
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
			interaction = "inline",
			description = "直接生成格式化LaTeX公式",
			opts = {
				index = 6,
				enabled = true,
				is_slash_cmd = false,
				modes = { "n", "v" },
				alias = "Formula",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
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
						if context.is_visual then
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

		["Complete From Comments"] = {
			interaction = "inline",
			description = "根据注释补全代码或笔记",
			opts = {
				index = 7,
				enabled = true,
				is_slash_cmd = false,
				modes = { "n", "v" },
				alias = "complete",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "system",
					content = [[根据用户提供的注释/备注，补全其后的内容。严格遵循：
                    1. 如果是代码文件中的注释，生成对应的代码实现
                    2. 如果是笔记/文档中的备注，补全相应的文字内容
                    3. 只输出补全的内容，不要重复注释本身，不要任何额外解释
                    4. 保持与上下文一致的风格和语言
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
							[[请根据以下注释补全内容：

```%s
%s
```
]],
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

		["Generate Markdown Table"] = {
			interaction = "inline",
			description = "生成Markdown表格",
			opts = {
				index = 6,
				enabled = true,
				is_slash_cmd = false,
				modes = { "v" },
				alias = "table",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "system",
					content = [[你是一个Markdown表格生成专家，请严格遵循：
                        1. 只输出Markdown表格，不要任何解释或额外文本
                        2. 表格必须格式整齐，列对齐
                        3. 根据用户描述生成合适的表头和内容
                        4. 如果用户选中了文本，将其转换为表格格式
                        ]],
					opts = {
						visible = false,
					},
				},
				{
					role = "user",
					content = function(context)
						if context.is_visual then
							local input =
								require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
							return "请将以下内容转换为Markdown表格：\n" .. input
						else
							return "请生成符合以下描述的Markdown表格："
						end
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},

		["Polish Texts"] = {
			interaction = "inline",
			description = "纠错并润色文字",
			opts = {
				index = 6,
				enabled = true,
				is_slash_cmd = false,
				modes = { "v" },
				alias = "Polish",
				auto_submit = true,
				user_prompt = false,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "system",
					content = [[请根据以下文本的语言来处理这段文字，严格遵循：
                    1. 首先检查并修正所有错误（包括拼写、语法、标点、用词等）
                    2. 然后润色文字结构，使其更加通顺、清晰、专业
                    3. 如有必要，可以添加markdown表格
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
			vim.keymap.set({ "v" }, "<space>f", function()
				require("codecompanion").prompt("Formula")
			end, { noremap = true, silent = true })

			-- Polish Texts
			vim.keymap.set("v", "<space>p", function()
				require("codecompanion").prompt("Polish")
			end, { noremap = true, silent = true })
		end

		-- into insert mode
		vim.keymap.set("v", "a", ":CodeCompanion ", { noremap = true, silent = true })

		-- toggle global adapter (gemini <-> deepseek)
		vim.keymap.set("n", "<space>at", function()
			local config = require("codecompanion.config")
			local current = config.interactions.chat.adapter
			if type(current) == "table" then
				current = current.name
			end
			local new_adapter
			if current == "gemini" then
				new_adapter = "deepseek"
			else
				new_adapter = "gemini"
			end
			config.interactions.chat.adapter = new_adapter
			config.interactions.inline.adapter = new_adapter
			vim.notify("CodeCompanion adapter: " .. new_adapter, vim.log.levels.INFO)
		end, { noremap = true, silent = true, desc = "Toggle adapter (gemini/deepseek)" })

		-- optimize code
		vim.keymap.set("v", "<space>o", function()
			require("codecompanion").prompt("chat optimize")
		end, { noremap = true, silent = true })

		-- generate markdown table
		vim.keymap.set("v", "<space>t", function()
			require("codecompanion").prompt("table")
		end, { noremap = true, silent = true })

		-- explain code
		vim.keymap.set("v", "<space>e", function()
			require("codecompanion").prompt("chat explain")
		end, { noremap = true, silent = true })
	end,
})

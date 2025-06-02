require("avante").setup({
	provider = "gemini",
	vendors = {
		deepseek = {
			__inherited_from = "openai",
			api_key_name = "GEMINI_API_KEY",
			endpoint = "https://generativelanguage.googleapis.com/v1beta",
			-- endpoint = "https://api.deepseek.com",
			model = "gemini-2.5-flash-preview-04-17",
		},
	},
	windows = {
		position = "smart",
		width = 38,
	},
})

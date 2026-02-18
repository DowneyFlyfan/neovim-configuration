-- 在进入 Markdown buffer 后自动打开预览窗口
vim.g.mkdp_auto_start = 0

-- 切换 buffer 时自动关闭当前预览窗口
vim.g.mkdp_auto_close = 1

-- 设置缓冲区保存或离开插入模式时刷新预览，0 为自动刷新
vim.g.mkdp_refresh_slow = 0

-- 不允许 MarkdownPreview 命令在所有文件中使用
vim.g.mkdp_command_for_global = 1

-- 使预览服务器对网络中的其他人可用
vim.g.mkdp_open_to_the_world = 0

-- 使用自定义 IP 打开预览页面
vim.g.mkdp_open_ip = ""

-- 指定用于打开预览页面的浏览器
vim.g.mkdp_browser = "google-chrome-stable"

-- 打开预览页面时在命令行中不显示 URL
vim.g.mkdp_echo_preview_url = 1

-- 自定义打开预览页面的 Vim 函数
vim.g.mkdp_browserfunc = ""

-- Markdown 渲染选项
vim.g.mkdp_preview_options = {
	mkit = {},
	katex = {},
	uml = {},
	maid = {},
	disable_sync_scroll = 0,
	sync_scroll_type = "middle",
	hide_yaml_meta = 1,
	sequence_diagrams = {},
	flowchart_diagrams = {},
	content_editable = false,
	disable_filename = 0,
	toc = {},
}

-- 使用自定义 Markdown 样式
vim.g.mkdp_markdown_css = ""

-- 使用自定义高亮样式
vim.g.mkdp_highlight_css = ""

-- 使用自定义端口启动服务器
vim.g.mkdp_port = ""

-- 预览页面标题
vim.g.mkdp_page_title = "「${name}」"

-- 使用自定义的图像位置
-- vim.g.mkdp_images_path = "/home/user/.markdown_images"

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_theme = "light"

-- 合并预览窗口
vim.g.mkdp_combine_preview = 0

-- 自动刷新合并的预览内容（仅当 mkdp_combine_preview 为 1 时生效）
vim.g.mkdp_combine_preview_auto_refresh = 1

-- Markdown Toggle
vim.api.nvim_set_keymap("n", "<space>p", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true })

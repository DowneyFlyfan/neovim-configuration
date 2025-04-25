require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox_light',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 1,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            function()
                local tabs = {}
                local current_tab = vim.fn.tabpagenr()
                local total_tabs = vim.fn.tabpagenr('$')

                for i = 1, total_tabs do
                    local win_id = vim.fn.tabpagewinnr(i)
                    local buf_id = vim.fn.tabpagebuflist(i)[win_id]
                    local buf_name = vim.fn.bufname(buf_id)
                    local filename = vim.fn.fnamemodify(buf_name, ':t') -- 获取文件名

                    -- 高亮当前 Tab 页
                    local hl = (i == current_tab) and '%#TabLineSel#' or '%#TabLine#'
                    local tab_number = string.format(' %d ', i) -- 显示 Tab 页编号
                    filename = filename ~= '' and filename or '[No Name]' -- 如果 buffer 没有名称

                    -- 将高亮和标签拼接，并添加分隔符
                    local tab_label = hl .. tab_number .. filename
                    if i < total_tabs then
                        tab_label = tab_label .. '%#TabLineSeparator# ' -- 添加分隔符
                    else
                        tab_label = tab_label .. ' ' -- 最后一个标签后加空格
                    end

                    table.insert(tabs, tab_label)
                end

                return table.concat(tabs, '') .. '%#TabLineFill#'
            end,
        },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' }
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

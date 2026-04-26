require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox_light',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
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
                    local filename = vim.fn.fnamemodify(buf_name, ':t')

                    local hl = (i == current_tab) and '%#TabLineSel#' or '%#TabLine#'
                    local tab_number = string.format(' %d ', i)
                    filename = filename ~= '' and filename or '[No Name]'

                    local tab_label = hl .. tab_number .. filename
                    if i < total_tabs then
                        tab_label = tab_label .. '%#TabLineSeparator#  '
                    else
                        tab_label = tab_label .. '  '
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

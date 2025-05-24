local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    -- vim.api.nvim_set_keymap('n', 'NT', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

    -- Custom mapping to open a file in a new tab
    vim.keymap.set('n', 't', api.node.open.tab, opts('Open in New Tab'))
end

-- Automatically open NvimTree when entering a Tab and focus on the file window
vim.api.nvim_create_autocmd({ "VimEnter", "TabNewEntered" }, {
    callback = function()
        local api = require "nvim-tree.api"
        if not api.tree.is_visible() then
            api.tree.open()
            api.tree.find_file()
            vim.defer_fn(function()
                vim.cmd("wincmd l")
            end, 10)
        end
    end,
})

-- Before switching to a new tab, ensure the focus is on the file window
vim.api.nvim_create_autocmd("TabLeave", {
    callback = function()
        local api = require "nvim-tree.api"
        if api.tree.is_visible() then
            vim.cmd("wincmd l")
        end
    end,
})

-- When entering a new tab, ensure the focus is on the file window
vim.api.nvim_create_autocmd("TabEnter", {
    callback = function()
        local api = require "nvim-tree.api"
        -- If the focus is on NvimTree, move it to the file window
        if api.tree.is_visible() then
            vim.cmd("wincmd l")
        end
    end,
})

-- Automatically close NvimTree when the last file in a tab is closed
vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function()
        vim.defer_fn(function()
            local current_tab_wins = vim.api.nvim_tabpage_list_wins(0)

            if #current_tab_wins == 1 then
                local last_win = current_tab_wins[1]
                local buf_ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(last_win), "filetype")

                if buf_ft == "NvimTree" then
                    vim.cmd("quit")
                end
            end
        end, 10)
    end,
})


-- Pass to setup along with your other options
require("nvim-tree").setup {
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    on_attach = my_on_attach,
}

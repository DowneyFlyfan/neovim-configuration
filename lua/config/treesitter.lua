require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "latex" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    highlight = {
        enable = true,

        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files or specific languages
        disable = function(lang, buf)
            --[[
            if lang == "latex" then
                return true
            end
            --]]

            -- Disable for large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end

            return false
        end,

        additional_vim_regex_highlighting = { "latex", "markdown" },

    },

    -- Add modules table to satisfy the required field check
    modules = {},
}

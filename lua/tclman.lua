local Popup = require("nui.popup")
local M = {}

M.cache_dir = vim.fn.expand("~/.cache/nvim/tclman/")
if vim.fn.isdirectory(M.cache_dir) == 0 then vim.fn.mkdir(M.cache_dir, "p") end

function M.get_man_content(keyword)
    -- 1. Check local cache (User imported manuals)
    local cache_file = M.cache_dir .. keyword
    if vim.fn.filereadable(cache_file) == 1 then
        return table.concat(vim.fn.readfile(cache_file), "\n")
    end
    
    local cache_txt = M.cache_dir .. keyword .. ".txt"
    if vim.fn.filereadable(cache_txt) == 1 then
        return table.concat(vim.fn.readfile(cache_txt), "\n")
    end

    -- 2. Check Standard Tcl Man pages (Section 'n')
    -- 'man -P cat n keyword'
    local handle = io.popen(string.format("man -P cat n %s 2>/dev/null | col -b", keyword))
    local content = handle:read("*a")
    handle:close()
    
    if content and content ~= "" and not string.find(content, "No manual entry") then
        return content
    end

    -- 3. Check General Man pages
    handle = io.popen(string.format("man -P cat %s 2>/dev/null | col -b", keyword))
    content = handle:read("*a")
    handle:close()

    if content and content ~= "" and not string.find(content, "No manual entry") then
        return content
    end

    return nil
end

function M.open_man(keyword)
    local content = M.get_man_content(keyword)
    local filetype = "man"

    if not content then
        content = string.format([[
MANUAL NOT FOUND: %s

1. Standard Tcl: It might not be installed or in MANPATH.
   Try: 'brew install tcl-tk'

2. EDA Commands (Synopsys/Cadence):
   These manuals are proprietary and NOT on your Mac by default.
   
   SOLUTION:
   You must copy the manuals from your server to:
   %s
   
   [Command to run on Server]:
   man %s | col -b > %s.txt
   (Then copy that .txt file to your Mac's cache folder above)

3. Press 's' to Search Google for '%s'
]], keyword, M.cache_dir, keyword, keyword, keyword)
        filetype = "text"
    end

    local popup = Popup({
        enter = true, focusable = true,
        border = { style = "rounded", text = { top = " " .. keyword .. " ", top_align = "center" } },
        position = "50%", size = { width = "80%", height = "70%" },
        buf_options = { modifiable = true, readonly = false },
    })

    popup:mount()
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, vim.split(content, "\n"))
    vim.api.nvim_buf_set_option(popup.bufnr, "filetype", filetype)
    vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(popup.bufnr, "readonly", true)

    -- Keymaps
    vim.keymap.set("n", "q", function() popup:unmount() end, { buffer = popup.bufnr })
    vim.keymap.set("n", "<Esc>", function() popup:unmount() end, { buffer = popup.bufnr })
    
    -- Search Google Shortcut
    vim.keymap.set("n", "s", function()
        local url = "https://www.google.com/search?q=" .. keyword .. "+tcl"
        if string.match(keyword, "[A-Z]") then -- Heuristic: MixedCase is often EDA
             url = "https://www.google.com/search?q=" .. keyword .. "+eda+command"
        end
        vim.fn.system({"open", url})
        popup:unmount()
    end, { buffer = popup.bufnr })
end

function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tcl",
        callback = function()
            vim.keymap.set("n", "gh", function()
                local word = vim.fn.expand("<cword>")
                M.open_man(word)
            end, { buffer = true, desc = "Open TCL Man" })
        end,
    })
end

return M
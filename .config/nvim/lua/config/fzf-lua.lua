local fzf_lua = require('fzf-lua')

local function tabedit_and_wipe(selected, opts)
    require("fzf-lua.actions").file_tabedit(selected, opts)
    vim.bo.bufhidden = "wipe"
end

fzf_lua.setup({
    files = {
        actions = {
            ["default"] = tabedit_and_wipe,
        },
    },
})

vim.keymap.set("n", "<Space>s", require('fzf-lua').files, { desc = "Fzf Files" })

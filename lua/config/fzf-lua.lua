local fzf_lua = require('fzf-lua')

fzf_lua.setup({
    files = {
        actions = {
            ["default"] = require("fzf-lua.actions").file_tabedit,
        },
    },
})

vim.keymap.set("n", "<Space>s", require('fzf-lua').files, { desc = "Fzf Files" })

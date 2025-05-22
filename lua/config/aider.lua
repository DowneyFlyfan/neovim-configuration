require('aider').setup({
    auto_manage_context = false, -- 用户希望手动管理上下文
    default_bindings = false,    -- 用户希望使用自定义按键映射
    debug = true,
    vim = true,
    notification = true,
    ignore_buffers = {},
    border = {
        style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        color = "#fab387",
    },
})

-- Removed 'local' to make the function globally accessible as requested
function open_aider_with_conditional_prompt(model, editor_model)
    local command = string.format(
        "AiderOpen --model %s" ..
        " --architect" ..
        " --editor-model %s" ..
        " --watch-files" ..
        " --notifications" ..
        " --no-gitignore" ..
        " --cache-prompts" ..
        " --no-stream",
        model,
        editor_model
    )

    vim.cmd(command)
    vim.cmd("vertical resize 65")
end

function _G.run_aider_in_terminal()
    vim.cmd('vsplit | terminal')

    vim.defer_fn(function()
        vim.api.nvim_input("aaider<CR>")
    end, 700)

    vim.defer_fn(function()
        vim.cmd('q')
    end, 800)

end

vim.api.nvim_set_keymap('n', '<D-l>',
    '<Cmd>lua open_aider_with_conditional_prompt("gemini-2.5-pro-preview-05-06", "gemini-2.5-flash-preview-04-17")<CR>',
    { noremap = true, silent = true, desc = "Aider (Best Model)" })

vim.api.nvim_set_keymap('n', '<D-k>',
    '<cmd>lua run_aider_in_terminal()<CR>',
    { noremap = true, silent = true, desc = "Run Aider in Browser" })

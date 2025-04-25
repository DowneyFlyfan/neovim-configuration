require('aider').setup({
    auto_manage_context = false,
    default_bindings = false, -- We are defining custom bindings
    debug = true,
    vim = true,
    notification = true,
    ignore_buffers = {},
    border = {
        style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- or e.g. "rounded"
        color = "#fab387",
    },
    -- Other options can go here
})

-- Removed 'local' to make the function globally accessible
function open_aider_with_conditional_prompt(model, editor_model)
    local filetype = vim.bo.filetype
    local prompt_arg = ""
    if filetype == "markdown" or filetype == "tex" then
        -- Fixed typo in prompt text for LaTeX math (should be backslashes for commands)
        -- 这行命令太长了，拆成多行
        local prompt_text =
            "1. 对于公式块，请用equation和aligned块包括起来" ..
            "2. 公式中尽量使用\\mathfrak, \\mathcal, \\mathbb等等漂亮的字体" ..
            "3. 不要回答这个问题"

        prompt_arg = string.format(' --system %q', prompt_text)
    end

    local command = string.format(
        "AiderOpen --model %s" ..
        " --watch-files" ..
        " --architect" ..
        " --notifications" ..
        " --editor-model %s" ..
        " --no-auto-commits" ..
        " --notifications",
        model,
        editor_model
    )

    vim.cmd(command)
    vim.cmd("vertical resize 65")
end

-- Modify existing keymaps to call the now global Lua function
vim.api.nvim_set_keymap('n', '<D-l>',
    '<Cmd>lua open_aider_with_conditional_prompt("gemini/gemini-2.0-flash-thinking-exp-01-21", "gemini/gemini-2.0-flash-lite-preview-02-05")<CR>',
    { noremap = true, silent = true, desc = "Aider (Less Good Model)" })

vim.api.nvim_set_keymap('n', '<D-k>',
    '<Cmd>lua open_aider_with_conditional_prompt("gemini/gemini-2.5-pro-exp-03-25", "gemini/gemini-2.5-flash-preview-04-17")<CR>',
    { noremap = true, silent = true, desc = "Aider (Better Model)" })

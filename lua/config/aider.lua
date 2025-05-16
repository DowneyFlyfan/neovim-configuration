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
    local filetype = vim.bo.filetype
    local prompt_text_to_add = ""

    if filetype == "markdown" or filetype == "tex" then
        prompt_text_to_add = [[
1. 对于公式块，请用equation和aligned块包括起来。
2. 公式中尽量使用\\mathfrak, \\mathcal, \\mathbb等等漂亮的字体。
3. 不要回答这个问题，直接修改代码/文本。
]]
    end

    local command = string.format(
        "AiderOpen --model %s" ..
        " --architect" ..
        " --editor-model %s" ..
        " --watch-files" ..
        " --notifications" ..
        " --no-gitignore",
        model,
        editor_model
    )

    if prompt_text_to_add ~= "" then
        command = command .. string.format(' --prompt %s', vim.fn.shellescape(prompt_text_to_add))
    end

    vim.cmd(command)
    vim.cmd("vertical resize 65")
end

vim.api.nvim_set_keymap('n', '<D-l>',
    '<Cmd>lua open_aider_with_conditional_prompt("gemini-2.5-pro-preview-05-06", "gemini-2.5-flash-preview-04-17")<CR>',
    { noremap = true, silent = true, desc = "Aider (Best Model)" })

vim.api.nvim_set_keymap('n', '<D-k>',
    '<Cmd>lua open_aider_with_conditional_prompt("gemini/gemini-2.5-pro-exp-03-25", "gemini/gemini-2.5-flash-preview-04-17")<CR>',
    { noremap = true, silent = true, desc = "Aider (Backup Model)" })

# My Neovim Configuration

This repository contains my personal Neovim configuration. It's built using Lua and leverages `lazy.nvim` for plugin management. The setup is tailored for development in various languages including Python, C/C++, Lua, MATLAB, TeX, and web technologies, incorporating LSP, debugging, AI assistance, and other modern Neovim features.

## Features

*   **Plugin Management:** Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for declarative plugin management.
*   **LSP Integration:** Configured via [mason.nvim](https://github.com/williamboman/mason.nvim) and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig). Includes automatic installation of LSPs, formatters, and debug adapters.
    *   Signature help via [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim).
    *   Formatting via [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) (using tools like Prettier, stylua, texfmt, black) and LSP formatters. Auto-formatting on save is enabled.
*   **Debugging:** Integrated debugging support using [nvim-dap](https://github.com/mfussenegger/nvim-dap) and [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui). Adapters for Python, C/C++, and Bash are configured via Mason.
*   **Syntax Highlighting & More:** Enhanced syntax highlighting, folding, and code structure analysis using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
*   **Autocompletion:** Powered by [nvim-cmp](https://github.com/hrshshth/nvim-cmp) with sources for LSP, buffer, path, command line, and snippets ([LuaSnip](https://github.com/L3MON4D3/LuaSnip)).
*   **Fuzzy Finding:** Uses [fzf-lua](https://github.com/ibhagwan/fzf-lua) for fast file searching, buffer switching, etc.
*   **Git Integration:** Enhanced git signs and operations in the gutter via [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim).
*   **AI Assistance:**
    *   Integrated AI coding assistant via [aider.nvim](https://github.com/joshuavial/aider.nvim).
    *   Custom AI prompts via [CodeCompanion.nvim](https://github.com/CodeCompanionAI/CodeCompanion.nvim) (using Deepseek models for explanation and optimization - configuration visible in `Archive/codecompanion.lua`).
*   **Language Specifics:**
    *   **Python:** Pyright LSP, Black formatter, DAP configuration, custom keymaps (`<C-e>` to run, debug keymaps).
    *   **C/C++:** Clangd LSP, DAP configuration, custom keymaps (`<C-e>` to run). `.cu`/`.cuh` files recognized.
    *   **Lua:** lua_ls LSP.
    *   **MATLAB:** MATLAB Language Server LSP, custom keymaps (`<C-e>` to run).
    *   **TeX:** VimTeX plugin, TexLab LSP, texfmt formatter, specific editor settings (wrapping, text width).
    *   **Web Dev:** LSPs for HTML, CSS, TypeScript/JavaScript. Prettier formatter. Colorizer for CSS colors.
    *   **Verilog:** Verible LSP.
*   **Markdown:** Preview ([markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)), inline rendering ([render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)), Mind Map generation ([markmap.nvim](https://github.com/Zeioth/markmap.nvim)).
*   **UI Enhancements:**
    *   [Gruvbox](https://github.com/morhetz/gruvbox) theme (light background).
    *   [Lualine](https://github.com/nvim-lualine/lualine.nvim) status line. [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for icons.
    *   Relative line numbers, cursor line highlighting.
    *   Persistent undo via [undotree](https://github.com/mbbill/undotree).
    *   Automatic parenthesis/pair completion via [nvim-autopairs](https://github.com/windwp/nvim-autopairs).

## Installation

1.  **Backup:** Backup your existing Neovim configuration (`~/.config/nvim`).
2.  **Clone:** Clone this repository to `~/.config/nvim`:
    ```bash
    git clone <repository_url> ~/.config/nvim
    ```
3.  **Launch Neovim:** Open Neovim (`nvim`). `lazy.nvim` should automatically bootstrap itself and install all the plugins.
4.  **Dependencies:** Ensure you have the necessary external dependencies installed:
    *   Neovim (latest stable or nightly recommended).
    *   Git.
    *   Python 3.12 (specifically configured for Pyright and running Python files).
    *   Node.js and Yarn (for `markdown-preview.nvim` and `markmap.nvim`).
    *   A C/C++ compiler (like GCC or Clang) for `clangd` and `nvim-treesitter` C parser.
    *   Optionally, install debuggers (`cppdbg`, `bash-debug-adapter`) if not managed by `mason-nvim-dap`.
    *   Any linters or formatters you wish to use if not managed by `mason-null-ls`.

## Keybindings

This is not an exhaustive list, but highlights some important custom bindings:

### General Navigation & Editing

*   `<Space>h/j/k/l`: Navigate window splits.
*   `<Space>1-9`: Switch to tab number 1-9.
*   `<Down>`/`<Up>`: Resize window height.
*   `<Left>`/`<Right>`: Resize window width.
*   `H`/`L`: Move cursor to start/end of line (Normal mode).
*   `J`/`K`: Move cursor 5 lines down/up (Normal & Visual mode).
*   `<Space>]`: Clear search highlighting (`:nohlsearch`).
*   `UD`: Toggle Undotree window.
*   `fm`: Format buffer using LSP (Normal mode). (Also runs automatically on save).

### LSP & Diagnostics

*   `gd`: Go to definition.
*   `gD`: Go to declaration.
*   `<C-h>`: Show hover documentation/information (Normal mode).
*   `gi`: Go to implementation.
*   `gr`: Show references.
*   `<space>ca`: Show code actions.
*   `<space>D`: Go to type definition.
*   `[d`/`]d`: Go to previous/next diagnostic.
*   `<space>e`: Show line diagnostics in floating window.
*   `<space>q`: Show diagnostics in location list.

### Debugging (nvim-dap - Python specific example)

*   `<M-c>`: Continue execution.
*   `<M-i>`: Step into.
*   `<M-o>`: Step over.
*   `<M-b>`: Toggle breakpoint.

### Language Specific

*   `<C-e>`: Compile/Run current file (Python, C/C++, MATLAB).

### Plugins

*   **FZF:** Standard `fzf-lua` keybindings (e.g., `:FzfLua files`, `:FzfLua buffers`).
*   **Aider:** Default `aider.nvim` bindings (e.g., `<leader>aa`, `<leader>ac`, etc.).
*   **Markmap:** `<Space>o`: Open Markmap for current Markdown file.
*   **CodeCompanion:** Custom prompts accessible via CodeCompanion commands/picker (check `Archive/codecompanion.lua` for prompt details).

## Demo

[观看演示视频](REPLACE_WITH_VIDEO_URL)

## Configuration Structure

*   `init.lua`: Entry point, loads core modules.
*   `lua/basic_settings.lua`: Core Neovim options and general keybindings.
*   `lua/Plugins.lua`: Plugin specifications using `lazy.nvim`.
*   `lua/lsp.lua`: LSP, formatter (`null-ls`), and debugger (`nvim-dap`) configurations.
*   `lua/config/`: Directory containing detailed configuration files for specific plugins (e.g., `nvim-cmp.lua`, `treesitter.lua`, `vimtex.lua`).
*   `lua/Languages/`: Directory containing language-specific settings and functions (e.g., `python.lua`, `c.lua`, `matlab.lua`).
*   `Archive/`: Contains archived or potentially less frequently used configurations like `codecompanion.lua`.

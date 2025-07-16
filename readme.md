# My Neovim Configuration

This repository contains my personal Neovim configuration. It's built using Lua and leverages `lazy.nvim` for plugin management. The setup is tailored for development in various languages including **Python, C/C++, CUDA, Lua, MATLAB, TeX, Verilog/SystemVerilog, Shell, Html, JavaScript and CSS**, incorporating **LSP, Treesitter debugging, Formatter, AI assistance and more**.

## Features

| Category          | Feature/Item              | Description/Details                                                                                                                                                                             | Keybinding (Normal Mode) | Related Files/Config                               |
| :---------------- | :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------- | :------------------------------------------------- |
| **Core Setup**    | Plugin Management         | Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for declarative plugin management.                                                                                                 |                          | `lua/Plugins.lua`                                  |
|                   | Entry Point               | Main entry point, loads core modules.                                                                                                                                                   |                          | `init.lua`                                         |
|                   | Basic Settings            | Core Neovim options and general keybindings.                                                                                                                                            |                          | `lua/basic_settings.lua`                           |
|                   | Plugin Config Directory   | Directory containing detailed configuration files for specific plugins.                                                                                                                 |                          | `lua/config/`                                      |
|                   | Language Config Directory | Directory containing language-specific settings and functions.                                                                                                                          |                          | `lua/Languages/`                                   |
|                   | Archived Config           | Contains archived or potentially less frequently used configurations.                                                                                                                   |                          | `Archive/`                                         |
| **Language Server** | LSP Integration           | Configured via [mason.nvim](https://github.com/williamboman/mason.nvim) and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig). Includes automatic installation of LSPs, formatters, and debug adapters. |                          | `lua/lsp.lua`                                      |
|                   | Signature Help            | Provides signature help. Plugin: [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim).                                                                                   |                          |                                                    |
|                   | Formatting                | Uses [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) (Prettier, stylua, texfmt, black) and LSP formatters. Auto-formatting on save is enabled.                      | `fm`                     | `lua/lsp.lua`                                      |
|                   | Go to Definition          | Jump to the definition of a symbol.                                                                                                                                                     | `gd`                     |                                                    |
|                   | Go to Declaration         | Jump to the declaration of a symbol.                                                                                                                                                    | `gD`                     |                                                    |
|                   | Show Hover Documentation  | Display documentation/information under cursor.                                                                                                                                         | `<C-h>`                  |                                                    |
|                   | Go to Implementation      | Jump to the implementation of a symbol.                                                                                                                                                 | `gi`                     |                                                    |
|                   | Show References           | Display references to a symbol.                                                                                                                                                         | `gr`                     |                                                    |
|                   | Show Code Actions         | Display available code actions.                                                                                                                                                         | `<space>ca`              |                                                    |
|                   | Go to Type Definition     | Jump to the type definition of a symbol.                                                                                                                                                | `<space>D`               |                                                    |
|                   | Next/Previous Diagnostic  | Navigate between diagnostic messages.                                                                                                                                                   | `[d`/`]d`                 |                                                    |
|                   | Show Line Diagnostics     | Display diagnostics for the current line in a floating window.                                                                                                                          | `<space>e`               |                                                    |
|                   | Show Diagnostics List     | Display all diagnostics in the location list.                                                                                                                                           | `<space>q`               |                                                    |
| **Debugging**     | nvim-dap Integration      | Integrated debugging support using [nvim-dap](https://github.com/mfussenegger/nvim-dap) and [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui). Adapters for Python, C/C++, and Bash are configured via Mason. |                          | `lua/lsp.lua`                                      |
|                   | Continue Execution        | Continue program execution in the debugger.                                                                                                                                             | `<M-c>`                  |                                                    |
|                   | Step Into                 | Step into the next function call.                                                                                                                                                       | `<M-i>`                  |                                                    |
|                   | Step Over                 | Step over the current line/function.                                                                                                                                                    | `<M-o>`                  |                                                    |
|                   | Toggle Breakpoint         | Set or clear a breakpoint at the current line.                                                                                                                                          | `<M-b>`                  |                                                    |
|                   | Run/Compile Current File  | Run or compile the current file (Python, C/C++, MATLAB).                                                                                                                                | `<C-e>`                  | `lua/Languages/python.lua`, `lua/Languages/c.lua`, `lua/Languages/matlab.lua` |
| **Code Structure**| Syntax Highlighting       | Enhanced syntax highlighting, folding, and code structure analysis using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).                                      |                          | `lua/config/treesitter.lua`                        |
|                   | Autocompletion            | Powered by [nvim-cmp](https://github.com/hrshshth/nvim-cmp) with sources for LSP, buffer, path, command line, and snippets ([LuaSnip](https://github.com/L3MON4D3/LuaSnip)).         |                          | `lua/config/nvim-cmp.lua`                          |
| **Navigation/Search**| Fuzzy Finding             | Uses [fzf-lua](https://github.com/ibhagwan/fzf-lua) for fast file searching, buffer switching, etc.                                                                                     |                          |                                                    |
|                   | Clear Search Highlighting | Clears the highlighting of search results.                                                                                                                                              | `<Space>]`                |                                                    |
|                   | Navigate Window Splits    | Navigate between open window splits.                                                                                                                                                    | `<Space>h/j/k/l`         |                                                    |
|                   | Switch Tabs               | Switch to a specific tab number.                                                                                                                                                        | `<Space>1-9`             |                                                    |
|                   | Resize Window Height      | Resize the height of the current window.                                                                                                                                                | `<Down>`/`<Up>`          |                                                    |
|                   | Resize Window Width       | Resize the width of the current window.                                                                                                                                                 | `<Left>`/`<Right>`       |                                                    |
|                   | Move Cursor (Line)        | Move cursor to start/end of line.                                                                                                                                                       | `H`/`L`                  |                                                    |
|                   | Move Cursor (5 Lines)     | Move cursor 5 lines down/up.                                                                                                                                                            | `J`/`K`                  |                                                    |
| **Git Integration**| Git Signs & Operations    | Enhanced git signs and operations in the gutter via [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim).                                                                      |                          |                                                    |
| **AI Assistance** | Aider Integration         | Directly access `aider` in your browser.                                                                                                                                                | `<D-k>`                  |                                                    |
|                   | Neovim AI Assistance       | Provided by [avante.nvim](https://github.com/yetone/avante.nvim).                                                                                                                       |                          |                                                    |
| **Language Specifics**| Python                    | Pyright LSP, Black formatter, DAP configuration, custom keymaps.                                                                                                                        | `<C-e>` (Run/Debug)      | `lua/Languages/python.lua`                         |
|                   | C/C++                     | Clangd LSP, DAP configuration, custom keymaps. `.cu`/`.cuh` files recognized.                                                                                                           | `<C-e>` (Run)            | `lua/Languages/c.lua`                              |
|                   | Lua                       | `lua_ls` LSP.                                                                                                                                                                           |                          |                                                    |
|                   | MATLAB                    | MATLAB Language Server LSP, custom keymaps.                                                                                                                                             | `<C-e>` (Run)            | `lua/Languages/matlab.lua`                         |
|                   | TeX                       | [VimTeX](https://github.com/lervag/vimtex) plugin, TexLab LSP, texfmt formatter, specific editor settings (wrapping, text width).                                                       |                          | `lua/config/vimtex.lua`                            |
|                   | Web Development           | LSPs for HTML, CSS, TypeScript/JavaScript. Prettier formatter. Colorizer for CSS colors.                                                                                                |                          |                                                    |
|                   | Verilog                   | Verible LSP.                                                                                                                                                                            |                          |                                                    |
| **Markdown Tools**| Markdown Preview          | Live preview for Markdown files. Plugin: [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim).                                                                      |                          |                                                    |
|                   | Inline Rendering          | Inline rendering of Markdown. Plugin: [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim).                                                             |                          |                                                    |
|                   | Mind Map Generation       | Generate Mind Maps from Markdown. Plugin: [markmap.nvim](https://github.com/Zeioth/markmap.nvim).                                                                                        | `<Space>o`               |                                                    |
| **UI Enhancements**| Theme                     | [Gruvbox](https://github.com/morhetz/gruvbox) theme (light background).                                                                                                                 |                          |                                                    |
|                   | Status Line               | [Lualine](https://github.com/nvim-lualine/lualine.nvim) status line. [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for icons.                                   |                          |                                                    |
|                   | Relative Line Numbers     | Display relative line numbers.                                                                                                                                                          |                          | `lua/basic_settings.lua`                           |
|                   | Cursor Line Highlighting  | Highlight the current cursor line.                                                                                                                                                      |                          | `lua/basic_settings.lua`                           |
|                   | Persistent Undo           | Persistent undo history. Plugin: [undotree](https://github.com/mbbill/undotree).                                                                                                      | `UD`                     |                                                    |
|                   | Auto Pair Completion      | Automatic parenthesis/pair completion. Plugin: [mini.nvim](https://github.com/echasnovsk/mini.nvim).                                                                                  |                          |                                                    |
 
## Installation

1.  **Backup:** Backup your existing Neovim configuration (`~/.config/nvim`).
2.  **Clone:** Clone this repository to `~/.config/nvim`:
    ```bash
    git clone https://github.com/DowneyFlyfan/neovim-configuration ~/.config/nvim
    ```

3.  **Dependencies:** Ensure you have the necessary external dependencies installed before using this configuration:

    | Item | Description |
    |---|---|
    | Neovim | Latest stable or nightly recommended. |
    | Ranger | For `UndoTree` |
    | `ripgrep` | For `UndoTree` and `todo-comments` |
    | Git | |
    | Python | Specifically configured for Pyright and running Python files. |
    | Node.js, Tree-sitter-cli, Yarn | Required for `markdown-preview.nvim`, `nvim-treesitter`, `markmap.nvim`. Remember to `npm install -g tree-sitter-cli yarn`. |
    | `clangd` lsp | Install `llvm` and `nvim-treesitter` C parser. |
    | Debuggers | Optionally, install `cppdbg`, `bash-debug-adapter` if not managed by `mason-nvim-dap`. |
    | FZF | Installing `fzf` on your system|
    | Rust |`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| source "$HOME/.cargo/env"`, for compling `avante.nvim`|


4. **Launch Neovim:** Open Neovim (`nvim`). `lazy.nvim` should automatically bootstrap itself and install all the plugins.

## Keybindings

***This is not an exhaustive list***, but highlights some important custom bindings:

### General Navigation & Editing

| Keybinding | Description |
|---|---|
| `<Space>h/j/k/l` | Navigate window splits |
| `<Space>1-9` | Switch to tab number 1-9 |
| `<Down>`/`<Up>` | Resize window height |
| `<Left>`/`<Right>` | Resize window width |
| `H`/`L` | Move cursor to start/end of line (Normal mode) |
| `J`/`K` | Move cursor 5 lines down/up (Normal & Visual mode) |
| `<Space>]` | Clear search highlighting (`:nohlsearch`) |
| `UD` | Toggle Undotree window |
| `fm` | Format buffer using LSP (Normal mode). (Also runs automatically on save) |
| `<Space>o` | Open Markmap for current Markdown file |

### LSP & Diagnostics

| Keybinding | Description |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `<C-h>` | Show hover documentation/information (Normal mode) |
| `gi` | Go to implementation |
| `gr` | Show references |
| `<space>ca` | Show code actions |
| `<space>D` | Go to type definition |
| `[d`/`]d` | Go to previous/next diagnostic |
| `<space>e` | Show line diagnostics in floating window |
| `<space>q` | Show diagnostics in location list |

### Debugging (nvim-dap - Python specific example)

| Keybinding | Description |
|---|---|
| `<M-c>` | Continue execution |
| `<M-i>` | Step into |
| `<M-o>` | Step over |
| `<M-b>` | Toggle breakpoint |
|`<C-e>`| Compile/Run current file (Python, C/C++, MATLAB)|

## Configuration Structure

| File/Directory | Description |
|---|---|
| `init.lua` | Entry point, loads core modules. |
| `lua/basic_settings.lua` | Core Neovim options and general keybindings. |
| `lua/Plugins.lua` | Plugin specifications using `lazy.nvim`. |
| `lua/lsp.lua` | LSP, formatter (`null-ls`), and debugger (`nvim-dap`) configurations. |
| `lua/config/` | Directory containing detailed configuration files for specific plugins (e.g., `nvim-cmp.lua`, `treesitter.lua`, `vimtex.lua`). |
| `lua/Languages/` | Directory containing language-specific settings and functions (e.g., `python.lua`, `c.lua`, `matlab.lua`). |
| `Archive/` | Contains archived or potentially less frequently used configurations like `codecompanion.lua`. |

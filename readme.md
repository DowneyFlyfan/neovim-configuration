# My Neovim Configuration

This repository contains my personal Neovim configuration. It's built using Lua and leverages `lazy.nvim` for plugin management. The setup is tailored for development in various languages including **Python, C/C++, Rust, CUDA, Lua, MATLAB, TeX, Verilog/SystemVerilog, Shell, HTML, JavaScript, and CSS**, incorporating **LSP, Treesitter, Debugging, Formatting, AI assistance, and more**.

## Installation

1.  **Backup:** Backup your existing Neovim configuration (`~/.config/nvim`).
2.  **Clone:** Clone this repository to `~/.config/nvim`:
    ```bash
    git clone https://github.com/DowneyFlyfan/neovim-configuration ~/.config/nvim
    ```

3.  **External Dependencies:** Ensure you have the necessary external dependencies installed:

    | Item | Description |
    |---|---|
    | **Neovim** | Latest stable or nightly recommended (v0.10+). |
    | **Git** | Required for plugin management. |
    | **Node.js, Yarn** | Required for `markdown-preview.nvim`, `markmap.nvim`, and various LSPs/Formatters. |
    | **Ripgrep** | Required for `fzf-lua`, `todo-comments`, and `gitsigns`. |
    | **fd** | Recommended for `fzf-lua`. |
    | **Python 3** | Required for Python development and some plugins. |
    | **Rust** | Required for compiling `avante.nvim` (if building from source). |
    | **C/C++ Compiler** | `clang` or `gcc` for compiling Treesitter parsers. |
    | **runc** | Custom script/command expected for running C/C++ files (referenced in `lua/Languages/c.lua`). |

4.  **LSP & Tool Dependencies:** Most tools are managed via `mason.nvim`, but some require system-level installation:
    *   **Python:** Ensure `python3` and `pip` are available.
    *   **C/C++:** `clangd` (via Mason or system LLVM).

5.  **Launch Neovim:** Open Neovim (`nvim`). `lazy.nvim` will automatically bootstrap and install all configured plugins.

## Features

### 🔌 Core & Plugin Management
*   **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and declarative plugin management.
*   **Theme:** [Gruvbox](https://github.com/morhetz/gruvbox) (configured for light background).
*   **Icons:** `nvim-web-devicons` for file icons.

### 🧠 Language Server Protocol (LSP) & Formatting
*   **LSP Management:** [mason.nvim](https://github.com/williamboman/mason.nvim) and [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) for easy installation of LSPs.
*   **Configured LSPs:** `pyright`, `clangd`, `lua_ls`, `matlab_ls`, `texlab`, `html`, `cssls`, `ts_ls`, `bashls`, `rust_analyzer`, `svlangserver`, `asm_lsp`.
*   **Formatting:** [conform.nvim](https://github.com/stevearc/conform.nvim) handles formatting with `format_on_save` enabled.
    *   *Formatters:* `stylua`, `black`, `prettierd`, `tex-fmt`, `verible`, `beautysh`, `clang-format`.
*   **Signature Help:** [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim).

### 🐛 Debugging (DAP)
*   **Manager:** `mason-nvim-dap.nvim`.
*   **Interface:** [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui).
*   **Adapters:** Python, C/C++ (`cppdbg`), Bash.

### 🤖 AI Assistance
*   **Avante.nvim:** AI coding assistant powered by **Gemini 3 Flash Preview**.
    *   Chat, apply diffs, and generate code directly in Neovim.

### 📝 Editing Enhancements (Mini.nvim)
Leverages [mini.nvim](https://github.com/echasnovski/mini.nvim) modules for a cohesive editing experience:
*   **mini.surround:** Manage surroundings (parentheses, quotes, etc.).
*   **mini.pairs:** Auto-close pairs.
*   **mini.comment:** Fast commenting.
*   **mini.align:** Align text interactively.
*   **mini.move:** Move lines/blocks of text.
*   **mini.operators:** Text editing operators (replace, exchange, sort, multiply).

### 📂 Navigation & Search
*   **Fuzzy Finder:** [fzf-lua](https://github.com/ibhagwan/fzf-lua) for files, buffers, git, grep, etc.
*   **Undo History:** [undotree](https://github.com/mbbill/undotree) for visualizing undo history.
*   **Multiple Cursors:** `vim-multiple-cursors`.
*   **File Explorer:** (Native Netrw or Fzf-lua are used; nvim-tree is in Archive).

### 📄 Markdown & Notes
*   **Preview:** [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) (browser preview).
*   **Rendering:** [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) (inline styling).
*   **Mind Maps:** [markmap.nvim](https://github.com/Zeioth/markmap.nvim) for visualizing Markdown as mind maps.
*   **Obsidian:** [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) for knowledge base management.

### 🌲 Syntax & Highlights
*   **Treesitter:** Advanced syntax highlighting and context.
*   **Colorizer:** `nvim-colorizer.lua` for showing hex colors.
*   **Git:** `gitsigns.nvim` for git status in the gutter.

## Keybindings

### General
| Key | Description |
|---|---|
| `<Space>h/j/k/l` | Navigate splits |
| `<Space>1-9` | Switch to Tab 1-9 |
| `<Down>/<Up>` | Resize height |
| `<Left>/<Right>` | Resize width |
| `<Space>]` | Clear search highlights |
| `UD` | Toggle UndoTree |
| `<C-n>` | Find Under (Visual Multi - *Disabled/Configured*) |

### LSP & Diagnostics
| Key | Description |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `<C-h>` | Hover documentation |
| `<Space>ca` | Code Actions |
| `<Space>rn` | Rename (if configured) |
| `<Space>f` | Format file (Conform) |
| `<Space>e` | Show line diagnostics (float) |
| `<Space>q` | Show diagnostics (loclist) |
| `[d` / `]d` | Previous/Next diagnostic |

### Editing (Mini.nvim & Operators)
| Key | Description |
|---|---|
| `g=` + motion | Evaluate text (mini.operators) |
| `gx` + motion | Exchange text regions (mini.operators) |
| `gm` + motion | Multiply (duplicate) text (mini.operators) |
| `gr` + motion | Replace text with register (mini.operators) |
| `gs` + motion | Sort text (mini.operators) |
| `Alt+h/j/k/l` | Move selected text (Visual Mode) |

### AI (Avante)
| Key | Description |
|---|---|
| `<Space>c` | Clear Avante chat |
| *(Plugin Default)* | `Leader+aa` (Open), `Leader+ae` (Edit), etc. |

### Running Code
| Key | Description |
|---|---|
| `<C-e>` | Run/Compile current file (Python, C/C++, MATLAB) |

### Markdown
| Key | Description |
|---|---|
| `<Space>o` | Open Markmap |

## File Structure

```text
~/.config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json           # Plugin lockfile
├── lua/
│   ├── basic_settings.lua   # General Neovim settings & keymaps
│   ├── Plugins.lua          # Plugin specifications (Lazy.nvim)
│   ├── lsp.lua              # LSP Core & Mason Setup
│   ├── config/              # Detailed Plugin Configurations
│   │   ├── conform.lua      # Formatting
│   │   ├── mini.lua         # Mini.nvim modules
│   │   ├── treesitter.lua   # Syntax highlighting
│   │   └── ...
│   └── Languages/           # Language-specific configurations
│       ├── python.lua
│       ├── c.lua
│       └── ...
└── Archive/                 # Unused configurations
```

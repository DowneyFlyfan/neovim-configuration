<h1 align="center">🚀 My Neovim Configuration</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Neovim-0.11+-57A143?style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim"/>
  <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua"/>
  <img src="https://img.shields.io/badge/lazy.nvim-8A2BE2?style=for-the-badge&logo=neovim&logoColor=white" alt="lazy.nvim"/>
  <img src="https://img.shields.io/badge/LSP-Enabled-blue?style=for-the-badge&logo=visualstudiocode&logoColor=white" alt="LSP"/>
  <img src="https://img.shields.io/badge/Treesitter-green?style=for-the-badge&logo=tree&logoColor=white" alt="Treesitter"/>
  <img src="https://img.shields.io/badge/AI-Claude%20Code-D97757?style=for-the-badge&logo=anthropic&logoColor=white" alt="Claude Code"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/C%2FC%2B%2B-00599C?style=flat-square&logo=cplusplus&logoColor=white" alt="C/C++"/>
  <img src="https://img.shields.io/badge/Rust-000000?style=flat-square&logo=rust&logoColor=white" alt="Rust"/>
  <img src="https://img.shields.io/badge/CUDA-76B900?style=flat-square&logo=nvidia&logoColor=white" alt="CUDA"/>
  <img src="https://img.shields.io/badge/Lua-2C2D72?style=flat-square&logo=lua&logoColor=white" alt="Lua"/>
  <img src="https://img.shields.io/badge/MATLAB-0076A8?style=flat-square&logo=mathworks&logoColor=white" alt="MATLAB"/>
  <img src="https://img.shields.io/badge/LaTeX-008080?style=flat-square&logo=latex&logoColor=white" alt="LaTeX"/>
  <img src="https://img.shields.io/badge/SystemVerilog-EE0000?style=flat-square&logo=verilog&logoColor=white" alt="SystemVerilog"/>
  <img src="https://img.shields.io/badge/Shell-4EAA25?style=flat-square&logo=gnubash&logoColor=white" alt="Shell"/>
  <img src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white" alt="HTML"/>
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JavaScript"/>
  <img src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white" alt="CSS"/>
  <img src="https://img.shields.io/badge/Markdown-000000?style=flat-square&logo=markdown&logoColor=white" alt="Markdown"/>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/DowneyFlyfan/neovim-configuration?style=social" alt="Stars"/>
  <img src="https://img.shields.io/github/forks/DowneyFlyfan/neovim-configuration?style=social" alt="Forks"/>
  <img src="https://img.shields.io/github/last-commit/DowneyFlyfan/neovim-configuration?style=flat-square" alt="Last Commit"/>
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square" alt="License: MIT"/>
</p>

---

This repository contains my personal Neovim configuration. It's built using Lua and leverages `lazy.nvim` for plugin management. The setup is tailored for development in various languages including **Python, C/C++, Rust, CUDA, Lua, MATLAB, TeX, Verilog/SystemVerilog, Assembly, TCL, Shell, HTML, JavaScript, CSS, and Markdown**, incorporating **LSP (Language Server Protocol), Treesitter, Debugging (DAP - Debug Adapter Protocol), Formatting, Linting, AI assistance, and more**.

## 📦 Installation

1.  **Backup:** Backup your existing Neovim configuration (`~/.config/nvim`).
2.  **Clone:** Clone this repository to `~/.config/nvim`:
    ```bash
    git clone https://github.com/DowneyFlyfan/neovim-configuration ~/.config/nvim
    ```

3.  **External Dependencies:** Ensure you have the necessary external dependencies installed:

    | Item | Description |
    |---|---|
    | **Neovim** | Latest stable or nightly recommended (v0.11+). |
    | **Git** | Required for plugin management. |
    | **Node.js, Yarn** | Required for `markdown-preview.nvim`, `markmap.nvim`, `mdmath.nvim`, and various LSPs/Formatters. |
    | **Ripgrep** | Required for `fzf-lua`, `todo-comments`, and `gitsigns`. |
    | **fzf** | Required for `fzf-lua`. |
    | **Python 3** | Required for Python development and some plugins. |
    | **Rust, cargo** | Required for `asm_lsp`. |
    | **C/C++ Compiler** | `clang` or `gcc` for compiling Treesitter parsers. |
    | **clangd** | For clangd LSP. |
    | **tree-sitter-cli** | For `nvim-treesitter`. |
    | **runc** | Custom script/command for running C/C++ files (referenced in `lua/Languages/c.lua`). |

4.  **LSP & Tool Dependencies:** Most tools are managed via `mason.nvim`, but some require system-level installation:
    *   **Python:** Ensure `python3` and `pip` are available.
    *   **C/C++:** `clangd` (via Mason or system LLVM).

5.  **Launch Neovim:** Open Neovim (`nvim`). `lazy.nvim` will automatically bootstrap and install all configured plugins.

## ✨ Features

### Core & Plugin Management
*   **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and declarative plugin management.
*   **Theme:** [Gruvbox](https://github.com/morhetz/gruvbox) (configured for light background).
*   **Statusline:** [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) for a customizable statusline.
*   **Icons:** `nvim-web-devicons` for file icons.
*   **Completion Pictograms:** [lspkind.nvim](https://github.com/onsails/lspkind.nvim) for VS Code-like pictograms in completion menus.

### Language Server Protocol (LSP) & Formatting
*   **LSP Management:** [mason.nvim](https://github.com/mason-org/mason.nvim) and [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) for easy installation of LSPs.
*   **Configured LSPs:** `pyright`, `clangd`, `lua_ls`, `matlab_ls`, `texlab`, `html`, `cssls`, `ts_ls`, `bashls`, `rust_analyzer`, `svlangserver`, `asm_lsp`, `marksman`, `tclsp`.
*   **Formatting:** [conform.nvim](https://github.com/stevearc/conform.nvim) handles formatting with `format_on_save` enabled.
    *   *Formatters:* `stylua`, `black`, `prettierd`, `tex-fmt`, `verible`, `beautysh`, `clang-format`, `rustfmt`, `asmfmt`.
*   **Linting:** [nvim-lint](https://github.com/mfussenegger/nvim-lint) for asynchronous linting.
*   **Signature Help:** [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim).
*   **Diagnostics:** [trouble.nvim](https://github.com/folke/trouble.nvim) for a pretty diagnostics list.

### Debugging (DAP - Debug Adapter Protocol)
*   **Manager:** `mason-nvim-dap.nvim`.
*   **Interface:** [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui).
*   **Adapters:** Python, C/C++ (`cppdbg`), Bash.

### AI Assistance
*   **CodeCompanion.nvim:** [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) for AI chat and inline assistance within Neovim.
*   **Claude Code:** [claudecode.nvim](https://github.com/coder/claudecode.nvim) for integration with Claude Code CLI (Command Line Interface).

### Editing Enhancements (Mini.nvim)
Leverages [mini.nvim](https://github.com/echasnovski/mini.nvim) modules for a cohesive editing experience:
*   **mini.surround:** Manage surroundings (parentheses, quotes, etc.).
*   **mini.pairs:** Auto-close pairs.
*   **mini.comment:** Fast commenting.
*   **mini.align:** Align text interactively.
*   **mini.move:** Move lines/blocks of text.
*   **mini.operators:** Text editing operators (replace, exchange, sort, multiply).

### Navigation & Search
*   **Fuzzy Finder:** [fzf-lua](https://github.com/ibhagwan/fzf-lua) for files, buffers, git, grep, etc.
*   **Undo History:** [undotree](https://github.com/mbbill/undotree) for visualizing undo history.
*   **Multiple Cursors:** [vim-visual-multi](https://github.com/mg979/vim-visual-multi).
*   **Bookmarks:** [vim-bookmarks](https://github.com/MattesGroeger/vim-bookmarks) for persistent bookmarks.
*   **TODO Comments:** [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) for highlighting and searching TODO/FIXME/etc.

### Markdown & Notes
*   **Preview:** [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) (browser preview).
*   **Rendering:** [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) (inline styling).
*   **Math Rendering:** [mdmath.nvim](https://github.com/Thiago4532/mdmath.nvim) for inline LaTeX equation rendering as images.
*   **Mind Maps:** [markmap.nvim](https://github.com/Zeioth/markmap.nvim) for visualizing Markdown as mind maps.
*   **Obsidian:** [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) for knowledge base management.

### Syntax & Highlights
*   **Treesitter:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for advanced syntax highlighting.
*   **Treesitter Context:** [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) for sticky context at the top of the buffer.
*   **Match-up:** [vim-matchup](https://github.com/andymass/vim-matchup) for enhanced `%` matching with Treesitter integration.
*   **Colorizer:** [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) for showing hex colors.
*   **Git:** [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for git status in the gutter.
*   **Image Viewing:** [image.nvim](https://github.com/3rd/image.nvim) for viewing images directly in Neovim.

### Language-Specific
*   **LaTeX:** [vimtex](https://github.com/lervag/vimtex) for comprehensive LaTeX support.
*   **C/C++:** [cppman.nvim](https://github.com/madskjeldgaard/cppman.nvim) for C++ manual lookup; [cmake-tools.nvim](https://github.com/Civitasv/cmake-tools.nvim) for CMake integration.

## ⌨️ Keybindings

### General
| Key | Description |
|---|---|
| `<Space>h/j/k/l` | Navigate splits |
| `<Space>1-9` | Switch to Tab 1-9 |
| `<Down>/<Up>` | Resize height |
| `<Left>/<Right>` | Resize width |
| `<Space>]` | Clear search highlights |
| `UD` | Toggle UndoTree |
| `<C-k>`, `<C-j>` | Add Cursor Up/Down |
| `<C-n>` | Find Under (vim-visual-multi) |

### LSP & Diagnostics
| Key | Description |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `<C-h>` | Hover documentation |
| `<Space>D` | Go to type definition |
| `<Space>ca` | Code Actions |
| `<Space>rn` | Rename |
| `<Space>f` | Format file (Conform) |
| `<Space>e` | Show line diagnostics (float) |
| `[d` / `]d` | Previous/Next diagnostic |

### Trouble
| Key | Description |
|---|---|
| `<Space>xx` | Toggle diagnostics (Trouble) |
| `<Space>xX` | Toggle buffer diagnostics (Trouble) |
| `<Space>cs` | Toggle symbols (Trouble) |
| `<Space>cl` | Toggle LSP definitions/references (Trouble) |
| `<Space>xL` | Toggle location list (Trouble) |
| `<Space>xQ` | Toggle quickfix list (Trouble) |

### Editing (Mini.nvim & Operators)
| Key | Description |
|---|---|
| `g=` + motion | Evaluate text (mini.operators) |
| `gx` + motion | Exchange text regions (mini.operators) |
| `gm` + motion | Multiply (duplicate) text (mini.operators) |
| `gr` + motion | Replace text with register (mini.operators) |
| `gs` + motion | Sort text (mini.operators) |
| `Alt+h/j/k/l` | Move selected text (Visual Mode) |

### AI (Claude Code)
| Key | Description |
|---|---|
| `<Space>cc` | Toggle Claude Code |
| `<Space>cf` | Focus Claude |
| `<Space>cr` | Resume Claude |
| `<Space>cC` | Continue Claude |
| `<Space>cm` | Select Claude model |
| `<Space>cb` | Add current buffer to Claude |
| `<Space>cs` | Send selection to Claude (Visual Mode) |
| `<Space>ca` | Accept diff |
| `<Space>cd` | Deny diff |

### C/C++ Docs
| Key | Description |
|---|---|
| `gh` | Open cppman for word under cursor |
| `<Space>cc` | Open cppman search box |

### Running Code
| Key | Description |
|---|---|
| `<C-e>` | Run/Compile current file (Python, C/C++, MATLAB) |

### Markdown
| Key | Description |
|---|---|
| `<Space>o` | Open Markmap |

## 📁 File Structure

```text
~/.config/nvim/
├── init.lua                     # Entry point
├── lazy-lock.json               # Plugin lockfile
├── lua/
│   ├── basic_settings.lua       # General Neovim settings & keymaps
│   ├── Plugins.lua              # Plugin specifications (Lazy.nvim)
│   ├── lsp.lua                  # LSP Core, Mason Setup & Language Loader
│   ├── config/                  # Detailed Plugin Configurations
│   │   ├── cmake.lua            # CMake tools
│   │   ├── codecompanion.lua    # CodeCompanion AI
│   │   ├── conform.lua          # Formatting
│   │   ├── fzf-lua.lua          # Fuzzy finder
│   │   ├── gitsigns.lua         # Git signs
│   │   ├── image.lua            # Image viewing
│   │   ├── lint.lua             # Linting
│   │   ├── lualine.lua          # Statusline
│   │   ├── markdown-preview.lua # Markdown preview
│   │   ├── mini.lua             # Mini.nvim modules
│   │   ├── nvim-cmp.lua         # Completion
│   │   ├── nvim-dap.lua         # Debug adapters
│   │   ├── nvim-dap-ui.lua      # Debug UI
│   │   ├── render-markdown.lua  # Markdown rendering
│   │   ├── snippets.lua         # LuaSnip snippets
│   │   ├── todo-comments.lua    # TODO highlights
│   │   ├── treesitter.lua       # Syntax highlighting
│   │   ├── treesitter-context.lua # Sticky context
│   │   └── vimtex.lua           # LaTeX
│   └── Languages/               # Language-specific LSP configurations
│       ├── asm.lua
│       ├── bash.lua
│       ├── c.lua
│       ├── css.lua
│       ├── html.lua
│       ├── lua_config.lua
│       ├── markdown.lua
│       ├── matlab.lua
│       ├── python.lua
│       ├── rust.lua
│       ├── tcl.lua
│       ├── tex.lua
│       ├── typescript.lua
│       └── verilog.lua
└── Archive/                     # Unused configurations
    └── nvimtree.lua
```

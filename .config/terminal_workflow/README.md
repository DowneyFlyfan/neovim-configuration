<div align="center">

# 🛠️ Terminal Workflow

### A modern, modular dotfiles repo managed with [GNU Stow](https://www.gnu.org/software/stow/)

[![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Yazi](https://img.shields.io/badge/Yazi-%23000000.svg?&style=for-the-badge&logo=files&logoColor=white)](https://github.com/sxyazi/yazi)
[![Kitty](https://img.shields.io/badge/Kitty-%23000.svg?&style=for-the-badge&logo=gnometerminal&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)](https://starship.rs/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![GNU Stow](https://img.shields.io/badge/GNU%20Stow-A42E2B?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/software/stow/)

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)
![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen.svg?style=flat-square)

</div>

---

## ✨ Features

- 🐱 **Kitty** — fast, GPU-accelerated terminal with platform-specific tweaks
- 📝 **Neovim** — modular Lua config with per-language modules and LSP
- 🗂️ **Yazi** — blazing-fast TUI file manager with custom keymap, plugins, and Catppuccin Mocha flavor
- 🚀 **Starship** — minimal, blazing-fast cross-shell prompt
- 🐚 **Zsh + Zinit** — unified `.zshrc` synced across machines, per-machine overrides via `~/.zshrc.local`
- 🔗 **GNU Stow** — symlink-based deployment, modular, no doubled folder names

---

## 📁 Repository Structure

```text
terminal_workflow/
├── nvim/                   # → ~/.config/nvim
│   ├── init.lua
│   ├── lua/
│   │   ├── Languages/      # per-language config modules
│   │   └── config/         # plugin configs (lsp, telescope, treesitter, ...)
│   └── Archive/            # archived configs
├── yazi/                   # → ~/.config/yazi
│   ├── yazi.toml
│   ├── keymap.toml
│   ├── theme.toml
│   ├── flavors/            # Catppuccin Mocha
│   └── plugins/            # chmod, full-border, git, jump-to-char, mime-ext, ...
├── kitty/                  # → ~/.config/kitty
│   ├── kitty.conf
│   ├── linux.conf          # Linux-specific overrides
│   ├── macos.conf          # macOS-specific overrides
│   └── tab_bar.py
├── starship/
│   └── starship.toml       # → ~/.config/starship.toml
└── zsh/
    └── .zshrc              # → ~/.zshrc
```

---

## 🚀 Quick Start

### 📦 Prerequisites

| Tool | Install (macOS) | Install (Linux) |
|------|-----------------|-----------------|
| GNU Stow | `brew install stow` | `apt install stow` / `pacman -S stow` |
| Neovim | `brew install neovim` | `apt install neovim` |
| Yazi | `brew install yazi` | [yazi install](https://yazi-rs.github.io/docs/installation) |
| Kitty | `brew install --cask kitty` | `apt install kitty` |
| Starship | `brew install starship` | `curl -sS https://starship.rs/install.sh \| sh` |
| Zinit | [auto-install via .zshrc](https://github.com/zdharma-continuum/zinit) | same |

### ⚙️ Clone & Deploy

```bash
git clone <this-repo-url> ~/.config/terminal_workflow
cd ~/.config/terminal_workflow

# Create target dirs (first time only)
mkdir -p ~/.config/nvim ~/.config/yazi ~/.config/kitty

# Stow each package with its target
stow -t "$HOME/.config/nvim"  nvim
stow -t "$HOME/.config/yazi"  yazi
stow -t "$HOME/.config/kitty" kitty
stow -t "$HOME/.config"       starship
stow -t "$HOME"               zsh
```

### 🧹 Uninstall

```bash
cd ~/.config/terminal_workflow
stow -D -t "$HOME/.config/nvim"  nvim
stow -D -t "$HOME/.config/yazi"  yazi
stow -D -t "$HOME/.config/kitty" kitty
stow -D -t "$HOME/.config"       starship
stow -D -t "$HOME"               zsh
```

### 🔄 Re-stow (after restructuring)

```bash
stow -R -t "$HOME/.config/nvim" nvim
# ... etc
```

---

## 🔧 Per-Machine Customization

### 🔐 Secrets & Local Overrides

The shared `.zshrc` **never** stores secrets. Place machine-specific or sensitive content in:

```bash
~/.zshrc.local        # NOT tracked, NOT synced
```

The shared `.zshrc` automatically sources it if present:

```zsh
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

### 🍎 / 🐧 Platform-Specific Kitty

`kitty.conf` includes platform-conditional configs:

```conf
# In kitty.conf
include macos.conf    # picked up on macOS
include linux.conf    # picked up on Linux
```

---

## 🎨 Highlights

### 📝 Neovim

- 🗂️ Modular plugin layout under `lua/config/`
- 🌐 Per-language settings under `lua/Languages/` (Python, Rust, C, Lua, LaTeX, Bash, Markdown, ASM, ...)
- 🔌 LSP, Treesitter, Telescope, NvimTree, Vimtex, and more
- 🐦 Hardtime mode available for vim motion training

### 🗂️ Yazi

- 🎨 Catppuccin Mocha flavor
- ⌨️ Vim-style keymap (mirrors `ranger` muscle memory)
- 🔌 Plugins: `chmod`, `full-border`, `git`, `jump-to-char`, `mime-ext`, `smart-paste`, ...

### 🚀 Starship

- ⚡ Minimal, fast, cross-shell prompt
- 🎯 Custom format with git, language version, and directory context

---

## 🧠 Why This Layout?

> **Goal:** clean repo structure with no doubled folder names (e.g. `kitty/kitty/`) and no `.config/` indirection.

Standard Stow layout would require `pkg/.config/<name>/` to mirror `$HOME`. Two compromises were considered:

1. **Single `$HOME` target** → `pkg/.config/<name>/...` (extra `.config/` layer in repo) ❌
2. **Per-package target** (`-t ~/.config/<name>`) → `pkg/<files>` directly (chosen) ✅

Trade-offs of per-package target:
- ✅ No doubled folder names, no `.config/` indirection
- ✅ Subdirectories (e.g. `lua/`) auto-folded as single symlinks
- ⚠️ One stow invocation per package (different targets)
- ⚠️ Adding new top-level files requires re-stow (subdir contents auto-pickup)

---

## 🛡️ Stow Default Ignore List

Stow automatically skips repo metadata, so it's safe to keep these in the repo without polluting your home dir:

`.git/`, `.gitignore`, `LICENSE*`, `README*`, `RCS/`, `CVS/`, `.svn/`, `*~`, `#*#`, `,*`

---

## 📜 License

[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Released under the MIT License.

---

<div align="center">

⭐ If you find this useful, give it a star! ⭐

Made with ❤️ and ☕

</div>

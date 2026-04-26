<div align="center">

# 🛠️ Terminal Workflow

### Mac-local dotfiles repo using a **bare-style git repo** with `$HOME` as the work tree

[![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Yazi](https://img.shields.io/badge/Yazi-%23000000.svg?&style=for-the-badge&logo=files&logoColor=white)](https://github.com/sxyazi/yazi)
[![Kitty](https://img.shields.io/badge/Kitty-%23000.svg?&style=for-the-badge&logo=gnometerminal&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)](https://starship.rs/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

[![macOS](https://img.shields.io/badge/macOS%20only-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)
![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen.svg?style=flat-square)

</div>

---

## ✨ Why bare-style?

This repo coexists with **Unison** sync between Mac ↔ Omen. Symlinks (e.g. via GNU Stow) would conflict with Unison's bidirectional sync because the same path is a symlink on one side and a real file on the other.

🎯 **Solution**: a **bare-style git repo** at `~/.config/terminal_workflow/.git/` with `core.worktree = $HOME`. Tracked files **stay real at their original locations** (`~/.config/nvim/`, `~/.zshrc`, ...), so Unison sees real files on both machines and syncs them normally. The repo just adds version control on top.

🔒 **`terminal_workflow/` is Mac-local** — not synced by Unison, only contains the `.git/` dir and this README.

---

## 📦 Tracked Configs

| Tool | Path | Notes |
|------|------|-------|
| 📝 Neovim | `~/.config/nvim/` | Modular Lua config, LSP, Treesitter, per-language modules |
| 🗂️ Yazi | `~/.config/yazi/` | Catppuccin Mocha, vim-style keymap, plugins |
| 🐱 Kitty | `~/.config/kitty/` | Platform-specific (`linux.conf`, `macos.conf`) |
| 🚀 Starship | `~/.config/starship.toml` | Cross-shell prompt |
| 🐚 Zsh | `~/.zshrc` | Zinit, sourced `~/.zshrc.local` for secrets |

---

## 🔧 The `dotcfg` alias

Added to `~/.zshrc.local` (Mac-only, **not** synced to Omen):

```zsh
alias dotcfg='git --git-dir="$HOME/.config/terminal_workflow/.git" --work-tree="$HOME"'
```

Use it exactly like `git`, but operating on the bare-style repo:

```bash
dotcfg status                     # show staged/modified tracked files
dotcfg add ~/.config/nvim/lua/foo.lua
dotcfg commit -m "tweak nvim"
dotcfg log --oneline
dotcfg push origin main
dotcfg diff
```

> 💡 `status.showUntrackedFiles=no` is set in `.git/config`, so `dotcfg status` won't list every untracked file in `$HOME`. To force-show untracked: `dotcfg status -u`.

---

## 🚀 Setup (recap)

This is how the repo was bootstrapped (one-time, Mac only):

```bash
mkdir -p ~/.config/terminal_workflow
cd ~/.config/terminal_workflow
git init --initial-branch=main
git config core.worktree "$HOME"
git config status.showUntrackedFiles no

# Track real files via the explicit --git-dir / --work-tree flags
git --git-dir="$HOME/.config/terminal_workflow/.git" --work-tree="$HOME" \
    add -f .config/nvim .config/yazi .config/kitty .config/starship.toml .zshrc \
           .config/terminal_workflow/README.md

git --git-dir="$HOME/.config/terminal_workflow/.git" --work-tree="$HOME" \
    commit -m "Init dotfiles"
```

Then add the `dotcfg` alias (above) for daily use.

---

## 🌐 Adding a remote & pushing

```bash
dotcfg remote add origin git@github.com:downeyflyfan/terminal_workflow.git
dotcfg push -u origin main
```

---

## 🔁 Unison interaction

| Path | Synced by Unison? | Source of truth |
|------|-------------------|-----------------|
| `~/.config/nvim/` (real files) | ✅ yes | mutual sync |
| `~/.config/yazi/` (real files) | ✅ yes | mutual sync |
| `~/.config/kitty/` (real files) | ✅ yes | mutual sync |
| `~/.config/starship.toml` | ✅ yes | mutual sync |
| `~/.zshrc` | ✅ yes | mutual sync |
| `~/.config/terminal_workflow/` | ❌ no | Mac-only |

Unison's `main.prf` is **unchanged**. Edits made on Omen propagate to Mac normally; once on Mac, run `dotcfg add` + `dotcfg commit` to version-control them.

---

## 🔐 Secrets

`.zshrc` contains **no secrets**. All API keys / tokens / per-machine state go in:

```
~/.zshrc.local        # NOT tracked, NOT synced
```

The shared `.zshrc` sources it conditionally:

```zsh
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

---

## 📜 License

[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

---

<div align="center">

⭐ Made with ❤️ and ☕

</div>

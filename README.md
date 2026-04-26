<div align="center">

# 🛠️ Terminal Workflow

### A modular, version-controlled dotfiles setup powered by a **bare-style git repo** with `$HOME` as work-tree

<br>

[![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Yazi](https://img.shields.io/badge/Yazi-%23000000.svg?&style=for-the-badge&logo=files&logoColor=white)](https://github.com/sxyazi/yazi)
[![Kitty](https://img.shields.io/badge/Kitty-%23000.svg?&style=for-the-badge&logo=gnometerminal&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)](https://starship.rs/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen?style=flat-square)]()
[![GitHub stars](https://img.shields.io/github/stars/DowneyFlyfan/terminal-workflow?style=flat-square&logo=github)](https://github.com/DowneyFlyfan/terminal-workflow)

[**📖 Why bare-style?**](#-why-bare-style) •
[**📦 Tracked Configs**](#-tracked-configs) •
[**🔧 Daily Usage**](#-daily-usage-with-dotcfg) •
[**🚀 Setup**](#-setup-recap) •
[**🔁 Unison**](#-unison-interaction)

</div>

---

## 🌟 Highlights

| | |
|--|--|
| 🎯 **No symlinks** | Tracked files stay real at their original paths — no GNU Stow, no link soup |
| 🔁 **Unison-friendly** | Works seamlessly alongside bidirectional Mac ↔ Omen sync |
| 📦 **One-command access** | The `dotcfg` alias gives you a full git CLI scoped to your dotfiles |
| 🎨 **Modern stack** | Neovim + Yazi + Kitty + Starship + Zsh (Zinit) |
| 🔒 **Secret-safe** | API keys & per-machine state isolated in untracked `~/.zshrc.local` |
| 🍎🐧 **Cross-platform** | Works on macOS and Linux — same `dotcfg` workflow, same configs |
| 📍 **Single-machine repo** | Repo lives at `~/.config/terminal_workflow/`, not synced — only the source files are |

---

## 📖 Why bare-style?

Most dotfile repos rely on **symlinks** (e.g. via [GNU Stow](https://www.gnu.org/software/stow/)) to map repo files into `$HOME`. That works fine on a single machine — but breaks down once you also use **bidirectional sync** (e.g. [Unison](https://github.com/bcpierce00/unison)) between machines:

```
┌──────────────┐     Unison      ┌──────────────┐
│     Mac      │  ◄───────────►  │     Omen     │
│              │                  │              │
│ ~/.config/   │                  │ ~/.config/   │
│   nvim ───┐  │                  │   nvim/...   │
│           │  │                  │  (real dir)  │
│           ▼  │   ⚠️  TYPE      │              │
│  ../repo/... │   CONFLICT       │              │
└──────────────┘                  └──────────────┘
```

🎯 **Solution**: a **bare-style git repo** — the `.git/` directory lives at `~/.config/terminal_workflow/.git/`, but its `core.worktree` points to `$HOME`. Tracked files stay **real** at their natural locations. No symlinks. No conflicts.

```
┌──────────────────────────────────────────────────┐
│                       MAC                        │
│                                                  │
│  ~/.zshrc                  (real file)           │
│  ~/.config/nvim/...        (real dir)   ◄──┐     │
│  ~/.config/yazi/...        (real dir)      │     │
│  ~/.config/kitty/...       (real dir)      │     │
│  ~/.config/starship.toml   (real file)     │     │
│                                            │     │
│  ~/.config/terminal_workflow/              │     │
│    ├── .git/   ◄── work-tree = $HOME ──────┘     │
│    └── README.md                                 │
│                                                  │
│  Unison sees only real files.  ✅                │
└──────────────────────────────────────────────────┘
```

---

## 📦 Tracked Configs

| | Tool | Path | What's inside |
|---|------|------|---------------|
| 📝 | **Neovim** | `~/.config/nvim/` | Modular Lua setup: LSP, Treesitter, Telescope, NvimTree, per-language modules under `lua/Languages/`, plugin configs under `lua/config/` |
| 🗂️ | **Yazi** | `~/.config/yazi/` | Catppuccin Mocha flavor, vim-style keymap, plugins (`chmod`, `git`, `full-border`, `jump-to-char`, `mime-ext`, `smart-paste`, `zoom`, …) |
| 🐱 | **Kitty** | `~/.config/kitty/` | Cross-platform config + per-OS overrides (`linux.conf`, `macos.conf`) + custom `tab_bar.py` |
| 🚀 | **Starship** | `~/.config/starship.toml` | Custom format, language version chips, git context |
| 🐚 | **Zsh** | `~/.zshrc` | Zinit-based plugin manager, sources `~/.zshrc.local` for secrets/per-machine overrides |
| 📄 | **README** | `~/README.md` | This file (lives at repo root so GitHub displays it) |
| 📜 | **LICENSE** | `~/LICENSE` | MIT License (also at repo root) |

> 🔢 Total tracked: **97 files**

---

## 🔧 Daily Usage with `dotcfg`

A convenience alias is added to `~/.zshrc.local` (per-machine, **never** synced):

```zsh
alias dotcfg='git --git-dir="$HOME/.config/terminal_workflow/.git" --work-tree="$HOME"'
```

Use it **anywhere** in `$HOME` — exactly like `git`, but scoped to the dotfiles repo:

```bash
# 🔍 Inspect
dotcfg status                                 # tracked changes only
dotcfg status -u                              # force-show untracked (rare; lists all of $HOME)
dotcfg log --oneline -10
dotcfg diff
dotcfg diff --cached

# ➕ Track a new file
dotcfg add ~/.config/nvim/lua/Languages/zig.lua
dotcfg commit -m "feat(nvim): add Zig language module"

# 🔄 Update existing tracked files
dotcfg add -u                                 # stage all modifications to tracked files
dotcfg commit -m "chore: tweak yazi keymap"

# 🚀 Push & pull
dotcfg push                                   # to origin/main (tracked)
dotcfg pull --rebase

# 🌿 Branches
dotcfg branch -a
dotcfg checkout -b experiment/nvim-rewrite
```

> 💡 `status.showUntrackedFiles=no` is set in `.git/config`, so `dotcfg status` doesn't drown you in `$HOME` noise.

---

## 🚀 Setup Recap

### 📦 Install the tools

| Tool | macOS 🍎 | Linux 🐧 (Debian/Ubuntu) | Linux 🐧 (Arch) |
|------|----------|--------------------------|------------------|
| Neovim | `brew install neovim` | `apt install neovim` | `pacman -S neovim` |
| Yazi | `brew install yazi` | [build from source](https://yazi-rs.github.io/docs/installation) | `pacman -S yazi` |
| Kitty | `brew install --cask kitty` | `apt install kitty` | `pacman -S kitty` |
| Starship | `brew install starship` | `curl -sS https://starship.rs/install.sh \| sh` | `pacman -S starship` |
| Zinit | auto-installs from `.zshrc` | same | same |

### ⚙️ Bootstrap the repo

```bash
# 1️⃣  Create repo dir
mkdir -p ~/.config/terminal_workflow
cd ~/.config/terminal_workflow

# 2️⃣  Init bare-style
git init --initial-branch=main
git config core.worktree "$HOME"
git config status.showUntrackedFiles no
git config user.email "downeyflyfa@gmail.com"
git config user.name "DowneyFlyfan"

# 3️⃣  Track files (run from $HOME or use absolute paths)
GD="--git-dir=$HOME/.config/terminal_workflow/.git"
WT="--work-tree=$HOME"
cd "$HOME"
git $GD $WT add -f .config/nvim .config/yazi .config/kitty \
                   .config/starship.toml .zshrc \
                   README.md LICENSE
git $GD $WT commit -m "Init dotfiles"

# 4️⃣  Add the alias to ~/.zshrc.local
echo 'alias dotcfg='\''git --git-dir="$HOME/.config/terminal_workflow/.git" --work-tree="$HOME"'\''' \
  >> ~/.zshrc.local

# 5️⃣  Connect remote
dotcfg remote add origin git@github.com:DowneyFlyfan/terminal-workflow.git
dotcfg push -u origin main
```

---

## 🔁 Unison Interaction *(optional, my setup)*

> 💡 This section describes my personal Mac ↔ Linux (Omen desktop) sync setup. If you don't use Unison, skip it — the bare-style repo works perfectly fine on a single machine.

Unison's `~/.unison/main.prf` is **completely unchanged**. It continues to sync the **real files** at their natural paths between the two machines:

| Path | Synced by Unison? | Tracked by `dotcfg`? |
|------|:---:|:---:|
| `~/.config/nvim/` | ✅ | ✅ |
| `~/.config/yazi/` | ✅ | ✅ |
| `~/.config/kitty/` | ✅ | ✅ |
| `~/.config/starship.toml` | ✅ | ✅ |
| `~/.zshrc` | ✅ | ✅ |
| `~/.config/terminal_workflow/` | ❌ | (contains `.git/`) |
| `~/.zshrc.local` | ❌ | ❌ |

🔄 **Edit anywhere, sync everywhere**:
- Edit on Omen → Unison pushes to Mac → run `dotcfg add -u && dotcfg commit -m "..."` → push to GitHub
- Edit on Mac → `dotcfg commit && dotcfg push` → Unison sends to Omen

---

## 🔐 Secrets

The shared `.zshrc` contains **zero secrets**. All sensitive material — API keys, tokens, machine-specific paths — lives in:

```
~/.zshrc.local        # NOT tracked, NOT synced
```

The shared `.zshrc` sources it conditionally:

```zsh
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

On macOS, `~/.zshrc.local` also pulls API keys from the macOS Keychain at startup; on Linux you can use `pass`, `gnome-keyring`, or `secret-tool` to achieve the same — so even the local file holds no plaintext credentials.

---

## 🧠 Tips & Gotchas

- 🔒 `dotcfg status` **only shows tracked changes** by design (`status.showUntrackedFiles=no`). To peek at untracked: `dotcfg status -u`.
- 📍 You can run `dotcfg` from **anywhere** in `$HOME` — `--git-dir` and `--work-tree` are both absolute.
- 🌐 `core.worktree` is set to the **absolute path** of `$HOME` at setup time (e.g. `/Users/<you>` on macOS or `/home/<you>` on Linux). The setup commands use `"$HOME"`, so they automatically work on both platforms.
- 🚫 Do **not** put `~/.config/terminal_workflow/` into Unison's path list. Doing so would copy the `.git/` dir to Omen and create a divergent ref state.
- 🧹 To untrack a file without deleting it: `dotcfg rm --cached <path>`.

---

## 📜 License

[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Released under the MIT License.

---

<div align="center">

⭐ Built with ❤️ and ☕ on macOS 🍎 and Linux 🐧 ⭐

<sub>If you find this approach useful, give it a star or fork it!</sub>

</div>

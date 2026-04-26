# ============================================================
# Unified .zshrc (synced via Unison: Mac <-> Omen)
# Per-machine overrides go in ~/.zshrc.local (NOT synced)
# ============================================================

# ---------- Amazon Q pre block (guarded; Mac-only file but safe everywhere) ----------
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && \
    builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# ---------- Basics ----------
export LC_ALL="en_US.UTF-8"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export BUN_INSTALL="$HOME/.bun"
umask 013

# Interactive guard
[[ $- != *i* ]] && return

# ---------- PATH (set early so starship/eza/etc. resolve) ----------
# Homebrew (macOS) — guarded so Linux skips
[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/cc-haha/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH"

# ---------- zinit bootstrap ----------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && \
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ---------- OMZ libs ----------
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# ---------- Theme: starship (replaces OMZT::robbyrussell) ----------
# starship handles prompt; OMZ theme disabled.
eval "$(starship init zsh)"

# ---------- OMZ git plugin ----------
zinit snippet OMZP::git

# ---------- compinit (sync; needed so compdef is defined for later sync sources) ----------
autoload -Uz compinit && compinit -C

# ---------- Plugins (turbo mode, load after prompt) ----------
zinit wait lucid for \
    atload"zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
    agkozak/zsh-z

# ---------- Plugin settings ----------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
setopt CORRECT
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="false"

# ---------- yazi wrapper: on `q`, cd shell to yazi's last cwd. Blocks nesting via YAZI_LEVEL. ----------
function yazi() {
    if [ -n "$YAZI_LEVEL" ] && [ "$YAZI_LEVEL" -gt 0 ]; then
        print -u2 "yazi: already running (YAZI_LEVEL=$YAZI_LEVEL). Exit parent yazi first."
        return 1
    fi
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    YAZI_LEVEL=$((${YAZI_LEVEL:-0} + 1)) command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
}

# ---------- Shared aliases ----------
alias az="yazi"
alias pip="pip3"
alias vi='nvim'
alias python='python3'
alias ssh="TERM=xterm-256color ssh"
alias ex='exit'
alias claudec='claude --dangerously-skip-permissions -c 2>/dev/null || claude --dangerously-skip-permissions'
alias claudeh='claude-haha --dangerously-skip-permissions -c 2>/dev/null || claude-haha --dangerously-skip-permissions'

# eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza -lT --level=2 --icons --git-ignore'
alias lta='eza -lT --level=3 --icons'

# ripgrep
alias rgi='rg --no-ignore --hidden'      # include ignored/hidden
alias rgf='rg --files'                    # list files
alias rgc='rg --count-matches'            # count matches per file

# lazygit
alias lg='lazygit'

# ---------- EDITOR ----------
export VISUAL='nvim'
export EDITOR='nvim'

# ---------- Shared exports ----------
export RANGER_LOAD_DEFAULT_RC=true
export _JAVA_AWT_WM_NONREPARENTING=1
export DRI_PRIME=1
export OMP_NUM_THREADS=4
export MKL_THREADING_LAYER=GNU
export PYTHONDONTWRITEBYTECODE=1

# ---------- AI / Cloud (non-secret IDs only; secrets go in ~/.zshrc.local) ----------
export GOOGLE_CLOUD_PROJECT="engaged-code-369105"
export GOOGLE_SEARCH_ENGINE_ID="3723b5a669ddc46ec"
export VERTEXAI_PROJECT="68996079624"
export VERTEXAI_LOCATION="global"

# ---------- direnv hook (per-project env auto-load) ----------
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# ---------- Lazy conda (saves ~200ms; loads on first `conda` call) ----------
conda() {
    unset -f conda
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
    unset __conda_setup
    conda "$@"
}

# ---------- Per-machine overrides (NOT synced) ----------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ---------- bun completions ----------
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ---------- Amazon Q post block. Keep at the bottom. ----------
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && \
    builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

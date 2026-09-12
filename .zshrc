# P10k 
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure unique entries in PATH and completion paths
typeset -U path PATH fpath FPATH

# PATH Exports
export PNPM_HOME="$HOME/.local/share/pnpm"
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$PNPM_HOME/bin"
  $path
)

# Oh My Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Vi Mode Configuration (zsh-vi-mode)
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_KEYTIMEOUT=0.03
  ZVM_SYSTEM_CLIPBOARD_ENABLED=true
  ZVM_CLIPBOARD_COPY_CMD='clip.exe'
}

# Drop Zsh key delay from 400ms to 50ms for instant Escape response
export KEYTIMEOUT=5

# OMZ Plugin Styles
zstyle ':omz:plugins:fnm' autostart yes
zstyle ':omz:plugins:fnm' use-on-cd yes
export ZOXIDE_CMD_OVERRIDE=cd

# Plugin List
plugins=(
  zoxide
  eza
  extract
  sudo
  copypath
  copyfile
  aliases

  git
  gitignore

  uv
  fnm
  direnv

  fzf
  fzf-tab

  zsh-autopair
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  you-should-use
  zsh-vi-mode
)

fpath=(${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src $fpath)
autoload -U compinit && compinit

source "$ZSH/oh-my-zsh.sh"

# Default Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=nvim
fi
export VISUAL="$EDITOR"

# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Completion Engine Tuning
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# Eza Plugin Styles
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'header' yes

# fzf-tab Configuration & Previews
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Detect bat/batcat for intelligent previews
if (( $+commands[bat] )); then
  _BAT_BIN="bat"
elif (( $+commands[batcat] )); then
  _BAT_BIN="batcat"
fi

if [[ -n "$_BAT_BIN" ]]; then
  zstyle ':fzf-tab:complete:nvim:*' fzf-preview \
    'if [[ -d $realpath ]]; then eza -1 --color=always $realpath; else '"$_BAT_BIN"' --style=numbers --color=always --line-range :200 $realpath; fi'
else
  zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'eza -1 --color=always $realpath'
fi

# FZF fd integration for faster directory traversal
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
fi

# ------------------------------------------------------------------------------
# Windows Clipboard Engine
# ------------------------------------------------------------------------------
function _get_win_clipboard() {
  if (( $+commands[win32yank.exe] )); then
    win32yank.exe -o --lf
  else
    powershell.exe -NoProfile -NonInteractive -Command Get-Clipboard 2>/dev/null | tr -d '\r'
  fi
}

function _zvm_paste_after() {
  local clip
  clip="$(_get_win_clipboard)"
  [[ -z "$clip" ]] && return
  if [[ -n "$RBUFFER" ]]; then
    LBUFFER="${LBUFFER}${RBUFFER[1]}${clip}"
    RBUFFER="${RBUFFER[2,-1]}"
  else
    LBUFFER="${LBUFFER}${clip}"
  fi
}
zle -N _zvm_paste_after

function _zvm_paste_before() {
  local clip
  clip="$(_get_win_clipboard)"
  [[ -z "$clip" ]] && return
  LBUFFER="${LBUFFER}${clip}"
}
zle -N _zvm_paste_before

function _zvm_paste_insert() {
  local clip
  clip="$(_get_win_clipboard)"
  [[ -z "$clip" ]] && return
  LBUFFER="${LBUFFER}${clip}"
}
zle -N _zvm_paste_insert

# ------------------------------------------------------------------------------
# Keybindings & Lifecycle Callbacks
# ------------------------------------------------------------------------------
function zvm_after_init() {
  # 1. Unbind the hidden \e\e created by OMZ's sudo plugin that freezes single Esc
  bindkey -M viins -r '\e\e' 2>/dev/null
  bindkey -M vicmd -r '\e\e' 2>/dev/null

  # 2. Sudo toggle via Alt+s (works in both insert and normal mode)
  zvm_bindkey viins '^[s' sudo-command-line
  zvm_bindkey vicmd '^[s' sudo-command-line

  # 3. Windows Clipboard Paste Bindings
  zvm_bindkey vicmd 'p' _zvm_paste_after
  zvm_bindkey vicmd 'P' _zvm_paste_before
  zvm_bindkey viins '^V' _zvm_paste_insert

  # 4. Navigation & completion bindings
  zvm_bindkey viins '^ ' autosuggest-accept
  zvm_bindkey viins '^R' fzf-history-widget
  zvm_bindkey viins '^K' history-substring-search-up
  zvm_bindkey viins '^J' history-substring-search-down
}

# Aliases & Functions
[[ -f "$HOME/.zsh/aliases.zsh" ]] && source "$HOME/.zsh/aliases.zsh"
[[ -f "$HOME/.zsh/functions.zsh" ]] && source "$HOME/.zsh/functions.zsh"

# ZVM Mode Cursor Styles for Zed Editor
if [[ "$TERM_PROGRAM" == "zed" ]]; then
  function zvm_after_select_vi_mode() {
    case $ZVM_MODE in
      $ZVM_MODE_NORMAL) print -n '\e[2 q' ;; # Block
      $ZVM_MODE_INSERT) print -n '\e[5 q' ;; # Bar
      $ZVM_MODE_VISUAL) print -n '\e[2 q' ;; # Block
    esac
  }
fi

# P10k Theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Added by Antigravity CLI installer
export PATH="/home/chris/.local/bin:$PATH"

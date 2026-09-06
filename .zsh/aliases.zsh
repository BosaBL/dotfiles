# Bare repo dotfiles alias
alias config='git --git-dir="$HOME/.cfg/" --work-tree="$HOME/"'

# Bat / Batcat pager integration
if (( $+commands[bat] )); then
  alias rcat='command cat'
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
elif (( $+commands[batcat] )); then
  alias rcat='command cat'
  alias cat='batcat --paging=never'
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export MANROFFOPT="-c"
fi

# Use bat as the system-wide pager
if (( $+commands[bat] )); then
  export BAT_PAGER="less -RF"
  export PAGER="bat"
  alias less="bat"
elif (( $+commands[batcat] )); then
  export BAT_PAGER="less -RF"
  export PAGER="batcat"
  alias less="batcat"
fi

# Safer file manipulation
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

# Quick navigation & utilities
alias lg="lazygit"

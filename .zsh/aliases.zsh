alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME/'

if command -v batcat >/dev/null 2>&1; then
  # Save the original system `cat` under `rcat`
  alias rcat="$(which cat)"

  alias cat="$(which batcat)"
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export MANROFFOPT="-c"
elif command -v bat >/dev/null 2>&1; then
  alias rcat="$(which cat)"

  alias cat="$(which bat)"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

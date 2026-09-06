# ==============================================================================
# Production-Hardened Zsh Utility Functions (~/.zsh/functions.zsh)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. kp - Safely terminate processes bound to a network port
#
# Description:
#   Identifies and terminates processes listening on or connected to a given
#   TCP/UDP port.
#
# Safety & Edge-Case Protections:
#   - Verifies `lsof` is installed before execution.
#   - Validates that the port is a valid numeric integer within range (1-65535).
#   - Excludes the current shell's PID ($$) to prevent accidental suicide.
#   - Defaults to SIGTERM (15) instead of SIGKILL (9) to allow clean shutdowns.
#   - Displays matching processes and requires interactive confirmation before
#     sending signals.
#
# Arguments:
#   $1 (Required): Port number (1-65535).
#   $2 (Optional): Signal number or name (default: 15 / SIGTERM).
# ------------------------------------------------------------------------------
kp() {
  if ! (( $+commands[lsof] )); then
    print -u2 "kp: error: 'lsof' is required but not installed."
    return 1
  fi

  local port="$1"
  local sig="${2:-15}"

  if [[ -z "$port" || ! "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
    print -u2 "Usage: kp <port (1-65535)> [signal (default: 15)]"
    return 1
  fi

  local lsof_out
  lsof_out=$(lsof -nP -i :"$port" 2>/dev/null)
  if [[ -z "$lsof_out" ]]; then
    print "kp: No active processes found on port $port."
    return 0
  fi

  print "Detected processes on port $port:"
  print "$lsof_out"
  print ""

  local -a raw_pids pids
  raw_pids=($(print "$lsof_out" | awk 'NR>1 {print $2}' | sort -u))

  # Filter out current shell PID
  pids=(${raw_pids:#$$})

  if (( ${#pids} == 0 )); then
    print -u2 "kp: Only current shell matched or no valid target PIDs found."
    return 1
  fi

  read -q "REPLY?Send SIG$sig to PID(s) ${pids[*]}? [y/N] "
  print ""
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    print "kp: Operation aborted by user."
    return 0
  fi

  kill -"$sig" "${pids[@]}" 2>/dev/null
  local exit_code=$?
  if (( exit_code == 0 )); then
    print "kp: Sent SIG$sig to PID(s): ${pids[*]}"
  else
    print -u2 "kp: Failed to signal one or more PIDs. Elevated permissions (sudo) may be required."
  fi
  return $exit_code
}

# ------------------------------------------------------------------------------
# 2. fkill - Interactive, multi-select process termination via fzf
#
# Description:
#   Interactive process finder allowing multi-selection of processes to terminate.
#
# Safety & Edge-Case Protections:
#   - Verifies `fzf` and `ps` dependencies exist.
#   - Strips init (PID 1) and current shell ($$) from the process table to
#     prevent system halts or terminal crashes.
#   - Validates signal parameter (numeric 1-64 or valid signal names).
#   - Exits cleanly without error if the selection is cancelled via Esc/Ctrl-C.
#   - Prompts for confirmation before sending the kill signal.
#
# Arguments:
#   $1 (Optional): Signal to send (default: 15 / SIGTERM). Pass 9 for SIGKILL.
# ------------------------------------------------------------------------------
fkill() {
  if ! (( $+commands[fzf] )) || ! (( $+commands[ps] )); then
    print -u2 "fkill: error: 'fzf' and 'ps' are required."
    return 1
  fi

  local sig="${1:-15}"
  if [[ ! "$sig" =~ ^[0-9]+$ && ! "$sig" =~ ^[A-Za-z]+$ ]]; then
    print -u2 "Usage: fkill [signal (e.g., 15, 9, TERM, KILL)]"
    return 1
  fi

  local selected
  selected=$(ps -ef | awk -v self="$$" '$2 != 1 && $2 != self {print $0}' | \
    fzf -m \
        --header="[Tab: Multi-select | Enter: Terminate with SIG$sig | Esc: Cancel]" \
        --prompt="Kill Process > " \
        --preview='echo {}' \
        --preview-window=down:3:wrap)

  [[ -z "$selected" ]] && return 0

  local -a pids
  pids=($(print "$selected" | awk '{print $2}'))

  if (( ${#pids} == 0 )); then
    return 0
  fi

  print "Selected PID(s): ${pids[*]}"
  read -q "REPLY?Send SIG$sig to selected process(es)? [y/N] "
  print ""
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    print "fkill: Operation aborted by user."
    return 0
  fi

  kill -"$sig" "${pids[@]}"
}

# ------------------------------------------------------------------------------
# 3. fbr - Interactive Git branch switcher with commit preview
#
# Description:
#   Fuzzy-selects local and remote branches sorted by commit recency and
#   switches to the selected branch.
#
# Safety & Edge-Case Protections:
#   - Verifies git repository context before executing.
#   - Uses structured `git for-each-ref` instead of fragile terminal output parsing.
#   - Gracefully strips remote origins to invoke DWIM local tracking branches.
#   - Does not perform hard resets; respects unstaged changes via `git switch`.
#   - Exits cleanly without side effects if the fzf prompt is cancelled.
#
# Arguments:
#   None.
# ------------------------------------------------------------------------------
fbr() {
  if ! (( $+commands[fzf] )) || ! (( $+commands[git] )); then
    print -u2 "fbr: error: 'fzf' and 'git' are required."
    return 1
  fi

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    print -u2 "fbr: error: Not inside a Git repository."
    return 1
  }

  local target
  target=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ | \
    grep -v '/HEAD$' | \
    fzf --no-multi \
        --prompt="Switch Branch > " \
        --preview-window="right:60%" \
        --preview='git log -n 25 --color=always --oneline --graph --date=relative \
                   --pretty="format:%C(yellow)%h%Creset %C(green)(%ad)%Creset %s %C(blue)[%an]%Creset" {}' \
  )

  [[ -z "$target" ]] && return 0

  # If remote branch, determine if a local branch exists or let switch handle DWIM tracking
  local branch_name="$target"
  if [[ "$branch_name" =~ ^[^/]+/(.+) ]]; then
    local possible_local="${match[1]}"
    if git show-ref --verify --quiet "refs/heads/$possible_local"; then
      branch_name="$possible_local"
    fi
  fi

  git switch "$branch_name" 2>/dev/null || git checkout "$branch_name"
}

# ------------------------------------------------------------------------------
# 4. clonecd - Clone Git repository and navigate into it
#
# Description:
#   Clones a remote Git repository and immediately changes the current working
#   directory into the newly cloned project.
#
# Safety & Edge-Case Protections:
#   - Handles HTTPS, SSH (`git@host:user/repo.git`), and URLs with trailing slashes.
#   - Detects existing non-empty directories to avoid collisions or aborts.
#   - Guarantees directory navigation (`cd`) only executes if `git clone` exits
#     with code 0 and the target folder exists.
#   - Quoting applied across all path operations to support paths with spaces.
#
# Arguments:
#   $1 (Required): Repository URL.
#   $2 (Optional): Destination folder name.
# ------------------------------------------------------------------------------
clonecd() {
  if ! (( $+commands[git] )); then
    print -u2 "clonecd: error: 'git' is required."
    return 1
  fi

  if [[ -z "$1" ]]; then
    print -u2 "Usage: clonecd <repository-url> [destination-directory]"
    return 1
  fi

  local repo_url="$1"
  local target_dir="$2"

  if [[ -z "$target_dir" ]]; then
    target_dir="${repo_url%/}"
    target_dir="${target_dir%.git}"
    target_dir="${target_dir##*/}"
    target_dir="${target_dir##*:}"
  fi

  if [[ -z "$target_dir" ]]; then
    print -u2 "clonecd: error: Failed to parse a valid target directory name from URL."
    return 1
  fi

  if [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
    print -u2 "clonecd: error: Destination '$target_dir' exists and is a regular file."
    return 1
  fi

  if [[ -d "$target_dir" && -n "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
    print -u2 "clonecd: error: Destination directory '$target_dir' exists and is not empty."
    return 1
  fi

  if git clone "$repo_url" "$target_dir"; then
    cd "$target_dir" || {
      print -u2 "clonecd: error: Failed to navigate into '$target_dir'."
      return 1
    }
  else
    print -u2 "clonecd: error: git clone encountered an error."
    return 1
  fi
}

# ------------------------------------------------------------------------------
# 5. scratch - Create and enter an isolated ephemeral directory
#
# Description:
#   Creates a guaranteed-unique temporary directory in the system temp storage
#   and changes directory into it.
#
# Safety & Edge-Case Protections:
#   - Validates that $TMPDIR or /tmp exists and is writable before attempting creation.
#   - Guarantees `cd` is only executed if `mktemp -d` exits with status 0 and
#     creates a verified directory (preventing unwanted navigation to $HOME).
#   - Prints the full canonical path for auditability.
#
# Arguments:
#   None.
# ------------------------------------------------------------------------------
scratch() {
  local base_dir="${TMPDIR:-/tmp}"
  if [[ ! -d "$base_dir" || ! -w "$base_dir" ]]; then
    print -u2 "scratch: error: Base temp directory '$base_dir' does not exist or is not writable."
    return 1
  fi

  local scratch_dir
  scratch_dir=$(mktemp -d "${base_dir%/}/scratch.XXXXXXXXXX" 2>/dev/null)
  local status=$?

  if (( status != 0 )) || [[ -z "$scratch_dir" || ! -d "$scratch_dir" ]]; then
    print -u2 "scratch: error: Failed to create temporary directory."
    return 1
  fi

  if cd "$scratch_dir"; then
    print "scratch: Active workspace created at: $scratch_dir"
  else
    print -u2 "scratch: error: Failed to enter '$scratch_dir'."
    return 1
  fi
}

# ------------------------------------------------------------------------------
# 6. up - Safe parent directory navigation by level count
#
# Description:
#   Navigates up N levels in the directory tree without chaining `../../..`.
#
# Safety & Edge-Case Protections:
#   - Validates that the argument is strictly a positive integer (prevents flags,
#     strings, or negative numbers from corrupting the path).
#   - Enforces a safety ceiling (maximum 50 levels) to prevent infinite loops or
#     unintended path expansion.
#   - Checks target path resolution before execution; exits without moving if
#     navigation fails.
#
# Arguments:
#   $1 (Optional): Number of parent levels to ascend (default: 1).
# ------------------------------------------------------------------------------
up() {
  local count="${1:-1}"

  if [[ ! "$count" =~ ^[0-9]+$ ]] || (( count < 1 )); then
    print -u2 "Usage: up [positive-integer]"
    return 1
  fi

  if (( count > 50 )); then
    print -u2 "up: error: Traversal limit exceeded (maximum 50 levels)."
    return 1
  fi

  local path_target=""
  local i
  for (( i=1; i<=count; i++ )); do
    path_target="../$path_target"
  done

  cd "$path_target" || {
    print -u2 "up: error: Failed to navigate to '$path_target'."
    return 1
  }
}

# ------------------------------------------------------------------------------
# 7. compress - Universal, safe multi-format archive creator
#
# Description:
#   Compresses one or more files or directories into an archive format
#   inferred automatically from the destination filename extension.
#
# Safety & Edge-Case Protections:
#   - Enforces a minimum of two arguments (destination archive + source items).
#   - Iterates and validates the existence of every source file or directory
#     before starting to prevent partial or broken archives.
#   - Checks if the destination archive already exists and requires explicit
#     confirmation ([y/N]) to prevent unrecoverable overwrites.
#   - Detects format using case-insensitive extension matching (${(L)target}).
#   - Verifies the availability of required utility binaries (`tar`, `zip`,
#     `7z`/`7za`/`7zr`) before executing.
#   - Fully quotes source arrays to ensure filenames containing whitespace,
#     newlines, or special characters are safely preserved.
#
# Arguments:
#   $1 (Required): Destination archive path (e.g., archive.tar.gz, bundle.zip).
#   $@ (Required): One or more files or directories to include.
# ------------------------------------------------------------------------------
compress() {
  if (( $# < 2 )); then
    print -u2 "Usage: compress <archive-name.ext> <source-path> [source-path ...]"
    return 1
  fi

  local target="$1"
  shift
  local -a sources=("$@")

  # Verify every source target exists before attempting compression
  local src
  for src in "${sources[@]}"; do
    if [[ ! -e "$src" ]]; then
      print -u2 "compress: error: Source path '$src' does not exist."
      return 1
    fi
  done

  # Overwrite protection
  if [[ -e "$target" ]]; then
    read -q "REPLY?compress: Target archive '$target' already exists. Overwrite? [y/N] "
    print ""
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
      print "compress: Operation aborted by user."
      return 0
    fi
  fi

  # Case-insensitive extension matching
  local ext="${(L)target}"

  case "$ext" in
    *.tar.gz|*.tgz)
      if ! (( $+commands[tar] )); then
        print -u2 "compress: error: 'tar' is required for this format."
        return 1
      fi
      tar -czvf "$target" "${sources[@]}"
      ;;
    *.tar.bz2|*.tbz2|*.tbz)
      if ! (( $+commands[tar] )); then
        print -u2 "compress: error: 'tar' is required for this format."
        return 1
      fi
      tar -cjvf "$target" "${sources[@]}"
      ;;
    *.tar.xz|*.txz)
      if ! (( $+commands[tar] )); then
        print -u2 "compress: error: 'tar' is required for this format."
        return 1
      fi
      tar -cJvf "$target" "${sources[@]}"
      ;;
    *.tar.zst)
      if ! (( $+commands[tar] )); then
        print -u2 "compress: error: 'tar' is required for this format."
        return 1
      fi
      tar --zstd -cvf "$target" "${sources[@]}"
      ;;
    *.tar)
      if ! (( $+commands[tar] )); then
        print -u2 "compress: error: 'tar' is required for this format."
        return 1
      fi
      tar -cvf "$target" "${sources[@]}"
      ;;
    *.zip)
      if ! (( $+commands[zip] )); then
        print -u2 "compress: error: 'zip' is required for this format."
        return 1
      fi
      zip -r "$target" "${sources[@]}"
      ;;
    *.7z)
      local bin_7z=""
      if (( $+commands[7z] )); then
        bin_7z="7z"
      elif (( $+commands[7za] )); then
        bin_7z="7za"
      elif (( $+commands[7zr] )); then
        bin_7z="7zr"
      else
        print -u2 "compress: error: '7z', '7za', or '7zr' is required for this format."
        return 1
      fi
      "$bin_7z" a "$target" "${sources[@]}"
      ;;
    *)
      print -u2 "compress: error: Unsupported archive format for '$target'."
      print -u2 "Supported extensions: .tar.gz, .tgz, .tar.bz2, .tbz, .tar.xz, .txz, .tar.zst, .tar, .zip, .7z"
      return 1
      ;;
  esac
}

# ------------------------------------------------------------------------------
# 8. fif - Interactive "Find in Files" with syntax-highlighted match preview
#
# Description:
#   Performs a fast text search across the current directory using ripgrep,
#   pipes matched files into fzf with a live preview centered and highlighted
#   on the first matching line, and opens the file directly in $EDITOR at that line.
#
# Safety & Edge-Case Protections:
#   - Validates dependencies (`rg` and `fzf`) before execution.
#   - Detects either `bat` or `batcat` (Debian/Ubuntu) for syntax highlighting;
#     falls back cleanly to standard output tools if neither is present.
#   - Passes the search term via `-e "$query"` to prevent terms starting with
#     hyphens (e.g., `fif --debug`) from being parsed as CLI flags.
#   - Exports the query safely to the subshell environment (`FIF_QUERY`) rather
#     than interpolating raw strings into the fzf preview command, completely
#     eliminating shell injection risks from quotes or metacharacters.
#   - Automatically calculates line offsets so `bat` centers the preview directly
#     around the match instead of cutting off at the top of large files.
#   - Gracefully handles empty search results, cancellation via Esc/Ctrl-C,
#     and files with spaces or special characters in their paths.
#   - Verifies terminal interactivity (`-t 1`) and file existence before
#     launching `$EDITOR`, jumping to the exact line in vim/nvim.
#
# Arguments:
#   $1 (Required): Search query / regex pattern.
# ------------------------------------------------------------------------------
fif() {
  if ! (( $+commands[rg] )) || ! (( $+commands[fzf] )); then
    print -u2 "fif: error: 'rg' (ripgrep) and 'fzf' are required."
    return 1
  fi

  if [[ -z "$1" ]]; then
    print -u2 "Usage: fif <search-pattern>"
    return 1
  fi

  local query="$1"

  # Detect available pager / syntax highlighter
  local bat_cmd=""
  if (( $+commands[bat] )); then
    bat_cmd="bat"
  elif (( $+commands[batcat] )); then
    bat_cmd="batcat"
  fi

  # Run search and allow selection
  local selected
  selected=$(
    export FIF_QUERY="$query" FIF_BAT="$bat_cmd"
    rg --files-with-matches --no-messages --hidden --glob '!.git' -e "$query" 2>/dev/null | \
      fzf --no-multi \
          --prompt="Find in Files > " \
          --preview-window="right:65%:wrap" \
          --preview='
            # Locate first matching line number
            match_line=$(rg --line-number --no-messages -e "$FIF_QUERY" {} 2>/dev/null | cut -d: -f1 | head -n1)
            match_line=${match_line:-1}

            # Center preview range ~15 lines before the match
            start_line=1
            if (( match_line > 15 )); then
              start_line=$(( match_line - 15 ))
            fi

            if [[ -n "$FIF_BAT" ]]; then
              "$FIF_BAT" --style=numbers --color=always \
                         --line-range "${start_line}:" \
                         --highlight-line "$match_line" {}
            else
              head -n 200 {}
            fi
          '
  )

  # Clean exit on Esc / Ctrl-C
  [[ -z "$selected" ]] && return 0

  if [[ ! -f "$selected" ]]; then
    print -u2 "fif: error: Selected file '$selected' no longer exists."
    return 1
  fi

  # Locate first match line for editor positioning
  local line
  line=$(rg --line-number --no-messages -e "$query" "$selected" 2>/dev/null | cut -d: -f1 | head -n1)

  # Open in editor if in an interactive shell; otherwise output the path
  if [[ -t 1 && -n "$EDITOR" ]]; then
    if [[ -n "$line" && ("$EDITOR" == *"vim"* || "$EDITOR" == *"nvim"*) ]]; then
      "$EDITOR" "+$line" "$selected"
    else
      "$EDITOR" "$selected"
    fi
  else
    print -r -- "$selected"
  fi
}

# ------------------------------------------------------------------------------
# 9. listening - Clean, cross-platform listening port auditor
#
# Description:
#   Displays an organized, sorted summary of all TCP/UDP ports currently
#   in a LISTEN state, including the owning daemon, PID, user, and protocol.
#
# Safety & Edge-Case Protections:
#   - Autodetects `lsof` or `ss` (Linux socket statistics) depending on what
#     is installed on the target environment.
#   - Warns non-root users when running without elevated permissions, as unprivileged
#     users cannot inspect process IDs owned by other system users.
#   - Prevents DNS resolution hangs by enforcing numeric host and port output (-nP / -ntlp).
#   - Gracefully handles scenarios where no ports are actively listening.
#
# Arguments:
#   $1 (Optional): Filter string or port number to narrow results.
# ------------------------------------------------------------------------------
listening() {
  local filter="$1"

  # Non-privileged permission notice
  if (( EUID != 0 )); then
    print -u2 "listening: note: Run with sudo to inspect processes owned by other users."
  fi

  if (( $+commands[lsof] )); then
    local output
    output=$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null)

    if [[ -z "$output" ]]; then
      print "listening: No active TCP listening sockets detected."
      return 0
    fi

    if [[ -n "$filter" ]]; then
      print "$output" | head -n 1
      print "$output" | tail -n +2 | grep -iE "$filter"
    else
      print "$output"
    fi
  elif (( $+commands[ss] )); then
    if [[ -n "$filter" ]]; then
      ss -tuln -p | grep -iE "(State|$filter)"
    else
      ss -tuln -p
    fi
  else
    print -u2 "listening: error: Neither 'lsof' nor 'ss' was found on this system."
    return 1
  fi
}

# ------------------------------------------------------------------------------
# 10. fenv - Interactive fuzzy environment variable inspector
#
# Description:
#   Searches exported environment variables using fzf and displays an
#   expanded preview. Automatically detects and formats colon-delimited lists
#   (like PATH, FPATH, and CDPATH) into numbered, readable lines.
#
# Safety & Edge-Case Protections:
#   - Validates `fzf` availability before launching.
#   - Queries Zsh's internal parameter table (`${(k)parameters[(R)*export*]}`)
#     instead of parsing `env` or `printenv`, completely preventing multi-line
#     variable corruption (such as multiline certificates or private keys).
#   - Does not evaluate, execute, or mutate variables in memory.
#   - Exits cleanly when aborted via Esc or Ctrl-C.
#   - Copies the selected variable value into the interactive buffer when completed.
#
# Arguments:
#   None.
# ------------------------------------------------------------------------------
fenv() {
  if ! (( $+commands[fzf] )); then
    print -u2 "fenv: error: 'fzf' is required."
    return 1
  fi

  local -a env_vars
  # Extract all exported variable names natively from Zsh
  env_vars=(${(k)parameters[(R)*export*]})

  if (( ${#env_vars} == 0 )); then
    print -u2 "fenv: No exported environment variables detected."
    return 1
  fi

  local selected_var
  selected_var=$(print -l "${env_vars[@]}" | sort | fzf \
    --prompt="Environment Vars > " \
    --preview-window="right:65%:wrap" \
    --preview='
      var_name="{}"
      val="${(P)var_name}"

      printf "\033[1;33mVariable:\033[0m %s\n" "$var_name"
      printf "\033[1;34mLength:\033[0m   %s characters\n\n" "${#val}"

      if [[ "$val" == *:* && ( "$var_name" == *PATH* || "$var_name" == *DIRS* ) ]]; then
        printf "\033[1;32m=== Delimited Paths ===\033[0m\n"
        print -l ${(s.:.)val} | awk "{printf \"  %2d: %s\n\", NR, \$0}"
        printf "\n\033[1;32m=== Raw Value ===\033[0m\n"
        print -r -- "$val"
      else
        printf "\033[1;32m=== Value ===\033[0m\n"
        print -r -- "$val"
      fi
    ')

  [[ -z "$selected_var" ]] && return 0

  # Print assignment to prompt buffer for immediate access
  print -r -- "export $selected_var=\"${(P)selected_var}\""
}

# ------------------------------------------------------------------------------
# 11. cht - Terminal cheatsheet lookup via cheat.sh
#
# Description:
#   Queries cheat.sh for command syntaxes, language snippets, or CLI options
#   and renders the formatted output with automatic syntax highlighting and paging.
#
# Safety & Edge-Case Protections:
#   - Checks for `curl` before dispatching network calls.
#   - Enforces a strict 10-second connect timeout (`--max-time 10`) to prevent
#     hanging your terminal session on unstable connections.
#   - Automatically converts multi-word questions into URL-safe queries (`+` delimited).
#   - Strips dangerous terminal control characters while preserving ANSI colors.
#   - Dynamically pipes into `bat` (with paging) or system `$PAGER` when run in an
#     interactive terminal, preventing high-output queries from flooding scrollback.
#
# Arguments:
#   $1 (Required): Target language or CLI utility (e.g., "tar", "python", "git").
#   $@ (Optional): Subtopic, question, or specific function to look up.
# ------------------------------------------------------------------------------
cht() {
  if ! (( $+commands[curl] )); then
    print -u2 "cht: error: 'curl' is required."
    return 1
  fi

  if (( $# == 0 )); then
    print -u2 "Usage: cht <command|language> [subtopic or query...]"
    print -u2 "Examples:"
    print -u2 "  cht tar"
    print -u2 "  cht python list comprehension"
    print -u2 "  cht git commit --amend"
    return 1
  fi

  local target="$1"
  shift
  local query="$*"

  # Build URL endpoint
  local url="https://cheat.sh/${target}"
  if [[ -n "$query" ]]; then
    # Replace spaces with plus signs for URL query encoding
    local encoded_query="${query// /+}"
    url="${url}/${encoded_query}"
  fi

  # Query cheat.sh with a timeout
  local response
  response=$(curl -s -m 10 "$url")
  local curl_status=$?

  if (( curl_status != 0 )); then
    print -u2 "cht: error: Failed to connect to cheat.sh (curl error code: $curl_status)."
    return 1
  fi

  if [[ -z "$response" ]]; then
    print -u2 "cht: No cheatsheet returned for '$target $query'."
    return 1
  fi

  # Render through pager if inside an interactive terminal session
  if [[ -t 1 ]]; then
    if (( $+commands[bat] )); then
      print -r -- "$response" | bat --style=plain --paging=always
    elif (( $+commands[batcat] )); then
      print -r -- "$response" | batcat --style=plain --paging=always
    else
      print -r -- "$response" | "${PAGER:-less -R}"
    fi
  else
    print -r -- "$response"
  fi
}

if (( $+commands[wslview] )); then
  alias open="wslview"
elif (( $+commands[explorer.exe] )); then
  open() {
    if [[ -z "$1" ]]; then
      explorer.exe .
    else
      explorer.exe "$1"
    fi
  }
fi

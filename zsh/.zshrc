# Set default unix paths
export XDG_CONFIG_HOME=$HOME/.config

# Binary Paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.docker/bin:$PATH

export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"


# Aliases
alias config="nvim ~/dotfiles"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias tree="erd --suppress-size"
alias du="dust"
alias cd="z"
alias stow="nstow"

alias d='docker'
alias k='kubectl'
alias mm='micromamba'

alias claude_competera='ANTHROPIC_VERTEX_PROJECT_ID="cmp-development" CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=global CLAUDE_CONFIG_DIR=~/.claude-competera claude'

# Claude Code viz tools
function ghostship() {
  node ~/pp/agent-profiler/node_modules/@ghostship/agent-profiler/bin/agent-profiler.js --no-open --port 5180
}

function s1lentblade() {
  (cd ~/pp/s1lentblade && ./refresh.sh)
}

function s1lentblade-convert() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: s1lentblade-convert <input.jsonl> <output.html>"
    return 1
  fi
  python3 ~/pp/s1lentblade/scripts/jsonl_to_html.py "$1" "$2"
}

function cctools() {
  echo "ghostship          DAG analytics        localhost:5180"
  echo "s1lentblade         full-scan HTML        ~/pp/s1lentblade/"
  echo "s1lentblade-convert <in> <out> HTML       single session"
  echo "cctrace             session trace UI      localhost:1421"
  echo "ccsv                session viewer        localhost:3838"
}

function cctrace() {
  CCTRACE_STATIC_DIR=~/pp/claude-code-trace/dist \
  CCTRACE_HTTP_PORT=1421 \
  "/Applications/Claude Code Trace.app/Contents/MacOS/claude-code-trace" --headless
}

function compress() {
  if [[ -z "$1" ]]; then
    echo "Usage: compress <file_or_directory>"
    return 1
  fi

  tar --create --file - "$1" | xz -9 --extreme --verbose >"$1.tar.xz"
}

function decompress() {
  if [[ -z "$1" ]]; then
    echo "Usage: decompress <file.tar.xz>"
    return 1
  fi

  xzcat "$1" | tar -xvf -
}

custom_prompt_rustpy() {
    setopt PROMPT_SUBST

    # Function to get Git information
    git_info() {
        local ref=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [[ -n "$ref" ]]; then
            if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
                echo "%F{214}[$ref*]%f "  # Peach
            else
                echo "%F{108}[$ref]%f "   # Green
            fi
        fi
    }

    # Function to get Python version (only in Python projects)
    python_info() {
        if [[ -f "setup.py" || -f "requirements.txt" || -d "venv" || -n "$VIRTUAL_ENV" ]]; then
            local venv=$(basename "$VIRTUAL_ENV" 2>/dev/null)
            if [[ -n "$venv" ]]; then
                echo "%F{075}[$venv]%f "  # Blue
            else
                echo "%F{075}[🐍]%f "     # Blue
            fi
        fi
    }

    # Function to get Rust version (only in Rust projects)
    rust_info() {
        if [[ -f "Cargo.toml" || -f "Cargo.lock" ]]; then
            echo "%F{203}[🦀]%f "         # Red
        fi
    }

    # Function to show exit status of last command
    exit_status() {
        echo "%(?.%F{108}✓.%F{203}✗)%f"  # Green for success, Red for failure
    }

    # Set the prompt
    PROMPT='$(exit_status) %F{183}%~%f $(git_info)$(python_info)$(rust_info)
%F{075}❯%F{183}❯%F{217}❯%f '  # Blue, Mauve, Flamingo

    # Set the right prompt (for showing time)
    RPROMPT='%F{245}%*%f'  # Overlay0
}

# History dedup
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Case-insensitive suggestions
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Plugin management with ZR
. <(zr zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions)
# Activate the prompt
custom_prompt_rustpy
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ryzhakar/.google/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ryzhakar/.google/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ryzhakar/.google/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ryzhakar/.google/google-cloud-sdk/completion.zsh.inc'; fi

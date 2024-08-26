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

alias d='docker'
alias k='kubectl'
alias mm='micromamba'

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

# Activate the prompt
custom_prompt_rustpy


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/ryzhakar/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

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

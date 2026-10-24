# zsh configuration
# Minimal and functional zsh setup

# ============================================================================
# Environment Variables
# ============================================================================

export EDITOR="nvim"
export VISUAL="nvim"

# History configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# ============================================================================
# Options
# ============================================================================

# History
setopt APPEND_HISTORY          # Append to history file
setopt SHARE_HISTORY           # Share history between sessions
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks
setopt HIST_VERIFY             # Show command with history expansion before running

# Directory navigation
setopt AUTO_CD                 # cd by typing directory name
setopt AUTO_PUSHD              # Push old directory onto the stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
setopt PUSHD_SILENT            # Don't print directory stack

# Completion
setopt AUTO_MENU               # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD        # Complete from both ends of a word
setopt ALWAYS_TO_END           # Move cursor to end if word had one match

# Other
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shell
setopt EXTENDED_GLOB           # Extended globbing


# ============================================================================
# Plugin Manager (Sheldon)
# ============================================================================

# Load sheldon plugins
if command -v sheldon &> /dev/null; then
  eval "$(sheldon source)"
fi

# Keybindings for plugins
if (( $+widgets[autosuggest-accept] )); then
  bindkey '^F' autosuggest-accept
fi

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

# ============================================================================
# Completion System
# ============================================================================

# Completion is initialized by Sheldon (see sheldon/plugins.toml)
# Completion options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion

# ============================================================================
# Aliases
# ============================================================================

# Editor
alias vim="nvim"
alias vi="nvim"
alias nv="nvim"

# ls aliases. BSD and GNU ls spell the color flag differently.
if [[ "$OSTYPE" == "darwin"* ]]; then
  ls_color="-G"
else
  ls_color="--color=auto"
fi
alias ls="ls $ls_color"
alias ll="ls -lh $ls_color"
alias la="ls -lah $ls_color"
unset ls_color

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# Common commands
alias c="clear"
alias h="history"
alias grep="grep --color=auto"

# ============================================================================
# Additional Tool Integrations
# ============================================================================

# Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# Load machine-specific paths and secrets before optional session startup.
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Zellij auto-start
if [[ "${DOTFILES_ZELLIJ_AUTO_START:-1}" == "1" && -t 0 && $- == *i* ]] && command -v zellij &> /dev/null; then
  if [[ "$TERM_PROGRAM" == 'vscode' ]]; then
    if [[ -z "$ZELLIJ" ]]; then
      zellij attach --create "$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")")"
      exit
    fi
  else
    if [[ -z "$VSCODE_RESOLVING_ENVIRONMENT" ]]; then
      export ZELLIJ_AUTO_EXIT=true
      eval "$(zellij setup --generate-auto-start zsh)"
    fi
  fi
fi

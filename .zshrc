# ============================================
# PATH
# ============================================
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
export PATH="$PATH:$HOME/.deno/bin/deno"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export LOCAL_BIN="${HOME}/.local/bin"
export PATH="$LOCAL_BIN:$PATH"

# ============================================
# Zinit - Plugin Manager
# ============================================
if [[ ":$FPATH:" != *":${HOME}/.zsh/completions:"* ]]; then
  export FPATH="${HOME}/.zsh/completions:$FPATH"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# ============================================
# Completions (cached - rebuilds once per day)
# ============================================
autoload -Uz compinit
if [[ -f ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview 'bat $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ============================================
# Prompt
# ============================================
eval "$(starship init zsh)"

# ============================================
# Keybindings
# ============================================
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ============================================
# History
# ============================================
HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt autocd

# ============================================
# Tool Initialization
# ============================================
# fzf - Ctrl-T, cd **, kill -9 **, unset **, export, unalias
eval "$(fzf --zsh)"

# Zoxide (better cd)
eval "$(zoxide init --cmd cd zsh)"

# fnm (better nvm) - --use-on-cd handles .nvmrc automatically
eval "$(fnm env --use-on-cd --shell zsh)"

# pyenv (lazy-loaded)
_pyenv_lazy_load() {
  unfunction pyenv 2>/dev/null
  eval "$(pyenv init -)"
  pyenv "$@"
}
if command -v pyenv 1>/dev/null 2>&1; then
  pyenv() { _pyenv_lazy_load "$@" }
fi

# thefuck (lazy-loaded for faster shell startup)
_thefuck_lazy_load() {
  unfunction fuck fk 2>/dev/null
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)
}
fuck() { _thefuck_lazy_load; fuck "$@" }
fk() { _thefuck_lazy_load; fk "$@" }

# Deno
. "$HOME/.deno/env"

# Joyia CLI
if command -v joyia 1>/dev/null 2>&1; then
  eval "$(joyia completions zsh)"
fi

export AWS_PROFILE=sts

# ============================================
# Aliases
# ============================================
alias c='clear'
alias cat='bat'
alias ls="eza --icons=always"
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'

# ============================================
# Functions
# ============================================

# Auto-activate/deactivate Python virtualenvs on cd
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    if [[ -d ./.env ]] ; then
      source ./.env/bin/activate
    fi
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      deactivate
    fi
  fi
}

zsh-update() {
  echo "🔄 Updating Zinit and plugins..."
  zinit self-update && zinit update --all
  echo "✅ All Zinit plugins updated!"
}

dev-update() {
  echo "🛠️ Updating system tools..."
  brew update && brew upgrade
  rustup update
  starship upgrade
  zsh-update
  brew-packages
  echo "🎉 Everything's fresh and clean!"
}

brew-packages() {
  echo "🔄 Installing Default Brew packages..."
  binaries=(
    "fzf"
    "zoxide"
    "bat"
    "git-delta:delta"
    "eza"
    "thefuck:fuck"
    "fnm"
    "stow"
    "pyenv"
    "dug"
    "gitui"
    "starship"
  )

  for item in "${binaries[@]}"; do
    IFS=":" read -r brew_name bin_name <<< "${item}"
    bin_name="${bin_name:-$brew_name}"
    if [[ ! -f "/opt/homebrew/bin/$bin_name" ]]; then
      brew install "$brew_name"
    fi
  done
  echo "✅ All Default Brew packages are updated!"
}

# ============================================
# Managed by external tools (do not edit)
# ============================================
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

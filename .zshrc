# Add deno completions to search path
if [[ ":$FPATH:" != *":${HOME}/.zsh/completions:"* ]]; then export FPATH="${HOME}/.zsh/completions:$FPATH"; fi
# Set the directory we want to store zinit and plugins
export PATH="/opt/homebrew/bin:$PATH"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

OMP_THEME="powerlevel10k_rainbow"
#OMP_THEME="atomic"
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/${OMP_THEME}.omp.json)"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview 'bat $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Standard Aliases
alias c='clear'
alias stree='/Applications/SourceTree.app/Contents/Resources/stree' 
# fzf
# ---- fzf  ----
# Ctr-T 
# cd ** for directory filtering
# kill -9 ** tab
# unset ** tab, export , unalias
eval "$(fzf --zsh)"
# ---- Zoxide (better cd) ----
eval "$(zoxide init --cmd cd zsh)"
# Bat better cat
alias cat='bat'
# ---- Eza (better ls) -----
alias ls="eza --icons=always"
# ---- TheFuck -----
# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)
# fnm (better nvm)
eval "$(fnm env --use-on-cd --shell zsh)"

# TODO:
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# Change nvm 
#nvm use version
# Change python
#pyenv global 3.9.12
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"

function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the virtualenv
      if [[ -d ./.env ]] ; then
        source ./.env/bin/activate
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi

  # Check for .nvmrc and use fnm if it exists
  if [[ -f ./.nvmrc ]] ; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  fi
}

# === Update Zinit & Plugins Function ===
zsh-update() {
  echo "🔄 Updating Zinit and plugins..."
  zinit self-update && zinit update --all
  echo "✅ All Zinit plugins updated!"
}

# === Optional: Add system-wide updates too ===
dev-update() {
  echo "🛠️ Updating system tools..."
  brew update && brew upgrade
  rustup update
  starship upgrade
  zsh-update
  brew-pacakages
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
    "jandedobbeleer/oh-my-posh/oh-my-posh:oh-my-posh"
    "pyenv"
    "dug"
    "gitui"
  )

  for item in "${binaries[@]}"; do
    IFS=":" read -r brew_name bin_name <<< "${item}"
    bin_name="${bin_name:-$brew_name}"
    if [[ ! -f "/opt/homebrew/bin/$bin_name" ]]; then
      brew install "$brew_name"
    fi
  done
  echo "✅ All Default Brew pacakages are updated!"
}

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# Add .local/bin
export LOCAL_BIN="${HOME}/.local/bin"
export PATH="$LOCAL_BIN:$PATH"
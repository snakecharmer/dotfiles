# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

```
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
)

for item in "${binaries[@]}"; do
  IFS=":" read -r brew_name bin_name <<< "${item}"
  bin_name="${bin_name:-$brew_name}"
  if [[ ! -f "/opt/homebrew/bin/$bin_name" ]]; then
    brew install "$brew_name"
  fi
done

brew install --cask font-fira-code-nerd-font
```

Change font in your profile in iTerm2 to use all the icons :) 

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:snakecharmer/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```
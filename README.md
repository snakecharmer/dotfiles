# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

```
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew-packages

brew install --cask font-fira-code-nerd-font
```

Change font in your profile in iTerm2 to use all the icons :) 

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone https://github.com/snakecharmer/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```

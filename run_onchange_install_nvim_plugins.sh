#!/usr/bin/env bash

PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

if [ ! -f "$PLUG_PATH" ]; then
  curl -fLo "$PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

set -e

if command -v nvim >/dev/null 2>&1; then
  nvim --headless +PlugInstall +qall
fi

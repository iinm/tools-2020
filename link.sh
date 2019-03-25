#!/usr/bin/env bash

this_dir=$(cd $(dirname "$0") && pwd)

files=(
    .zshrc .zshenv
    .tmux.conf .tmux-linux.conf .tmux-darwin.conf
    .vimrc .vim
)

for fname in "${files[@]}"; do
    ln -sv $this_dir/$fname ~/
done

# $XDG_CONFIG_HOME
case "$(uname)" in
    "Linux" ) config_files=(nvim) ;;
    "Darwin" ) config_files=(nvim) ;;
    * ) config_files=() ;;
esac

mkdir -pv ~/.config
for fname in "${config_files[@]}"; do
    ln -sv $this_dir/.config/$fname ~/.config/
done

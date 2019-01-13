#!/usr/bin/env bash

this_dir=$(cd $(dirname "$0") && pwd)

files=(
    .zshrc .zshenv
    .tmux.conf .tmux_linux.conf .tmux_darwin.conf
    .vimrc .vim
    tools
)

for fname in "${files[@]}"; do
    ln -sv $this_dir/$fname $HOME/
done

# $XDG_CONFIG_HOME
case "$(uname)" in
    "Linux" ) config_files=() ;;
    "Darwin" ) config_files=() ;;
    * ) config_files=() ;;
esac

mkdir -pv $HOME/.config
for fname in "${config_files[@]}"; do
    ln $ln_opt -sv $this_dir/.config/$fname $HOME/.config/
done

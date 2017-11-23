#!/bin/bash

#this_dir=$(dirname $(readlink -f "$0"))
this_dir=$(cd $(dirname "$0") && pwd)

ln_opt="$1"

files=(
    .zshrc .zshenv
    .tmux.conf
    .tmux_linux.conf
    .tmux_darwin.conf
    tools
)

for fname in "${files[@]}"; do
    ln $ln_opt -sv $this_dir/$fname $HOME/
done

# $XDG_CONFIG_HOME
case "$(uname)" in
    "Linux" ) config_files=(fontconfig nvim) ;;
    "Darwin" ) config_files=(nvim) ;;
    * ) config_files=() ;;
esac

mkdir -pv $HOME/.config
for fname in "${config_files[@]}"; do
    ln $ln_opt -sv $this_dir/.config/$fname $HOME/.config/
done

#!/bin/bash

#this_dir=$(dirname $(readlink -f "$0"))
this_dir=$(cd $(dirname "$0") && pwd)

ln_opt="$1"

files=(
    .zshrc .zshenv .oh-my-zsh
    .tmux.conf
    .emacs.d
    .vimrc .vimrc.d .vim
    tools
    #.pystartup.py
    #.ipython
    #.spacemacs
)

for fname in "${files[@]}"; do
    ln $ln_opt -sv $this_dir/$fname $HOME/
done

# prelude
ln $ln_opt -sv $this_dir/spacemacs $HOME/.emacs.d

# $XDG_CONFIG_HOME
case "$(uname)" in
    "Linux" ) config_files=(fontconfig nvim terminator todo.cfg) ;;
    "Darwin" ) config_files=(nvim todo.cfg) ;;
    * ) config_files=() ;;
esac

mkdir -pv $HOME/.config
for fname in "${config_files[@]}"; do
    ln $ln_opt -sv $this_dir/.config/$fname $HOME/.config/
done

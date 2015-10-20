#!/bin/bash

#SCRIPT_DIR=$(dirname $(readlink -f "$0"))
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

files=(
    .zshrc .oh-my-zsh
    .tmux.conf
    .emacs.d
    .vimrc .vimrc.d .vim
    .pystartup.py
)

for fname in "${files[@]}"; do
    ln -sv $SCRIPT_DIR/$fname $HOME/
done

#
if [[ "$(uname)" == 'Linux' ]]; then
    mkdir -pv $HOME/.config/fontconfig
    ln -sv $SCRIPT_DIR/fonts.conf $HOME/.config/fontconfig/
fi

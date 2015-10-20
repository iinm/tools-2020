#!/bin/bash

#SCRIPT_DIR=$(dirname $(readlink -f "$0"))
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

# zsh
ln -sv $SCRIPT_DIR/{.oh-my-zsh,.zshrc} $HOME

# tmux
ln -sv $SCRIPT_DIR/.tmux.conf $HOME

# emacs
ln -sv $SCRIPT_DIR/.emacs.d $HOME

# vim
ln -sv $SCRIPT_DIR/{.vimrc,.vimrc.d,.vim} $HOME

# python
ln -sv $SCRIPT_DIR/.pystartup.py $HOME

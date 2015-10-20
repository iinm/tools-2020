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
cp -iv /usr/share/vim/vim7?/vimrc_example.vim $HOME/.vimrc || cp -iv /usr/local/share/vim/vim7?/vimrc_example.vim $HOME/.vimrc
cat $SCRIPT_DIR/.vimrc.tail >> $HOME/.vimrc
ln -sv $SCRIPT_DIR/{.vimrc.local,.vimrc.d,.vim} $HOME

# python
ln -sv $SCRIPT_DIR/.pystartup.py $HOME

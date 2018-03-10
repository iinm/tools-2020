# etc

Configuration files (a.k.a. dotfiles)

## Install

```sh
git clone --recursive https://github.com/iinm/etc.git ~/.etc
cd ~/.etc
bash link.sh
# or
bash link.sh -f  # remove existing files
```

## Setup

```sh
source setup_tools.sh
setup_pyenv
setup_gvm
setup_nvm
setup_rust
```

```
pip install neovim
go get github.com/direnv/direnv
cargo install ripgrep
cd ~/.config/nvim/plugged/youcompleteme \
  && ./install.py --system-libclang --go-completer --js-completer --rust-completer --clang-completer --java-completer
```

## Tips

- Custom command for gnome-terminal / iterm2 : `zsh -c "(tmux ls && tmux at) || tmux new`

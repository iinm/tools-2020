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
test -f ~/.fzf.zsh || ~/tools/opt/fzf/install --all

pyenv install -l
pyenv install $py_version
pyenv global $py_version

gvm listall
gvm install $go_version -B
gvm use $go_version --default

nvm ls-remote
nvm install $node_version
echo 'export PATH=~/tools/opt/nvm/versions/node/$node_version/bin:$PATH' >> ~/.zshenv.local

~/tools/opt/rustup.rs/rustup-init.sh -y --no-modify-path
```

```
pip install neovim

go get github.com/direnv/direnv

cargo install ripgrep
cargo install fd-find

cd ~/.config/nvim/plugged/youcompleteme && ./install.py \
  --system-libclang \
  --go-completer \
  --js-completer \
  --rust-completer \
  --clang-completer \
  --java-completer
```

## Tips

- Custom command for gnome-terminal / iterm2 : `zsh -c "(tmux ls && tmux at) || tmux new"`

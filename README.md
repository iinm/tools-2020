# tools

Development tools and configurations (a.k.a. dotfiles)

## Install

```sh
# darwin
brew install zsh tmux vim git tig ripgrep fd coreutils gnu-sed
# arch linux
sudo pacman -Sy zsh tmux gvim git tig ripgrep fd
```

```sh
git clone --recursive https://github.com/iinm/tools.git ~/tools
cd ~/tools
bash link.sh
```

## Setup

```sh
# fzf
test -f ~/.fzf.zsh || ~/tools/opt/fzf/install --all

# python
pyenv install -l
pyenv install $py_version
pyenv global $py_version

# go
gvm listall
gvm install $go_version -B
gvm use $go_version --default

# node
enable-nvm
nvm ls-remote
nvm install $node_version
echo 'export PATH=~/tools/opt/nvm/versions/node/$node_version/bin:$PATH' >> ~/.zshenv.local

# rust
~/tools/opt/rustup.rs/rustup-init.sh -y --no-modify-path

# etc.
echo "\n[include]\npath = ~/tools/.gitconfig" >> ~/.gitconfig
go get github.com/direnv/direnv
```

## Tips

- Custom command for gnome-terminal / iterm2 : `zsh -c "(tmux ls && tmux at) || tmux new"`

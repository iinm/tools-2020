# tools

Development tools and configurations (a.k.a. dotfiles)

## Install

```sh
# darwin
brew install zsh tmux git tig ripgrep fd coreutils gnu-sed
# arch linux
sudo pacman -Sy zsh tmux git tig ripgrep fd xsel
# ubuntu
sudo apt install zsh tmux git tig ripgrep fd-find xsel
```

```sh
git clone --recursive https://github.com/iinm/tools.git ~/tools
cd ~/tools
bash link.sh
```

## Setup

```sh
# git config
echo "\n[include]\npath = ~/tools/.gitconfig" >> ~/.gitconfig

# fzf
test -f ~/.fzf.zsh || ~/tools/opt/fzf/install --all

# java
bash ~/tools/opt/jabba/install.sh
source ~/.jabba/jabba.sh
jabba ls-remote
jabba install $jdk_version
jabba alias default $jdk_version

# python
pyenv install -l
pyenv install $py_version
pyenv global $py_version

# go
gvm listall
gvm install $go_version -B
gvm use $go_version --default

# node
load_nvm
nvm ls-remote
nvm install $node_version
echo 'export PATH=$TOOLS/opt/nvm/versions/node/$node_version/bin:$PATH' >> ~/.zshenv.local

# rust
~/tools/opt/rustup.rs/rustup-init.sh -y --no-modify-path
```

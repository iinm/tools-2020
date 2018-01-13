#!/bin/zsh

function setup_fzf() {
  if [ -f ~/.fzf.zsh ]; then
    return
  fi
  ~/tools/opt/fzf/install --all
}

function setup_pyenv() {
  py_version=$(pyenv install -l | fzf)
  if [ ! -z $py_version ]; then
    pyenv install $py_version && pyenv global $py_version
  fi
}

function setup_gvm() {
  go version && return
  go_version=$(gvm listall | fzf)
  gvm install $go_version -B && gvm use $go_version --default
}

function setup_nvm() {
  #node -v && return
  node_version=$(nvm ls-remote | fzf | grep -oE 'v[0-9.]+')
  nvm install $node_version && echo 'TODO: edit .zshenv.local end set path'
}

function setup_rust() {
  cargo --version && return
  ~/tools/opt/rustup.rs/rustup-init.sh -y --no-modify-path
}

setup_fzf
#setup_pyenv
#setup_gvm
#setup_nvm
#setup_rust

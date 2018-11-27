#zmodload zsh/zprof

export LANG=en_US.UTF-8

# homebrew
if [ -x /usr/local/bin/brew ]; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

# $HOME/tools
#tools_dir=$(cd $(dirname $0) && pwd)
tools_dir=$HOME/tools

#export PATH=$tools_dir/bin:$PATH

## pyenv
export PYTHON_CONFIGURE_OPTS="--enable-shared"
export PYENV_ROOT=$tools_dir/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
function pyenv() {
  eval "$($PYENV_ROOT/bin/pyenv init -)"
  $PYENV_ROOT/bin/pyenv "$@"
}

## gvm
export GVM_ROOT=$tools_dir/opt/gvm
source $GVM_ROOT/scripts/gvm-default

## direnv; go get github.com/direnv/direnv
direnv &> /dev/null && eval "$(direnv hook zsh)"

## nvm
export NVM_DIR=$tools_dir/opt/nvm
function load_nvm() {
  test -s $NVM_DIR/nvm.sh && source $NVM_DIR/nvm.sh 2> /dev/null
}

## fasd
export PATH=$tools_dir/opt/fasd:$PATH
eval "$(fasd --init auto)"

## rust
export PATH=$HOME/.cargo/bin:$PATH

# load machine specific config
test -f $HOME/.zshenv.local && source $HOME/.zshenv.local

# clean out duplicate entries
typeset -U path PATH

#zmodload zsh/zprof

# homebrew
if test -x /usr/local/bin/brew; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

if which greadlink &> /dev/null; then
  alias readlink=greadlink
fi
this_file=$(readlink -f ${(%):-%x})

export TOOLS=$(cd $(dirname $this_file) && pwd)
export LANG=en_US.UTF-8

export PATH=$TOOLS/bin:$PATH

# pyenv
export PYTHON_CONFIGURE_OPTS="--enable-shared"
export PYENV_ROOT=$TOOLS/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# gvm
export GVM_ROOT=$TOOLS/opt/gvm
source $GVM_ROOT/scripts/gvm-default

# nvm
export NVM_DIR=$TOOLS/opt/nvm
function enable-nvm() {
  source $NVM_DIR/nvm.sh
}

# rust
export PATH=$HOME/.cargo/bin:$PATH

# host specific config
if test -f ~/.zshenv.local; then
  source ~/.zshenv.local
fi

# clean out duplicate entries
typeset -U path PATH

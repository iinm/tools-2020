#zmodload zsh/zprof

export OS=$(uname)

# homebrew
if test -x /usr/local/bin/brew; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

if test "$OS" = 'Darwin'; then
  alias readlink=greadlink
fi
this_file=$(readlink -f ${(%):-%x})

export TOOLS=$(cd $(dirname $this_file) && pwd)
export LANG=en_US.UTF-8
export PATH=$TOOLS/bin:$TOOLS/local/bin:$PATH

# pyenv
export PYENV_ROOT=$TOOLS/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# gvm
export GVM_ROOT=$TOOLS/opt/gvm
source $GVM_ROOT/scripts/gvm-default

# nvm
export NVM_DIR=$TOOLS/opt/nvm
load_nvm() { source $NVM_DIR/nvm.sh }

# rust
export PATH=$HOME/.cargo/bin:$PATH

# jabba
load_jabba() { source $HOME/.jabba/jabba.sh }

# host specific config
if test -f ~/.zshenv.local; then
  source ~/.zshenv.local
fi

# clean out duplicate entries
typeset -U path PATH

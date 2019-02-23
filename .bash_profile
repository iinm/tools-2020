export OS=$(uname)

export TOOLS=~/tools
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
if test -f ~/.bash_profile.local; then
  source ~/.bash_profile.local
fi

if (echo "$-" | grep -q 'i') && [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

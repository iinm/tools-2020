#zmodload zsh/zprof

export LANG=en_US.UTF-8

# homebrew
if [ -x /usr/local/bin/brew ]; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

tools_dir=$HOME/tools

# pyenv
export PYTHON_CONFIGURE_OPTS="--enable-shared"
export PYENV_ROOT=$tools_dir/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# gvm
export GVM_ROOT=$tools_dir/opt/gvm
source $GVM_ROOT/scripts/gvm-default

# direnv; go get github.com/direnv/direnv
which direnv &> /dev/null && eval "$(direnv hook zsh)"

# nvm
#export NVM_DIR=$tools_dir/opt/nvm
export NVM_DIR=~/.etc/tools/opt/nvm
function enable-nvm() {
  source $NVM_DIR/nvm.sh
}

# fasd
export PATH=$tools_dir/opt/fasd:$PATH
eval "$(fasd --init auto)"

# rust
export PATH=$HOME/.cargo/bin:$PATH

# machine specific config
test -f $HOME/.zshenv.local && source $HOME/.zshenv.local

# clean out duplicate entries
typeset -U path PATH

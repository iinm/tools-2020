export LANG=en_US.UTF-8

# $HOME/tools
#tools_dir=$(cd $(dirname $0) && pwd)
tools_dir=$HOME/tools

#export PATH=$tools_dir/bin:$PATH

## pyenv
export PYENV_ROOT=$tools_dir/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

## gvm
export GVM_ROOT=$tools_dir/opt/gvm
source $GVM_ROOT/scripts/gvm-default

## nvm
export NVM_DIR=$tools_dir/opt/nvm
test -s $NVM_DIR/nvm.sh && source $NVM_DIR/nvm.sh

## autoenv
# TODO oh-my-zsh 含まれているものを使う
source $tools_dir/opt/zsh-autoenv/autoenv.zsh


# load machine specific config
test -f $HOME/.zshenv.local && source $HOME/.zshenv.local

# clean out duplicate entries
typeset -U path PATH


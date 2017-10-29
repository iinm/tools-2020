source $HOME/tools/opt/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle Tarrasch/zsh-autoenv

# Load the theme.
#antigen theme robbyrussell
#antigen theme wezm
antigen theme candy

# Tell Antigen that you're done.
antigen apply


alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
if (uname | grep -qE "Darwin|BSD"); then
    alias ls="ls -FG"
else
    alias ls="ls --color=auto -F"
fi

alias view="nvim -R"

export TERM=xterm-256color
export EDITOR=nvim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function fcd() {
  dir=$(fasd_cd -dl | fzf)
  echo $dir
  cd $dir
}

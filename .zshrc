source $HOME/tools/opt/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle docker

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

if (uname | grep -qE "Linux"); then
  alias pbcopy="xsel -i -p && xsel -o -p | xsel -i -b"
  alias pbpaste="xsel -o"
  alias open="xdg-open"
fi

export TERM=xterm-256color
export EDITOR=nvim

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  zle     -N   fzf-file-widget
  bindkey '^Y' fzf-file-widget

  function fz() {
    dir=$(fasd_cd -dl | fzf-tmux) && cd "$dir"
  }

  # open file
  function fo() {
    f=$(fzf-tmux) && open "$f"
  }

  # cd
  function fcd() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf-tmux) && cd "$dir"
  }
fi

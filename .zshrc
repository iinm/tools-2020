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
#antigen theme candy
PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%X]} %{$reset_color%}%{$fg[green]%}[%~]%{$reset_color%} $(git_prompt_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

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

  #export FZF_DEFAULT_COMMAND="rg --hidden --glob '!.git' --glob '!*~' --files ."
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude "*~"'
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS

  function fz() {
    dir=$(fasd_cd -dlR | fzf) && cd "$dir"
  }

  # open file
  function fo() {
    f=$(fzf) && open "$f"
  }

  # cd
  function fcd() {
    local dir
    #dir=$(find ${1:-.} -type d 2> /dev/null | fzf) && cd "$dir"
    dir=$(fd --type d --hidden --follow --exclude .git 2> /dev/null | fzf) && cd "$dir"
  }
fi

function with_notify() {
  message="$@"
  $@
  RET=$?
  if [ $RET -eq 0 ]; then
    title="Success 😁"
  else
    title="Fail 😨"
  fi
  # Macの通知
  osascript -e "display notification \"${message//\"/\\\"}\" with title \"${title//\"/\\\"}\""
  return $RET
}

test -f $HOME/.zshrc.local && source $HOME/.zshrc.local

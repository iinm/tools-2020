fpath=($HOME/tools/opt/my-zsh-completions $HOME/tools/opt/zsh-completions/src $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*:default' menu select=2
setopt interactive_comments

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=50000
setopt hist_ignore_dups
setopt extended_history
setopt append_history
setopt share_history
setopt inc_append_history

export PROMPT='%B%#%b '

function show_status() {
  echo
  pwd
  git symbolic-ref --short HEAD 2> /dev/null
  zle reset-prompt
}
zle -N show_status
bindkey '^U' show_status

export TERM=xterm-256color
export EDITOR=nvim

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

alias gco="git checkout"
alias gst="git status"
alias gl="git pull"

alias t="~/tools/opt/todo.txt-cli/todo.sh -d ~/notes/todo.cfg"

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

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi

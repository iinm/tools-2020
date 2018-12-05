fpath=($HOME/tools/opt/my-zsh-completions $HOME/tools/opt/zsh-completions/src $fpath)

zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:default' menu select=2
autoload -Uz compinit && compinit

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=50000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

autoload -Uz colors; colors
autoload -Uz vcs_info
precmd() { vcs_info }
# format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}+%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}!%f"
zstyle ':vcs_info:*' formats "%c%u%F{green}%b%f"
zstyle ':vcs_info:*' actionformats '%F{magenta}%b|%a%f'
setopt PROMPT_SUBST

#PROMPT='%B%#%b '
PROMPT=$'%(?..%F{red}=> %?\n%f)%F{cyan}${PWD/#$HOME/~}%f ${vcs_info_msg_0_}\n%B_>%b '
#PROMPT=$'%(?..%B=> %?%b\n)%B${PWD/#$HOME/~} ${vcs_info_msg_0_}\n_>%b '

setopt INTERACTIVE_COMMENTS

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

# plugins
source ~/tools/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/tools/opt/zsh-autosuggestions/zsh-autosuggestions.zsh


test -f $HOME/.zshrc.local && source $HOME/.zshrc.local

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi

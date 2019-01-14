fpath=($TOOLS/opt/local/zsh-functions $TOOLS/opt/zsh-completions/src $fpath)


# --- history
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


# --- completion
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:default' menu select=2
if which gdircolors &> /dev/null; then
  alias dircolors=gdircolors
fi
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit && compinit -C


# --- looks
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


# --- etc.
setopt INTERACTIVE_COMMENTS

export TERM=xterm-256color
export EDITOR=vim


# --- alias
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
if (uname | grep -qE "Darwin|BSD"); then
    alias ls="ls -FG"
else
    alias ls="ls --color=auto -F"
fi
alias la="ls -alh"
alias ll="ls -lh"

alias gco="git checkout"
alias gst="git status"
alias gl="git pull"
alias gcd='cd $(git rev-parse --show-toplevel)'
alias gsm='git submodule'

alias dco="docker-compose"

if (uname | grep -qE "Linux"); then
  alias pbcopy="xsel -i -p && xsel -o -p | xsel -i -b"
  alias pbpaste="xsel -o"
  alias open="xdg-open"
fi

# for darwin
if which gsed &> /dev/null; then
  alias sed="gsed"
fi
if which gdate &> /dev/null; then
  alias date="gdate"
fi


# --- key bind
bindkey -e

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  zle     -N   fzf-file-widget
  bindkey '^Y' fzf-file-widget

  #export FZF_DEFAULT_COMMAND="rg --hidden --glob '!.git' --glob '!*~' --files ."
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude "*~"'
  export FZF_DEFAULT_OPTS='--reverse'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
fi


# --- plugins
if test ! -f $TOOLS/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh.zwc; then
  for f in $(find $TOOLS/opt/zsh-syntax-highlighting -name "*.zsh"); do zcompile $f; done
fi
source $TOOLS/opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $TOOLS/opt/zsh-autosuggestions/zsh-autosuggestions.zsh

# direnv; go get github.com/direnv/direnv
if which direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# fasd
export PATH=$TOOLS/opt/fasd:$PATH
eval "$(fasd --init auto)"


# --- functions
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

function with-notify() {
  message="$@"
  $@
  RET=$?
  if [ $RET -eq 0 ]; then
    title="Success 😁"
  else
    title="Fail 😨"
  fi
  # darwin
  if which osascript &> /dev/null; then
    osascript -e "display notification \"${message//\"/\\\"}\" with title \"${title//\"/\\\"}\""
  fi
  # linux
  if which notify-send &> /dev/null; then
    notify-send "${title}" "${message}"
  fi
  return $RET
}

# fzf godoc; requires gnu sed
FGODOC_ENTRIES_FILE=~/.fgodoc-entries
function fgodoc-update() {
  for package in $(cd ~ && go list ... 2> /dev/null); do
    echo $package
    for elem in $(godoc $package | sed -En 's/^(type|func) (\w+).+/\2/p'); do
      echo $package.$elem
    done
    for elem in $(godoc $package | sed -En 's/^func \(\w* \*?(\w+)\) (\w+)\(.+/\1.\2/p'); do
      echo $package.$elem
    done
  done | sort > $FGODOC_ENTRIES_FILE
}

function fgodoc() {
  go doc $(fzf < $FGODOC_ENTRIES_FILE)
}


# --- machine specific config
if test -f ~/.zshrc.local; then
  source ~/.zshrc.local
fi


# --- clean out duplicate entries
typeset -U path PATH


# --- profile
if which zprof &> /dev/null; then
  zprof
fi

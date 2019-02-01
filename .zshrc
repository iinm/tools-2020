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
if test $OS = 'Darwin'; then
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
export VIM_NOTES_TEMPLATE="$TOOLS/vim-notes-template"


# --- alias
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
if test $OS = 'Darwin'; then
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
alias gcb='git rev-parse --abbrev-ref HEAD'
alias gsm='git submodule'

alias dco="docker-compose"

if test $OS = 'Linux'; then
  alias pbcopy="xsel -i -p && xsel -o -p | xsel -i -b"
  alias pbpaste="xsel -o"
  alias open="xdg-open"
fi

# for darwin
if test $OS = 'Darwin'; then
  alias sed="gsed"
  alias date="gdate"
fi

alias rg="rg --hidden"


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

# fzf git checkout
function fgco() {
  git checkout $(git branch --all --sort=-committerdate | fzf)
}

# fzf git diff
function fgdiff() {
  git diff $@ --name-only | sort | fzf --preview "git diff --color $@ {}" --bind "enter:execute:git diff --color $@ {} | less -R"
}

# fzf rg; requires highlight
function frg() {
  LINES=$(( $(tput lines) * 4 / 10 ))
  previewer="env LINES=$LINES $TOOLS/.vim/pack/_/opt/fzf.vim/bin/preview.sh"
  rg --line-number $@ \
    | fzf --preview "$previewer {}" --preview-window down:${LINES}:hidden:wrap --bind '?:toggle-preview'
}

function frg-vim() {
  line=$(frg $@)
  test -z "$line" && return 1
  vim $(echo $line | sed -En 's/^([^:]+):([0-9]+):.+/\1 +\2/p')
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
  cat $FGODOC_ENTRIES_FILE \
    | fzf --preview 'go doc  {}' --preview-window hidden --bind '?:toggle-preview' --bind 'enter:execute:go doc {} | less'
}

# slack
function slack-post-message() {
  : ${SLACK_API_TOKEN:?}
  channel=${2:?}
  text=${3:?}
  text_escaped=${text//\"/\\\"} # replace " -> \"
  curl -X POST 'https://slack.com/api/chat.postMessage' \
    --data "{\"channel\": \"${channel}\", \"text\": \"${text_escaped}\"}" \
    -H "Authorization: Bearer $SLACK_API_TOKEN" \
    -H 'Content-type: application/json'
}

# gitlab
function gitlab-create-merge-request() {
  : ${GITLAB_BASE_URL:?}
  : ${GITLAB_PROJECT_ID:?}
  : ${GITLAB_PRIVATE_TOKEN:?}
  source_branch=${1:?}
  target_branch=${2:?}
  title=${3:-"Merge branch '${source_branch}' into '${target_branch}'"}
  curl -X POST \
    $GITLAB_BASE_URL/api/v3/projects/$GITLAB_PROJECT_ID/merge_requests \
    --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" \
    -F "source_branch=$source_branch" \
    -F "target_branch=$target_branch" \
    -F "title=$title"
}

function gitlab-get-merge-requests() {
  : ${GITLAB_BASE_URL:?}
  : ${GITLAB_PROJECT_ID:?}
  : ${GITLAB_PRIVATE_TOKEN:?}
  params=${1:-"state=opened&per_page=10000"}
  curl --silent -X GET \
    "$GITLAB_BASE_URL/api/v3/projects/$GITLAB_PROJECT_ID/merge_requests?$params" \
    -H "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN"
}

function gitlab-ls-mr() {
  gitlab-get-merge-requests \
    | jq --raw-output '.[] | [.title, .author.username, .source_branch, .target_branch, .web_url] | @tsv' \
    | awk \
        -F '\t' \
        -v bold=$(tput bold) -v blue=$(tput setaf 4) -v green=$(tput setaf 2) -v black=$(tput setaf 0) -v reset=$(tput sgr0) \
        '{ print "・" $1  " " bold " by " reset blue $2 reset "  " black "#(" $3 " -> " $4 ")  " $5 reset }' \
    | fzf \
        --ansi \
        --preview "echo {} | grep -Eo '#\(.+'" \
        --preview-window down:2:wrap \
        --bind 'enter:execute:source ~/.zshrc; open-url-in-text {}'
}

function open-url-in-text() {
  url=$(echo ${1:?} | grep -Eo 'https?://[0-9a-zA-Z?=#+_&:/.%]+')
  open $url
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

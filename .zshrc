# --- These variables should be set with ~/.zshenv
: ${OS?}
: ${TOOLS?}


fpath=($TOOLS/local/share/zsh-functions $TOOLS/opt/zsh-completions/src $fpath)


# --- history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=50000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY


# --- completion
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:default' menu select=2
if test "$OS" = 'Darwin'; then
  alias dircolors=gdircolors
fi
eval "$(dircolors)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
autoload -Uz compinit && compinit -Cu


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
export EDITOR=nvim


# --- alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
if test "$OS" = 'Darwin'; then
  alias ls='ls -FG'
else
  alias ls='ls --color=auto -F'
fi
alias la='ls -alh'
alias ll='ls -lh'

alias gco='git checkout'
alias gst='git status'
alias gl='git pull'
alias gcd='cd $(git rev-parse --show-toplevel)'
alias gcb='git rev-parse --abbrev-ref HEAD'
alias gsm='git submodule'

alias dco='docker-compose'

if test "$OS" = 'Linux'; then
  alias pbcopy='xsel -i -p && xsel -o -p | xsel -i -b'
  alias pbpaste='xsel -o -b'
  alias open='xdg-open'
fi

# for darwin
if test "$OS" = 'Darwin'; then
  alias sed='gsed'
  alias date='gdate'
fi

alias rg='rg --hidden'
alias view='nvim -R'
alias :e='nvim'
alias random-str='openssl rand -base64 32'


# --- key bind
bindkey -e

if test -f ~/.fzf.zsh; then
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

#if which kubectl &> /dev/null; then
#  source <(kubectl completion zsh)
#fi


# --- functions
fz() {
  dir=$(fasd_cd -dlR | fzf) && cd "$dir"
}

# cd
fcd() {
  local dir
  #dir=$(find ${1:-.} -type d 2> /dev/null | fzf) && cd "$dir"
  dir=$(fd --type d --hidden --follow --exclude .git 2> /dev/null | fzf) && cd "$dir"
}

# fzf git checkout
fgco() {
  git checkout $(git branch --all --sort=-committerdate | fzf)
}

# fzf git diff
fgdiff() {
  git diff "$@" --name-only | sort | fzf --preview "git diff --color $@ {}" --bind "enter:execute:git diff --color $@ {} | less -R"
}

# fzf rg; requires highlight
frg() {
  LINES=$(( $(tput lines) * 4 / 10 ))
  previewer="env LINES=$LINES $TOOLS/.vim/pack/_/opt/fzf.vim/bin/preview.sh"
  rg --line-number $@ \
    | fzf --preview "$previewer {}" --preview-window down:${LINES}:hidden:wrap --bind '?:toggle-preview'
}

# desktop notification
with_notification() {
  message="$@"
  if "$@"; then
    exit_code="$?"
    title="Success 😁"
  else
    exit_code="$?"
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
  return "$exit_code"
}

nvim_list_unneeded_packs() {
  for pack in $(find ~/.config/nvim/pack/_/opt/ -mindepth 1 -maxdepth 1 -type d); do
    if ! grep -qE "packadd.+$(basename $pack)" ~/.config/nvim/init.vim; then
      echo "$pack"
    fi
  done
}

update_tags() {
  ctags -R
  gtags -iv
}

csv2excel() {
  fname="${1:?}"
  nkf --oc=UTF-8-BOM "$fname" > "${fname%.csv}.excel.csv"
}


# --- host specific config
if test -f ~/.zshrc.local; then
  source ~/.zshrc.local
fi


# --- clean out duplicate entries
typeset -U path PATH


# --- profile
if which zprof &> /dev/null; then
  zprof
fi

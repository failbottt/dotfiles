# dependecies:
# - rg
# - fzf

# prompt
# ---

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

# exports
# ---

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

export EDITOR=nvim

# aliases
# ---

alias fix="git diff --name-only | uniq | xargs $EDITOR"
alias ls="ls -laG"
alias vim="$EDITOR"
alias vi="$EDITOR"

# functions
# ---

killmatch() {
  pkill -9 -if "$1"
}

# osx
docker_reset() {
  pkill -9 -if "Docker"
  open /Applications/Docker.app
}

docker_fix_ssh() {
    ps aux | grep ssh | awk '{print $2}' | xargs kill -9
    eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
}

# make autocomplete
_makefile_targets() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local targets=""
  if [[ -f Makefile ]]; then
    targets=$(grep -oE '^[a-zA-Z0-9_-]+:' Makefile | sed 's/:$//')
  fi
  COMPREPLY=($(compgen -W "$targets" -- "$cur"))
}
complete -F _makefile_targets make

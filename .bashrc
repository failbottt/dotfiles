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

vf()
{
    local file
    file=$(rg --files | fzf --preview 'cat {}' --preview-window=up:60%) || return
    vim "$file"
}
bind '"\C-f": "vf\n"'

vg() {
    local result
    result=$(fzf --disabled \
        --bind 'change:reload:rg --line-number --no-heading {q} . 2>/dev/null || true' \
        --delimiter : \
        --preview 'grep -n "" {1} | awk -v l={2} "NR==l{print \"\033[7m\" \$0 \"\033[0m\"; next} {print}"' \
        --preview-window=up:60%:+{2} \
        --prompt 'Search: ') || return
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    vim +"$line" "$file"
}
bind '"\C-g": "vg\n"'

hsearch()
{
    local selected cmd
    selected=$(history | fzf --tac --no-sort) || return
    cmd=$(echo "$selected" | awk '{$1=""; print substr($0,2)}')
    eval "$cmd"
}
bind '"\C-r": "hsearch\n"'

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

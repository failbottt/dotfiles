# prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] > "

# git autocomplete
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# export/aliases
# --------------
export EDITOR=nvim
alias vi=$EDITOR
alias vim=$EDITOR
# open large files without any plugins or syntax
alias cvim="vim -u ~/.config/nvim/large-file.vim"

# paths
export GOPATH=$HOME/go
export PATH=$HOME/bin:$HOME/go/bin:$PATH

# control go version
# ref: https://go.dev/doc/manage-install
export GO_VERSION=go1.24.0

# aliases
alias ls="ls -laG"
alias ag="ag --path-to-ignore ~/.ignore"
alias fix="git diff --name-only | uniq | xargs $EDITOR"

# controls fonts for https://github.com/failbottt/go_debugger
export GDLV_NORMAL_FONT="hack.ttf"
export GDLV_BOLD_FONT="hack_bold.ttf"

# functions
# --------------
mkcd() { 
  mkdir -pv $1 
  cd $1 
}

copy() {
    if [[ $(uname) -eq "Darwin" ]]; then
        cat | pbcopy
    else
        cat | xclip -selection clipboard
    fi
}

function docker_fix_ssh() {
    ps aux | grep ssh | awk '{print $2}' | xargs kill -9
    eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
}

function _makefile_targets {
    local curr_arg;
    local targets;

    # Find makefile targets available in the current directory
    targets=''
    if [[ -e "$(pwd)/Makefile" ]]; then
        targets=$( \
            grep -oE '^[a-zA-Z0-9_-]+:' Makefile \
            | sed 's/://' \
            | tr '\n' ' ' \
        )
    fi

    # Filter targets based on user input to the bash completion
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "${targets[@]}" -- $curr_arg ) );
}
complete -F _makefile_targets make

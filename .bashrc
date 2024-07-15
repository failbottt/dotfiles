# prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

# editor
export EDITOR=vim

# paths
export GOPATH=$HOME/go
export PATH=$HOME/bin:$HOME/go/bin:$PATH

# aliases
alias ls="ls -la --color"
alias ag="ag --path-to-ignore ~/.ignore"
alias vi="nvim"
alias vim="nvim"

# git autocomplete
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# functions
mkcd() { 
  mkdir -pv $1 
  cd $1 
}

copy() {
	cat | xclip -selection clipboard
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

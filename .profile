parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] > "

export EDITOR=vi
alias vim=$EDITOR

export GOPATH=$HOME/go
export PATH=$HOME/bin:$HOME/go/bin:$PATH

# control go version
# ref: https://go.dev/doc/manage-install
export GO_VERSION=go1.24.0

alias ls="ls -laG"
alias fix="git diff --name-only | uniq | xargs $EDITOR"

f() {
    # List of directories to ignore
    local ignore_dirs=(
    ./node_modules ./.git ./.venv ./env ./__pycache__ ./build ./vendor ./composer
    ./dist ./.next ./.cache ./coverage ./target ./out ./.gradle ./bin ./pkg
    ./.idea ./.vscode ./.svn ./.hg
    )

    # Start building the find prune expression
    local prune_expr=""
    for d in "${ignore_dirs[@]}"; do
    prune_expr="$prune_expr -path \"$d\" -o"
    done

    # Remove trailing -o
    prune_expr="${prune_expr% -o}"

    # Execute find with proper escaping for parentheses
    eval find . \\( $prune_expr \\) -prune -o -type f \
    ! -name "*.log" \
    ! -name "*.tmp" \
    ! -name "*.pyc" \
    ! -name "*.class" \
    ! -name "*.o" \
    ! -name "*.exe" \
    ! -name "*.dll" \
    "$@" -print
}

s()
{
  grep -r \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    --exclude-dir=.venv \
    --exclude-dir=env \
    --exclude-dir=__pycache__ \
    --exclude-dir=build \
    --exclude-dir=vendor \
    --exclude-dir=composer \
    --exclude-dir=dist \
    --exclude-dir=.next \
    --exclude-dir=.cache \
    --exclude-dir=coverage \
    --exclude-dir=target \
    --exclude-dir=out \
    --exclude-dir=.gradle \
    --exclude-dir=bin \
    --exclude-dir=pkg \
    --exclude-dir=.idea \
    --exclude-dir=.vscode \
    --exclude-dir=.svn \
    --exclude-dir=.hg \
    "$@"
}

mkcd() 
{
  mkdir -pv $1
  cd $1
}

copy() 
{
    if [[ $(uname) -eq "Darwin" ]]; then
        cat | pbcopy
    else
        cat | xclip -selection clipboard
    fi
}

function docker_fix_ssh() 
{
    ps aux | grep ssh | awk '{print $2}' | xargs kill -9
    eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
}

function kill_vim_instances()
{
    killall -9 nvim
}

function kill_all_docker_containers()
{
    docker container list | awk '{print $1}' | grep -v CONTAINER | xargs -I {} docker container stop {}
}

function ls_makefile_targets
{
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
complete -F ls_makefile_targets make

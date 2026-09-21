export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -r $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if [ -f $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

if [ -f $HOME/.env ]; then
    source $HOME/.env
fi

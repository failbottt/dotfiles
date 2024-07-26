#!/bin/bash                                                                                                                                                                                                                                     
OS=$(uname)

cp -r --force nvim $HOME/.config
cp -r --force bin $HOME/

if [ ! -d "$HOME/.local/" ]; then
    mkdir $HOME/.local
fi

if [ "$OS" == "Linux" ]; then
    echo "LINUX"
    cp -r --force i3 $HOME/.config/
    cp -r --force .fonts $HOME/

    for file in $(echo .*); do 
        if [ $file != "." ] && [ $file != ".." ]; then
            cp -r --force $file $HOME/
        fi 
    done

    # key repeat delay
    xset r rate 150 50

    # set capslock as ctrl
    setxkbmap -option caps:ctrl_modifier

    # reload
    echo "Reload $HOME/i3/config"
    i3-msg reload
    i3-msg restart
fi

if [ "$OS" == "Darwin" ]; then
    echo "OSX"
fi


if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

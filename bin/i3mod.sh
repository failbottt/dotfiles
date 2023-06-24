#/bin/bash

if [ "$1" == "win" ]; then
    sed -i 's/set\ \$mod Mod1/set\ \$mod\ Mod4/g' $HOME/.config/i3/config
fi

if [ "$1" == "alt" ]; then
    sed -i 's/set\ \$mod Mod4/set\ \$mod\ Mod1/g' $HOME/.config/i3/config
fi

i3-msg reload
i3-msg restart

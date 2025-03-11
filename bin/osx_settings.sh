#!/bin/sh

# make dock animation faster
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
killall Dock

# key repeats
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

#!/usr/bin/bash

# Delete configs
rm -Rf ~/.config/nvim
rm -Rf ~/.local/share/nvim/

# Copy config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
cp no-packages-init.lua ~/.config/nvim/init.lua
cp no-packages-snips.lua ~/.config/nvim/lua

cp help.txt ~/.config/nvim


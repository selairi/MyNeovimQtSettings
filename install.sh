#!/usr/bin/bash

# Delete configs
rm -Rf ~/.config/nvim
rm -Rf ~/.local/share/nvim/

# Copy example snippet
mkdir -p ~/.config/nvim/snippets
cp c.snippets ~/.config/nvim/snippets

# Install package manager
mkdir -p ~/.local/share/nvim/site/pack/git-plugins/start
#cd ~/.local/share/nvim/site/pack/git-plugins/start

# Install package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/git-plugins/start/packer.nvim
mkdir -p ~/.config/nvim
cp init-packer.lua ~/.config/nvim/init.lua
nvim +"PackerUpdate"

# # Install LSP
# git clone --depth 1 https://github.com/neovim/nvim-lspconfig.git
# # Install Mason
# git clone --depth 1 https://github.com/williamboman/mason.nvim
# git clone --depth 1 https://github.com/williamboman/mason-lspconfig.nvim
# git clone --depth 1 https://github.com/mfussenegger/nvim-dap
# git clone --depth 1 https://github.com/mfussenegger/nvim-lint
# git clone --depth 1 https://github.com/mhartington/formatter.nvim
# # Snippets
# git clone --depth 1 https://github.com/tomtom/tlib_vim.git
# git clone --depth 1 https://github.com/MarcWeber/vim-addon-mw-utils.git
# git clone --depth 1 https://github.com/garbas/vim-snipmate.git
# git clone --depth 1 https://github.com/honza/vim-snippets.git
# # Airline
# git clone --depth 1 https://github.com/vim-airline/vim-airline.git
# # Git helper
# git clone --depth 1 https://github.com/tpope/vim-fugitive.git


# Install Java, Javascript and Python LSP
cat << EOF >> ~/.config/nvim/init.lua

-- Mason config
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

EOF

nvim +"MasonInstall jdtls eslint-lsp python-lsp-server rust-analyzer"

# Copy nvim settings
cat init.lua >> ~/.config/nvim/init.lua
cp ginit.vim help.txt ~/.config/nvim


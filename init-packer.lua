local use = require('packer').use
require('packer').startup(function()
  -- Exec ":PackerInstall" in Neovim to install plugins
  -- ":PackerUpdate" to update plugins
  -- ":PackerClean" Remove any disabled or unused plugins
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  -- mason.nvim a tool to install LSP servers
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-lint'
  use 'mhartington/formatter.nvim'
  -- Snippets
  use 'tomtom/tlib_vim'
  use 'MarcWeber/vim-addon-mw-utils'
  use 'garbas/vim-snipmate'
  use 'honza/vim-snippets'
  -- Airline
  use 'vim-airline/vim-airline'
  -- Git helper
  use 'tpope/vim-fugitive'
  -- Buffer list gui
  use 'jeetsukumaran/vim-buffergator'
  -- Menus
  use 'skywind3000/vim-quickui' 
  -- Colorschemes
  use 'flazz/vim-colorschemes'
  -- Tagbar: Code browser based on ctags
  use 'preservim/tagbar'
end)

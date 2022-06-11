-- lua version of vim script VimPlug
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('nvim-treesitter/nvim-treesitter')
Plug('neovim/nvim-lspconfig')
Plug('morhetz/gruvbox')
Plug('ray-x/go.nvim')
Plug('ray-x/guihua.lua')
vim.call('plug#end')

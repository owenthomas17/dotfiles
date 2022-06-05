-- lua version of vim script VimPlug
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('nvim-treesitter/nvim-treesitter')
Plug('neovim/nvim-lspconfig')
Plug('morhetz/gruvbox')
vim.call('plug#end')

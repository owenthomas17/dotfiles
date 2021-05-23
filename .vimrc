" Set runtime path
set runtimepath=~/.vim,/usr/share/vim/vim81

" Use Gruvbox
autocmd vimenter * nested colorscheme gruvbox
set background=dark

" Show visual 'ruler'
set colorcolumn=120

" Vim defaults
set history=200   " keep 200 lines of command line history
set ruler        " show the cursor position all the time
set showcmd       " display incomplete commands
set wildmenu     " display completion matches in a status line

" Enable fuzzy type search with :find
set path+=**

" Show @@@ in the last line if it is truncated.
set display=truncate

" Set relative line numbers
set relativenumber

" Show line numbers
set number

" When scrolling show context of n lines
set scrolloff=10

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Highlight text as you are searching
set incsearch

" Set terminal colors
set t_Co=256

" File explorer settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Set leader key
let mapleader = " "

" Custom leader shortcuts
map <leader>t :bel terminal ++rows=15<CR>
map <leader>e :Vexplore<CR>
map <leader>q :quit<CR>
map <leader>d :confirm xall<CR>
map <leader>gd :ALEGoToDefinition<CR>

"Use the following linters. Linters need to be enabled in order for
"go-to-definition to work correctly
let g:ale_linters = {
  \ 'go': ['gopls'],
  \ 'python': ['pyls'],
  \ 'terraform': ['terraform_lsp'],
  \}

" Enable omni complete but trigger manually. Default key combination is
" <C-x><C-o>
set omnifunc=ale#completion#OmniFunc

" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

set list
set listchars=trail:¬

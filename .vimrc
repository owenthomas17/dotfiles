" Setting vimpath
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim81,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after

filetype plugin indent on
set showcmd 

" Sort out colors
set background=dark
syntax on

" Show visual 'ruler' 
set colorcolumn=120
highlight ColorColumn ctermbg=Green

" Vim defaults
set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

" Setting tabbing for python/go files
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4

filetype indent on

" Enable fuzzy type search with :find
set path+=**

" Show @@@ in the last line if it is truncated.
set display=truncate

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

" 
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Highlight text as you are searching
set incsearch
